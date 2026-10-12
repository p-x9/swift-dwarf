import XCTest
@testable import DWARF
import DWARFMachO
import DWARFELF

final class DWARF5RangeResolutionTests: XCTestCase {
    private func address(_ value: UInt64) -> DWARFAddress { .init(address: value) }

    private func bulkRanges(_ operations: [DWARFRangeOperation]) throws -> [[[DWARFRange]]] {
        var results: [[[DWARFRange]]] = []
        try UnitTypeBinaryFixture.withDWARF5Addresses { machO, machOUnit, elf, elfUnit in
            results = [operations.ranges(for: machOUnit, in: machO),
                       operations.ranges(for: elfUnit, in: elf)]
        }
        return results
    }

    func testBulkResolutionResetsBaseAndKeepsEmptyLists() throws {
        let operations: [DWARFRangeOperation] = [
            .base_addressx(addressIndex: 0),
            .offset_pair(startOffset: 0x10, endOffset: 0x20),
            .startx_endx(startIndex: 0, endIndex: 1),
            .end_of_list,
            .end_of_list,
            .offset_pair(startOffset: 0x10, endOffset: 0x20),
            .end_of_list,
            .start_length(start: address(0x3000), length: 0x10),
        ]
        for lists in try bulkRanges(operations) {
            XCTAssertEqual(lists, [
                [.init(start: address(0x1010), end: address(0x1020)),
                 .init(start: address(0x1000), end: address(0x2000))],
                [],
                [.init(start: address(0x5010), end: address(0x5020))],
            ])
        }
    }

    func testBulkAndSingleListUseSameResolver() throws {
        let operations: [DWARFRangeOperation] = [
            .base_address(address: address(0x1000)),
            .offset_pair(startOffset: 0x10, endOffset: 0x20),
            .startx_length(startIndex: 1, length: 0x40),
            .start_end(start: address(0x3000), end: address(0x3100)),
            .start_length(start: address(0x4000), length: 0x20),
            .end_of_list,
        ]
        let single = try XCTUnwrap(operations._ranges(
            addressSize: 4, initialBaseAddress: nil,
            addressAtIndex: { $0 == 1 ? self.address(0x2000) : nil }
        ))
        for lists in try bulkRanges(operations) { XCTAssertEqual(lists, [single]) }
    }

    func testBulkStopsAtInvalidListAndPreservesCompletedPrefix() throws {
        for invalid: DWARFRangeOperation in [
            .base_addressx(addressIndex: .max),
            .start_length(start: address(UInt64(UInt32.max)), length: 1),
            .start_end(start: address(2), end: address(1)),
        ] {
            for lists in try bulkRanges([.end_of_list, invalid, .end_of_list, .end_of_list]) {
                XCTAssertEqual(lists, [[]])
            }
        }
        for lists in try bulkRanges([]) { XCTAssertTrue(lists.isEmpty) }
    }
}
