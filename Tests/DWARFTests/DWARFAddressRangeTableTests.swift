import Foundation
import XCTest
@testable import DWARF

final class DWARFAddressRangeTableTests: XCTestCase {
    func testTupleRangeExcludesHeaderPadding() throws {
        let layout = DWARFAddressRangeTableLayout(
            contributionSize: 48,
            headerSize: 12,
            tupleSize: 16
        )

        XCTAssertEqual(try layout.tuplesRange, 16 ..< 48)
    }

    func testTupleAlignmentSupportsNonPowerOfTwoSize() throws {
        let layout = DWARFAddressRangeTableLayout(
            contributionSize: 40,
            headerSize: 12,
            tupleSize: 10
        )

        XCTAssertEqual(try layout.tuplesRange, 20 ..< 40)
    }

    func testRejectsPaddingPastContributionEnd() {
        let layout = DWARFAddressRangeTableLayout(
            contributionSize: 15,
            headerSize: 12,
            tupleSize: 16
        )

        XCTAssertThrowsError(try layout.tuplesRange)
    }

    func testTerminatingTupleIsNotExposed() {
        var tuples = Data()
        tuples.append(contentsOf: littleEndianBytes(0x1000))
        tuples.append(contentsOf: littleEndianBytes(0x20))
        tuples.append(Data(repeating: 0, count: 16))
        tuples.append(contentsOf: littleEndianBytes(0x2000))
        tuples.append(contentsOf: littleEndianBytes(0x40))

        let ranges = DWARFAddressRanges(
            addressSize: 8,
            segmentSelectorSize: 0,
            sequence: .init(data: tuples, chunkSize: 16),
            endian: .little
        )

        var iterator = ranges.makeIterator()
        let range = iterator.next()
        XCTAssertEqual(range?.address.address, 0x1000)
        XCTAssertEqual(range?.length, 0x20)
        XCTAssertNil(iterator.next())
        XCTAssertNil(iterator.next())
    }
}

private func littleEndianBytes(_ value: UInt64) -> [UInt8] {
    withUnsafeBytes(of: value.littleEndian, Array.init)
}
