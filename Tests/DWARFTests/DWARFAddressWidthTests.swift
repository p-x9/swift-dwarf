import XCTest
@testable import DWARF

final class DWARFAddressWidthTests: XCTestCase {
    func testMaximumValuesForSupportedWidths() {
        let expected: [UInt64] = [
            0xff, 0xffff, 0xffffff, 0xffffffff,
            0xffffffffff, 0xffffffffffff, 0xffffffffffffff, UInt64.max,
        ]
        for (index, value) in expected.enumerated() {
            XCTAssertEqual(
                DWARFAddress.maximumValue(addressSize: index + 1), value
            )
        }
    }

    func testRejectsUnsupportedWidths() {
        for size in [Int.min, -1, 0, 9, Int.max] {
            XCTAssertNil(DWARFAddress.maximumValue(addressSize: size))
        }
    }
}
