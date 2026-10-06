import Foundation
import XCTest
@testable import DWARF
import DWARFC
import DWARFMachO
import DWARFELF

final class DWARF3RangeListTests: XCTestCase {
    func testListResolvesRangesInMachOAndELF() throws {
        var data = Data()
        append(0x10, to: &data, size: 4, endian: .little)
        append(0x30, to: &data, size: 4, endian: .little)
        append(UInt64(UInt32.max), to: &data, size: 4, endian: .little)
        append(0x5000, to: &data, size: 4, endian: .little)
        append(0x20, to: &data, size: 4, endian: .little)
        append(0x40, to: &data, size: 4, endian: .little)
        append(0, to: &data, size: 4, endian: .little)
        append(0, to: &data, size: 4, endian: .little)

        for version: DWARFVersion in [.v3, .v4] {
            var layout = dwarf4_cu_header32_t()
            layout.version = version.rawValue
            layout.address_size = 4
            let header = DWARFCompilationUnitHeader.upToVersion4_32(
                .init(layout: layout, offset: 0)
            )

            try UnitTypeBinaryFixture.withLegacyRanges(
                header: header,
                lowPC: 0x1000,
                debugRanges: data
            ) { machO, machOUnit, elf, elfUnit in
                let machOEntry = try XCTUnwrap(
                    DWARF3RangeList.load(at: 0, for: machOUnit, in: machO)
                )
                let elfEntry = try XCTUnwrap(
                    DWARF3RangeList.load(at: 0, for: elfUnit, in: elf)
                )
                let expected: [DWARFRange] = [
                    .init(start: address(0x1010), end: address(0x1030)),
                    .init(start: address(0x5020), end: address(0x5040)),
                ]
                XCTAssertEqual(
                    machOEntry.ranges(for: machOUnit, in: machO),
                    expected,
                    "\(version)"
                )
                XCTAssertEqual(
                    elfEntry.ranges(for: elfUnit, in: elf),
                    expected,
                    "\(version)"
                )
            }
        }
    }

    func testParsesEntriesInBothByteOrdersAndAddressSizes() {
        for endian: Endian in [.little, .big] {
            for addressSize in [4, 8] {
                let maximumAddress = addressSize == 8
                    ? UInt64.max
                    : UInt64(UInt32.max)
                var data = Data([0xaa])
                append(maximumAddress, to: &data, size: addressSize, endian: endian)
                append(0x1020, to: &data, size: addressSize, endian: endian)
                append(0x10, to: &data, size: addressSize, endian: endian)
                append(0x30, to: &data, size: addressSize, endian: endian)
                append(0x40, to: &data, size: addressSize, endian: endian)
                append(0x40, to: &data, size: addressSize, endian: endian)
                append(0, to: &data, size: addressSize, endian: endian)
                append(0, to: &data, size: addressSize, endian: endian)
                data.append(0xbb)

                let entries = DWARF3RangeList._parseEntries(
                    data: Data(data.dropFirst()),
                    addressSize: addressSize,
                    endian: endian
                )

                XCTAssertEqual(
                    entries,
                    [
                        .baseAddressSelection(address: 0x1020),
                        .range(beginningOffset: 0x10, endOffset: 0x30),
                        .range(beginningOffset: 0x40, endOffset: 0x40),
                        .endOfList,
                    ],
                    "\(endian), address size \(addressSize)"
                )
            }
        }
    }

    func testRejectsTruncatedOrUnterminatedLists() {
        var truncated = Data()
        append(1, to: &truncated, size: 4, endian: .little)
        append(2, to: &truncated, size: 3, endian: .little)
        XCTAssertNil(
            DWARF3RangeList._parseEntries(
                data: truncated,
                addressSize: 4,
                endian: .little
            )
        )

        var unterminated = Data()
        append(1, to: &unterminated, size: 4, endian: .little)
        append(2, to: &unterminated, size: 4, endian: .little)
        XCTAssertNil(
            DWARF3RangeList._parseEntries(
                data: unterminated,
                addressSize: 4,
                endian: .little
            )
        )
    }

    func testRejectsInvalidAddressSizesAndDescendingRanges() {
        XCTAssertNil(
            DWARF3RangeList._parseEntries(
                data: Data(repeating: 0, count: 16),
                addressSize: 0,
                endian: .little
            )
        )
        XCTAssertNil(
            DWARF3RangeList._parseEntries(
                data: Data(repeating: 0, count: 18),
                addressSize: 9,
                endian: .little
            )
        )

        var descending = Data()
        append(2, to: &descending, size: 4, endian: .little)
        append(1, to: &descending, size: 4, endian: .little)
        append(0, to: &descending, size: 4, endian: .little)
        append(0, to: &descending, size: 4, endian: .little)
        XCTAssertNil(
            DWARF3RangeList._parseEntries(
                data: descending,
                addressSize: 4,
                endian: .little
            )
        )
    }
}

extension DWARF3RangeListTests {
    private func append(
        _ value: UInt64,
        to data: inout Data,
        size: Int,
        endian: Endian
    ) {
        let indices = endian == .little
            ? Array(0 ..< size)
            : Array((0 ..< size).reversed())
        for index in indices {
            data.append(UInt8(truncatingIfNeeded: value >> (index * 8)))
        }
    }

    private func address(_ value: UInt64) -> DWARFAddress {
        .init(segmentSelector: nil, address: value)
    }
}
