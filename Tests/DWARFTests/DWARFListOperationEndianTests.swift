import Foundation
import XCTest
@testable import DWARF

final class DWARFListOperationEndianTests: XCTestCase {
    func testRangeListAddressOperandsUseSpecifiedEndian() {
        for endian: Endian in [.little, .big] {
            for addressSize in [4, 8] {
                let values = addressValues(size: addressSize)
                var data = Data()
                data.append(DWARFRangeOpcode.base_address.rawValue)
                appendAddress(values.base, to: &data, size: addressSize, endian: endian)
                data.append(DWARFRangeOpcode.start_end.rawValue)
                appendAddress(values.start, to: &data, size: addressSize, endian: endian)
                appendAddress(values.end, to: &data, size: addressSize, endian: endian)
                data.append(DWARFRangeOpcode.start_length.rawValue)
                appendAddress(values.lengthStart, to: &data, size: addressSize, endian: endian)
                data.append(0x19) // ULEB128 length.
                data.append(DWARFRangeOpcode.end_of_list.rawValue)

                XCTAssertEqual(
                    Array(
                        DWARFRangeList.Operations(
                            data: data,
                            addressSize: addressSize,
                            segmentSelectorSize: 2,
                            endian: endian
                        )
                    ),
                    [
                        .base_address(address: address(values.base)),
                        .start_end(
                            start: address(values.start),
                            end: address(values.end)
                        ),
                        .start_length(
                            start: address(values.lengthStart),
                            length: 0x19
                        ),
                        .end_of_list,
                    ],
                    "\(endian), address size \(addressSize)"
                )
            }
        }
    }

    func testLocationListAddressOperandsUseSpecifiedEndian() {
        for endian: Endian in [.little, .big] {
            for addressSize in [4, 8] {
                let values = addressValues(size: addressSize)
                var data = Data()
                data.append(DWARFLocationOpcode.base_address.rawValue)
                appendAddress(values.base, to: &data, size: addressSize, endian: endian)
                data.append(DWARFLocationOpcode.start_end.rawValue)
                appendAddress(values.start, to: &data, size: addressSize, endian: endian)
                appendAddress(values.end, to: &data, size: addressSize, endian: endian)
                data.append(0) // Empty location description.
                data.append(DWARFLocationOpcode.start_length.rawValue)
                appendAddress(values.lengthStart, to: &data, size: addressSize, endian: endian)
                data.append(0x19) // ULEB128 length.
                data.append(0) // Empty location description.
                data.append(DWARFLocationOpcode.end_of_list.rawValue)

                XCTAssertEqual(
                    Array(
                        DWARFLocationList.Operations(
                            data: data,
                            addressSize: addressSize,
                            format: ._32bit,
                            segmentSelectorSize: 2,
                            endian: endian
                        )
                    ),
                    [
                        .base_address(address: address(values.base)),
                        .start_end(
                            start: address(values.start),
                            end: address(values.end),
                            descriptions: []
                        ),
                        .start_length(
                            start: address(values.lengthStart),
                            length: 0x19,
                            descriptions: []
                        ),
                        .end_of_list,
                    ],
                    "\(endian), address size \(addressSize)"
                )
            }
        }
    }
}

extension DWARFListOperationEndianTests {
    private typealias AddressValues = (
        base: UInt64,
        start: UInt64,
        end: UInt64,
        lengthStart: UInt64
    )

    private func addressValues(size: Int) -> AddressValues {
        if size == 4 {
            return (0x01020304, 0x11121314, 0x21222324, 0x31323334)
        }
        return (
            0x0102030405060708,
            0x1112131415161718,
            0x2122232425262728,
            0x3132333435363738
        )
    }

    private func appendAddress(
        _ value: UInt64,
        to data: inout Data,
        size: Int,
        endian: Endian
    ) {
        append(0x1122, to: &data, size: 2, endian: endian)
        append(value, to: &data, size: size, endian: endian)
    }

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
        .init(segmentSelector: 0x1122, address: value)
    }
}
