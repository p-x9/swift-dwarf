import Foundation
import XCTest
@testable import DWARF
import DWARFC
import DWARFMachO
import DWARFELF

final class DWARF3LocationListTests: XCTestCase {
    func testParsesBothByteOrdersAndAddressSizes() {
        for endian: Endian in [.little, .big] {
            for size in [4, 8] {
                let maximum = size == 8 ? UInt64.max : UInt64(UInt32.max)
                var data = Data([0xaa])
                append(maximum, size: size, endian: endian, to: &data)
                append(0x5000, size: size, endian: endian, to: &data)
                append(0x10, size: size, endian: endian, to: &data)
                append(0x30, size: size, endian: endian, to: &data)
                append(0x102, size: 2, endian: endian, to: &data)
                let expression = Data(repeating: 0xff, count: 0x102)
                data.append(expression)
                append(0x20, size: size, endian: endian, to: &data)
                append(0x20, size: size, endian: endian, to: &data)
                append(0, size: 2, endian: endian, to: &data)
                append(0, size: size, endian: endian, to: &data)
                append(0, size: size, endian: endian, to: &data)
                data.append(0xee)
                XCTAssertEqual(DWARF3LocationList._parseEntries(
                    data: Data(data.dropFirst()), addressSize: size, endian: endian
                ), [
                    .baseAddressSelection(address: 0x5000),
                    .location(beginningOffset: 0x10, endOffset: 0x30, expression: expression),
                    .location(beginningOffset: 0x20, endOffset: 0x20, expression: Data()),
                    .endOfList,
                ])
            }
        }
    }

    func testRejectsTruncationAndMissingTerminator() {
        var data = Data()
        append(1, size: 4, endian: .little, to: &data)
        append(2, size: 4, endian: .little, to: &data)
        append(2, size: 2, endian: .little, to: &data)
        data.append(contentsOf: [0xff, 0xff])
        append(0, size: 4, endian: .little, to: &data)
        append(0, size: 4, endian: .little, to: &data)
        for count in 0..<data.count {
            XCTAssertNil(DWARF3LocationList._parseEntries(
                data: Data(data.prefix(count)), addressSize: 4, endian: .little
            ), "length: \(count)")
        }
        for size in [0, 9] {
            XCTAssertNil(DWARF3LocationList._parseEntries(
                data: data, addressSize: size, endian: .little
            ))
        }
    }

    func testRejectsReversedBoundsAndKeepsOverlaps() {
        var data = Data()
        for (start, end): (UInt64, UInt64) in [(0x10, 0x30), (0x20, 0x40)] {
            append(start, size: 4, endian: .little, to: &data)
            append(end, size: 4, endian: .little, to: &data)
            append(0, size: 2, endian: .little, to: &data)
        }
        data.append(Data(repeating: 0, count: 8))
        XCTAssertEqual(DWARF3LocationList._parseEntries(
            data: data, addressSize: 4, endian: .little
        )?.count, 3)
        var reversed = Data()
        append(2, size: 4, endian: .little, to: &reversed)
        append(1, size: 4, endian: .little, to: &reversed)
        XCTAssertNil(DWARF3LocationList._parseEntries(
            data: reversed, addressSize: 4, endian: .little
        ))
    }

    func testLoadsEntriesInMachOAndELF() throws {
        let data = Data(repeating: 0, count: 8)
        for version: DWARFVersion in [.v2, .v3, .v4] {
            var layout = dwarf4_cu_header32_t()
            layout.version = version.rawValue
            layout.address_size = 4
            let header = DWARFCompilationUnitHeader.upToVersion4_32(
                .init(layout: layout, offset: 0)
            )
            try UnitTypeBinaryFixture.withLegacyLocations(
                header: header, debugLoc: data
            ) { machO, machOUnit, elf, elfUnit in
                if version == .v2 {
                    XCTAssertNil(DWARF3LocationList.load(at: 0, for: machOUnit, in: machO))
                    XCTAssertNil(DWARF3LocationList.load(at: 0, for: elfUnit, in: elf))
                    return
                }
                let machOList = try XCTUnwrap(DWARF3LocationList.load(
                    at: 0, for: machOUnit, in: machO
                ))
                let elfList = try XCTUnwrap(DWARF3LocationList.load(
                    at: 0, for: elfUnit, in: elf
                ))
                XCTAssertEqual(machOList.entries(in: machO), [.endOfList])
                XCTAssertEqual(elfList.entries(in: elf), [.endOfList])
                for offset: UInt64 in [1, 8, UInt64.max] {
                    XCTAssertNil(DWARF3LocationList.load(at: offset, for: machOUnit, in: machO))
                    XCTAssertNil(DWARF3LocationList.load(at: offset, for: elfUnit, in: elf))
                }
            }
        }
    }

    private func append(_ value: UInt64, size: Int, endian: Endian, to data: inout Data) {
        for index in 0..<size {
            let shift = (endian == .little ? index : size - 1 - index) * 8
            data.append(UInt8(truncatingIfNeeded: value >> shift))
        }
    }
}
