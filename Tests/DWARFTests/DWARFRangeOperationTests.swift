import XCTest
@testable import DWARF

final class DWARFRangeOperationTests: XCTestCase {
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
}
