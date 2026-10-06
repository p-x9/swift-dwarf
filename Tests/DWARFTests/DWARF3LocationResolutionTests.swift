import Foundation
import XCTest
@testable import DWARF
import DWARFC
import DWARFMachO
import DWARFELF

final class DWARF3LocationResolutionTests: XCTestCase {
    private func address(_ value: UInt64) -> DWARFAddress {
        .init(segmentSelector: nil, address: value)
    }

    func testResolvesInitialAndSelectedBasesAndKeepsOverlaps() throws {
        let entries: [DWARF3LocationListEntry] = [
            .location(beginningOffset: 0x10, endOffset: 0x30, expression: Data([0x50])),
            .location(beginningOffset: 0x20, endOffset: 0x40, expression: Data()),
            .baseAddressSelection(address: 0x5000),
            .location(beginningOffset: 1, endOffset: 2, expression: Data([0x51])),
            .endOfList,
        ]
        let locations = try XCTUnwrap(entries._locations(
            addressSize: 4, initialBaseAddress: address(0x1000),
            descriptions: {
                DWARF3LocationList._parseDescriptions(
                    data: $0, addressSize: 4, format: ._32bit, endian: .little
                )
            }
        ))
        XCTAssertEqual(locations.map(\.range), [
            .init(start: address(0x1010), end: address(0x1030)),
            .init(start: address(0x1020), end: address(0x1040)),
            .init(start: address(0x5001), end: address(0x5002)),
        ])
        XCTAssertEqual(locations[0].descriptions, [.reg0])
        XCTAssertEqual(locations[1].descriptions, [])
        XCTAssertEqual(locations[2].descriptions, [.reg1])
    }

    func testEmptyRangeDoesNotResolveBaseOrExpression() {
        var requested = false
        func base() -> DWARFAddress? {
            requested = true
            return nil
        }
        let entries: [DWARF3LocationListEntry] = [
            .location(beginningOffset: 1, endOffset: 1, expression: Data([0xff])),
            .endOfList,
        ]
        XCTAssertEqual(entries._locations(
            addressSize: 4, initialBaseAddress: base(),
            descriptions: { _ in requested = true; return nil }
        )?.count, 0)
        XCTAssertFalse(requested)
    }

    func testRejectsMissingBaseOverflowAndTerminator() {
        let location = DWARF3LocationListEntry.location(
            beginningOffset: 1, endOffset: 2, expression: Data()
        )
        XCTAssertNil([location, .endOfList]._locations(
            addressSize: 4, initialBaseAddress: nil, descriptions: { _ in [] }
        ))
        for size in [4, 8] {
            let maximum = size == 8 ? UInt64.max : UInt64(UInt32.max)
            XCTAssertNil([location, .endOfList]._locations(
                addressSize: size, initialBaseAddress: address(maximum),
                descriptions: { _ in [] }
            ))
        }
        XCTAssertNil([location]._locations(
            addressSize: 4, initialBaseAddress: address(0), descriptions: { _ in [] }
        ))
        XCTAssertNil([location, .endOfList]._locations(
            addressSize: 4, initialBaseAddress: address(0), descriptions: { _ in nil }
        ))
    }

    func testExpressionParsingUsesEndianAndRejectsInvalidBytes() {
        for endian: Endian in [.little, .big] {
            let operand: [UInt8] = endian == .little
                ? [0x78, 0x56, 0x34, 0x12] : [0x12, 0x34, 0x56, 0x78]
            XCTAssertEqual(DWARF3LocationList._parseDescriptions(
                data: Data([0x03] + operand), addressSize: 4,
                format: ._32bit, endian: endian
            ), [.addr(0x12345678)])
        }
        for format: DWARFFormat in [._32bit, ._64bit] {
            let size = format == ._32bit ? 4 : 8
            XCTAssertEqual(DWARF3LocationList._parseDescriptions(
                data: Data([0x9a, 0x12] + Array(repeating: UInt8(0), count: size - 1)),
                addressSize: 4, format: format, endian: .little
            ), [.call_ref(0x12)])
        }
        for data in [Data([0xff]), Data([0x03, 1])] {
            XCTAssertNil(DWARF3LocationList._parseDescriptions(
                data: data, addressSize: 4, format: ._32bit, endian: .little
            ))
        }
    }

    func testPublicLocationsInMachOAndELF() throws {
        // base(0x5000), location(0x10,0x20,reg0), terminator.
        let data = Data([
            0xff, 0xff, 0xff, 0xff, 0x00, 0x50, 0x00, 0x00,
            0x10, 0, 0, 0, 0x20, 0, 0, 0, 1, 0, 0x50,
            0, 0, 0, 0, 0, 0, 0, 0,
        ])
        for version: DWARFVersion in [.v3, .v4] {
            var layout = dwarf4_cu_header32_t()
            layout.version = version.rawValue
            layout.address_size = 4
            let header = DWARFCompilationUnitHeader.upToVersion4_32(
                .init(layout: layout, offset: 0)
            )
            for selectedBase in [false, true] {
                try UnitTypeBinaryFixture.withLegacyLocations(
                    header: header,
                    debugLoc: selectedBase ? data : Data(data.dropFirst(8)),
                    lowPC: selectedBase ? nil : 0x5000
                ) { machO, machOUnit, elf, elfUnit in
                    let machOList = try XCTUnwrap(DWARF3LocationList.load(
                        at: 0, for: machOUnit, in: machO
                    ))
                    let elfList = try XCTUnwrap(DWARF3LocationList.load(
                        at: 0, for: elfUnit, in: elf
                    ))
                    for locations in [
                        machOList.locations(for: machOUnit, in: machO),
                        elfList.locations(for: elfUnit, in: elf),
                    ] {
                        let location = try XCTUnwrap(locations?.first)
                        XCTAssertEqual(locations?.count, 1)
                        XCTAssertEqual(location.range, .init(
                            start: address(0x5010), end: address(0x5020)
                        ))
                        XCTAssertEqual(location.descriptions, [.reg0])
                    }
                }
            }
        }
    }
}
