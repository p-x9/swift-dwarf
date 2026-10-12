import Foundation
import XCTest
@testable import DWARF
import DWARFC
import DWARFMachO
import DWARFELF

final class DWARF5LocationResolutionTests: XCTestCase {
    private func address(_ value: UInt64) -> DWARFAddress { .init(address: value) }

    private func bulkLocations(_ operations: [DWARFLocationOperation]) throws -> [[[DWARFLocation]]] {
        var results: [[[DWARFLocation]]] = []
        try UnitTypeBinaryFixture.withDWARF5Addresses { machO, machOUnit, elf, elfUnit in
            results = [operations.locations(for: machOUnit, in: machO),
                       operations.locations(for: elfUnit, in: elf)]
        }
        return results
    }

    func testBulkResolutionResetsBaseAndKeepsEmptyLists() throws {
        let operations: [DWARFLocationOperation] = [
            .base_addressx(addressIndex: 0),
            .offset_pair(startOffset: 0x10, endOffset: 0x20, descriptions: [.reg0]),
            .startx_endx(startIndex: 0, endIndex: 1, descriptions: [.reg1]),
            .end_of_list,
            .end_of_list,
            .offset_pair(startOffset: 0x10, endOffset: 0x20, descriptions: [.reg2]),
            .default_location(descriptions: [.reg3]),
            .end_of_list,
            .start_length(start: address(0x3000), length: 0x10, descriptions: [.reg4]),
            // No terminator: the final partial list is not returned.
        ]
        for lists in try bulkLocations(operations) {
            XCTAssertEqual(lists.count, 3)
            XCTAssertEqual(lists[0].map(\.range), [
                .init(start: address(0x1010), end: address(0x1020)),
                .init(start: address(0x1000), end: address(0x2000)),
            ])
            XCTAssertTrue(lists[1].isEmpty)
            XCTAssertEqual(lists[2].first?.range, .init(start: address(0x5010), end: address(0x5020)))
            XCTAssertEqual(lists[2].last?.isDefault, true)
            XCTAssertEqual(lists[0].map(\.descriptions), [[.reg0], [.reg1]])
            XCTAssertEqual(lists[2].map(\.descriptions), [[.reg2], [.reg3]])
        }
    }

    func testBulkAndSingleListUseSameResolver() throws {
        let operations: [DWARFLocationOperation] = [
            .base_address(address: address(0x1000)),
            .offset_pair(startOffset: 0x10, endOffset: 0x20, descriptions: [.reg0]),
            .startx_length(startIndex: 1, length: 0x40, descriptions: [.reg1]),
            .start_end(start: address(0x3000), end: address(0x3100), descriptions: [.reg2]),
            .start_length(start: address(0x4000), length: 0x20, descriptions: [.reg3]),
            .default_location(descriptions: [.reg4]), .end_of_list,
        ]
        let single = try XCTUnwrap(operations._locations(
            addressSize: 4, initialBaseAddress: nil,
            addressAtIndex: { $0 == 1 ? self.address(0x2000) : nil }
        ))
        for lists in try bulkLocations(operations) {
            XCTAssertEqual(lists.count, 1)
            XCTAssertEqual(lists[0].map(\.range), single.map(\.range))
            XCTAssertEqual(lists[0].map(\.descriptions), single.map(\.descriptions))
        }
    }

    func testBulkStopsAtInvalidListAndPreservesCompletedPrefix() throws {
        for invalid: DWARFLocationOperation in [
            .base_addressx(addressIndex: .max),
            .start_length(start: address(UInt64(UInt32.max)), length: 1, descriptions: []),
            .start_end(start: address(2), end: address(1), descriptions: []),
        ] {
            for lists in try bulkLocations([.end_of_list, invalid, .end_of_list, .end_of_list]) {
                XCTAssertEqual(lists.count, 1)
                XCTAssertTrue(lists[0].isEmpty)
            }
        }
        for lists in try bulkLocations([]) { XCTAssertTrue(lists.isEmpty) }
    }

    func testResolvesSelectedBaseIndexedAndDirectOperations() throws {
        let operations: [DWARFLocationOperation] = [
            .base_addressx(addressIndex: 0),
            .offset_pair(startOffset: 0x10, endOffset: 0x20, descriptions: [.reg0]),
            .startx_endx(startIndex: 0, endIndex: 1, descriptions: [.reg1]),
            .startx_length(startIndex: 1, length: 0x40, descriptions: [.reg2]),
            .base_address(address: address(0x3000)),
            .offset_pair(startOffset: 0x10, endOffset: 0x20, descriptions: [.reg3]),
            .start_end(start: address(0x4000), end: address(0x4100), descriptions: [.reg4]),
            .start_length(start: address(0x5000), length: 0x20, descriptions: [.reg5]),
            .default_location(descriptions: [.reg6]),
            .end_of_list,
            .base_addressx(addressIndex: .max),
        ]
        var initialBaseWasRequested = false
        func initialBase() -> DWARFAddress? {
            initialBaseWasRequested = true
            return nil
        }
        let locations = try XCTUnwrap(operations._locations(
            addressSize: 4, initialBaseAddress: initialBase(),
            addressAtIndex: { index in
                switch index {
                case 0: self.address(0x1000)
                case 1: self.address(0x2000)
                default: nil
                }
            }
        ))
        XCTAssertFalse(initialBaseWasRequested)
        XCTAssertEqual(locations.map(\.range), [
            .init(start: address(0x1010), end: address(0x1020)),
            .init(start: address(0x1000), end: address(0x2000)),
            .init(start: address(0x2000), end: address(0x2040)),
            .init(start: address(0x3010), end: address(0x3020)),
            .init(start: address(0x4000), end: address(0x4100)),
            .init(start: address(0x5000), end: address(0x5020)),
            .init(start: address(0), end: address(0)),
        ])
        XCTAssertEqual(locations.map(\.descriptions), [[.reg0], [.reg1], [.reg2], [.reg3], [.reg4], [.reg5], [.reg6]])
        XCTAssertEqual(locations.last?.isDefault, true)
    }

    func testRejectsMissingBaseMissingAddressAndInvalidRanges() {
        let cases: [DWARFLocationOperation] = [
            .offset_pair(startOffset: 1, endOffset: 2, descriptions: []),
            .base_addressx(addressIndex: .max),
            .startx_endx(startIndex: 0, endIndex: .max, descriptions: []),
            .startx_length(startIndex: .max, length: 1, descriptions: []),
            .start_end(start: address(2), end: address(1), descriptions: []),
            .start_end(start: address(0), end: address(0x1_0000_0000), descriptions: []),
            .start_length(start: address(UInt64(UInt32.max)), length: 1, descriptions: []),
            .start_length(start: address(UInt64.max), length: 1, descriptions: []),
        ]
        for operation in cases {
            XCTAssertNil([operation, .end_of_list]._locations(
                addressSize: 4, initialBaseAddress: nil, addressAtIndex: { _ in nil }
            ))
        }
        XCTAssertNil([DWARFLocationOperation.default_location(descriptions: [])]._locations(
            addressSize: 4, initialBaseAddress: nil, addressAtIndex: { _ in nil }
        ))
        XCTAssertNil([DWARFLocationOperation.offset_pair(startOffset: 2, endOffset: 1, descriptions: []), .end_of_list]._locations(
            addressSize: 4, initialBaseAddress: address(0), addressAtIndex: { _ in nil }
        ))
    }
}
