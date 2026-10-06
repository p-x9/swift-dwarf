import XCTest
@testable import DWARF
import DWARFC
import DWARFMachO
import DWARFELF

final class DWARFRangeOperationTests: XCTestCase {
    func testTableResolvesOneRangeListInMachOAndELF() throws {
        var unitLayout = dwarf5_cu_header32_t()
        unitLayout.version = DWARFVersion.v5.rawValue
        unitLayout.unit_type = DWARFUnitType.compile.rawValue
        unitLayout.address_size = 4
        let header = DWARFCompilationUnitHeader.version5_32(
            .init(layout: unitLayout, offset: 0)
        )

        var rangeListHeader = dwarf5_rnglist_header32_t()
        rangeListHeader.unit_length.value = 22
        rangeListHeader.version = DWARFVersion.v5.rawValue
        rangeListHeader.address_size = 4
        rangeListHeader.offset_entry_count = 1
        var data = withUnsafeBytes(of: rangeListHeader) { Data($0) }
        append(4, to: &data)
        data.append(0x06) // DW_RLE_start_end
        append(0x1000, to: &data)
        append(0x1040, to: &data)
        data.append(0x00) // DW_RLE_end_of_list

        try UnitTypeBinaryFixture.withDWARF5Ranges(
            header: header,
            debugRnglists: data
        ) { machO, machOUnit, elf, elfUnit in
            let machOTable = try XCTUnwrap(machO.dwarf.rangeListTables.first)
            let elfTable = try XCTUnwrap(elf.dwarf.rangeListTables.first)
            let expected: [DWARFRange] = [
                .init(start: address(0x1000), end: address(0x1040)),
            ]
            XCTAssertEqual(
                machOTable.ranges(for: machOUnit, in: machO, entryOffset: 4),
                expected
            )
            XCTAssertEqual(
                elfTable.ranges(for: elfUnit, in: elf, entryOffset: 4),
                expected
            )
        }
    }

    func testResolvesOneListUsingInitialAndSelectedBases() {
        var indexedAddressWasRequested = false
        let ranges = [
            DWARFRangeOperation.offset_pair(startOffset: 0x10, endOffset: 0x30),
            .base_address(address: address(0x5000)),
            .offset_pair(startOffset: 0x20, endOffset: 0x40),
            .start_end(start: address(0x7000), end: address(0x7080)),
            .start_length(start: address(0x8000), length: 0x40),
            .end_of_list,
            .start_end(start: address(0x9000), end: address(0x9010)),
        ]._ranges(
            initialBaseAddress: address(0x1000),
            addressAtIndex: { _ in
                indexedAddressWasRequested = true
                return nil
            }
        )

        XCTAssertEqual(
            ranges,
            [
                .init(start: address(0x1010), end: address(0x1030)),
                .init(start: address(0x5020), end: address(0x5040)),
                .init(start: address(0x7000), end: address(0x7080)),
                .init(start: address(0x8000), end: address(0x8040)),
            ]
        )
        XCTAssertFalse(indexedAddressWasRequested)
    }

    func testResolvesIndexedAddressesOnDemand() {
        let addresses = [address(0x1000), address(0x2000), address(0x3000)]
        var requestedIndices: [UInt64] = []
        let ranges = [
            DWARFRangeOperation.base_addressx(addressIndex: 0),
            .offset_pair(startOffset: 0x10, endOffset: 0x20),
            .startx_endx(startIndex: 1, endIndex: 2),
            .startx_length(startIndex: 2, length: 0x40),
            .end_of_list,
        ]._ranges(
            initialBaseAddress: nil,
            addressAtIndex: { index in
                requestedIndices.append(index)
                guard let index = Int(exactly: index),
                      addresses.indices.contains(index) else {
                    return nil
                }
                return addresses[index]
            }
        )

        XCTAssertEqual(
            ranges,
            [
                .init(start: address(0x1010), end: address(0x1020)),
                .init(start: address(0x2000), end: address(0x3000)),
                .init(start: address(0x3000), end: address(0x3040)),
            ]
        )
        XCTAssertEqual(requestedIndices, [0, 1, 2, 2])
    }

    func testDirectRangeDoesNotRequestInitialBaseOrIndexedAddress() {
        var initialBaseWasRequested = false
        var indexedAddressWasRequested = false

        func initialBaseAddress() -> DWARFAddress? {
            initialBaseWasRequested = true
            return nil
        }

        let ranges = [
            DWARFRangeOperation.start_end(
                start: address(0x1000),
                end: address(0x2000)
            ),
            .end_of_list,
        ]._ranges(
            initialBaseAddress: initialBaseAddress(),
            addressAtIndex: { _ in
                indexedAddressWasRequested = true
                return nil
            }
        )

        XCTAssertEqual(
            ranges,
            [.init(start: address(0x1000), end: address(0x2000))]
        )
        XCTAssertFalse(initialBaseWasRequested)
        XCTAssertFalse(indexedAddressWasRequested)
    }

    func testRequiresBaseForOffsetPair() {
        XCTAssertNil(
            [
                DWARFRangeOperation.offset_pair(
                    startOffset: 0x10,
                    endOffset: 0x20
                ),
                .end_of_list,
            ]._ranges(
                initialBaseAddress: nil,
                addressAtIndex: { _ in nil }
            )
        )
    }

    func testRejectsMissingIndexedAddress() {
        XCTAssertNil(
            [
                DWARFRangeOperation.startx_endx(startIndex: 0, endIndex: 1),
                .end_of_list,
            ]._ranges(
                initialBaseAddress: nil,
                addressAtIndex: { index in
                    index == 0 ? self.address(0x1000) : nil
                }
            )
        )
    }

    func testRejectsOverflowAndMissingTerminator() {
        XCTAssertNil(
            [
                DWARFRangeOperation.start_length(
                    start: address(UInt64.max),
                    length: 1
                ),
                .end_of_list,
            ]._ranges(
                initialBaseAddress: nil,
                addressAtIndex: { _ in nil }
            )
        )
        XCTAssertNil(
            [
                DWARFRangeOperation.start_end(
                    start: address(0x1000),
                    end: address(0x2000)
                ),
            ]._ranges(
                initialBaseAddress: nil,
                addressAtIndex: { _ in nil }
            )
        )
    }

    private func address(_ value: UInt64) -> DWARFAddress {
        .init(segmentSelector: nil, address: value)
    }

    private func append(_ value: UInt32, to data: inout Data) {
        withUnsafeBytes(of: value) { data.append(contentsOf: $0) }
    }
}

final class DWARF3RangeListEntryResolutionTests: XCTestCase {
    func testResolvesInitialAndSelectedBasesAndIgnoresEmptyRanges() {
        let ranges = [
            DWARF3RangeListEntry.range(
                beginningOffset: 0x10,
                endOffset: 0x30
            ),
            .range(beginningOffset: 0x40, endOffset: 0x40),
            .baseAddressSelection(address: 0x5000),
            .range(beginningOffset: 0x20, endOffset: 0x40),
            .endOfList,
            .range(beginningOffset: 0x50, endOffset: 0x60),
        ]._ranges(initialBaseAddress: address(0x1000))

        XCTAssertEqual(
            ranges,
            [
                .init(start: address(0x1010), end: address(0x1030)),
                .init(start: address(0x5020), end: address(0x5040)),
            ]
        )
    }

    func testSelectedBaseDoesNotRequestInitialBase() {
        var initialBaseWasRequested = false

        func initialBaseAddress() -> DWARFAddress? {
            initialBaseWasRequested = true
            return nil
        }

        let ranges = [
            DWARF3RangeListEntry.baseAddressSelection(address: 0x5000),
            .range(beginningOffset: 0x10, endOffset: 0x20),
            .endOfList,
        ]._ranges(initialBaseAddress: initialBaseAddress())

        XCTAssertEqual(
            ranges,
            [.init(start: address(0x5010), end: address(0x5020))]
        )
        XCTAssertFalse(initialBaseWasRequested)
    }

    func testRejectsMissingBaseOverflowAndMissingTerminator() {
        XCTAssertNil(
            [
                DWARF3RangeListEntry.range(
                    beginningOffset: 0x10,
                    endOffset: 0x20
                ),
                .endOfList,
            ]._ranges(initialBaseAddress: nil)
        )
        XCTAssertNil(
            [
                DWARF3RangeListEntry.range(
                    beginningOffset: 0,
                    endOffset: 1
                ),
                .endOfList,
            ]._ranges(initialBaseAddress: address(UInt64.max))
        )
        XCTAssertNil(
            [
                DWARF3RangeListEntry.baseAddressSelection(address: 0x1000),
            ]._ranges(initialBaseAddress: nil)
        )
    }

    private func address(_ value: UInt64) -> DWARFAddress {
        .init(segmentSelector: nil, address: value)
    }
}
