import Foundation
import XCTest
@testable import DWARF

final class DWARFOperationEndianTests: XCTestCase {
    func testFixedWidthOperandsUseSpecifiedEndian() {
        for endian: Endian in [.little, .big] {
            for (addressSize, format) in [(4, DWARFFormat._32bit), (8, ._64bit)] {
                let address = addressSize == 4
                    ? UInt64(0x12345678)
                    : UInt64(0x123456789abcdef0)
                let reference = addressSize == 4
                    ? UInt64(0x23456789)
                    : UInt64(0x23456789abcdef01)
                var data = Data()

                append(.addr, to: &data)
                appendFixedWidth(address, to: &data, size: addressSize, endian: endian)
                append(.const1u, to: &data)
                data.append(0xfe)
                append(.const1s, to: &data)
                data.append(0x80)
                append(.const2u, to: &data)
                appendFixedWidth(0x1234, to: &data, size: 2, endian: endian)
                append(.const2s, to: &data)
                appendFixedWidth(0xfedc, to: &data, size: 2, endian: endian)
                append(.const4u, to: &data)
                appendFixedWidth(0x12345678, to: &data, size: 4, endian: endian)
                append(.const4s, to: &data)
                appendFixedWidth(0x89abcdef, to: &data, size: 4, endian: endian)
                append(.const8u, to: &data)
                appendFixedWidth(0x123456789abcdef0, to: &data, size: 8, endian: endian)
                append(.const8s, to: &data)
                appendFixedWidth(0x89abcdef01234567, to: &data, size: 8, endian: endian)
                append(.pick, to: &data)
                data.append(3)
                append(.bra, to: &data)
                appendFixedWidth(0xff80, to: &data, size: 2, endian: endian)
                append(.skip, to: &data)
                appendFixedWidth(0x007f, to: &data, size: 2, endian: endian)
                append(.deref_size, to: &data)
                data.append(4)
                append(.xderef_size, to: &data)
                data.append(8)
                append(.call2, to: &data)
                appendFixedWidth(0x3456, to: &data, size: 2, endian: endian)
                append(.call4, to: &data)
                appendFixedWidth(0x456789ab, to: &data, size: 4, endian: endian)
                append(.call_ref, to: &data)
                appendFixedWidth(reference, to: &data, size: addressSize, endian: endian)
                append(.implicit_pointer, to: &data)
                appendFixedWidth(reference, to: &data, size: addressSize, endian: endian)
                data.append(0x7d) // SLEB128 -3.
                append(.const_type, to: &data)
                data.append(0x2a) // ULEB128 DIE offset.
                data.append(2)
                data.append(contentsOf: [0xaa, 0xbb])
                append(.deref_type, to: &data)
                data.append(4)
                data.append(1) // ULEB128 DIE offset.
                append(.xderef_type, to: &data)
                data.append(8)
                data.append(2) // ULEB128 DIE offset.

                XCTAssertEqual(
                    decode(
                        data,
                        addressSize: addressSize,
                        format: format,
                        endian: endian
                    ),
                    [
                        .addr(address),
                        .const1u(0xfe),
                        .const1s(-128),
                        .const2u(0x1234),
                        .const2s(Int16(bitPattern: 0xfedc)),
                        .const4u(0x12345678),
                        .const4s(Int32(bitPattern: 0x89abcdef)),
                        .const8u(0x123456789abcdef0),
                        .const8s(Int64(bitPattern: 0x89abcdef01234567)),
                        .pick(index: 3),
                        .bra(-128),
                        .skip(127),
                        .deref_size(4),
                        .xderef_size(8),
                        .call2(0x3456),
                        .call4(0x456789ab),
                        .call_ref(reference),
                        .implicit_pointer(dieOffset: reference, offset: -3),
                        .const_type(
                            dieOffset: 0x2a,
                            size: 2,
                            bytes: Data([0xaa, 0xbb])
                        ),
                        .deref_type(size: 4, dieOffset: 1),
                        .xderef_type(size: 8, dieOffset: 2),
                    ],
                    "\(endian), \(format)"
                )
            }
        }
    }

    func testTruncatedFixedWidthOperandEndsDecoding() {
        let data = Data([
            DWARFOpcode.const4u.rawValue,
            0x12, 0x34, 0x56,
        ])

        XCTAssertEqual(
            decode(data, addressSize: 8, format: ._64bit, endian: .little),
            []
        )
    }

    func testLocationDescriptionPropagatesEndian() {
        for endian: Endian in [.little, .big] {
            var data = Data([
                DWARFLocationOpcode.default_location.rawValue,
                5, // Description byte count.
                DWARFOpcode.const4u.rawValue,
            ])
            appendFixedWidth(0x12345678, to: &data, size: 4, endian: endian)
            data.append(DWARFLocationOpcode.end_of_list.rawValue)

            XCTAssertEqual(
                Array(
                    DWARFLocationList.Operations(
                        data: data,
                        addressSize: 8,
                        format: ._32bit,
                        segmentSelectorSize: 0,
                        endian: endian
                    )
                ),
                [
                    .default_location(descriptions: [.const4u(0x12345678)]),
                    .end_of_list,
                ],
                "\(endian)"
            )
        }
    }

    func testDataIntegerConversionSupportsSignedEndianValues() {
        let littleEndianValue: Int16 = Data([0xdc, 0xfe])
            .uintValue(endian: .little)
        let bigEndianValue: Int16 = Data([0xfe, 0xdc])
            .uintValue(endian: .big)

        XCTAssertEqual(littleEndianValue, -292)
        XCTAssertEqual(bigEndianValue, -292)
    }
}

private func decode(
    _ data: Data,
    addressSize: Int,
    format: DWARFFormat,
    endian: Endian
) -> [DWARFOperation] {
    data.withUnsafeBytes { rawBuffer in
        guard let baseAddress = rawBuffer.baseAddress else { return [] }
        let basePointer = baseAddress.assumingMemoryBound(to: UInt8.self)
        var nextOffset = 0
        var done = false
        var operations: [DWARFOperation] = []

        while nextOffset < data.count, !done {
            guard let operation: DWARFOperation = .readNext(
                basePointer: basePointer,
                operaionsSize: data.count,
                addressSize: addressSize,
                format: format,
                endian: endian,
                nextOffset: &nextOffset,
                done: &done
            ) else { break }
            operations.append(operation)
        }
        return operations
    }
}

private func append(_ opcode: DWARFOpcode, to data: inout Data) {
    data.append(opcode.rawValue)
}

private func appendFixedWidth(
    _ value: UInt64,
    to data: inout Data,
    size: Int,
    endian: Endian
) {
    let bytes = (0..<size).map { index -> UInt8 in
        let shift = endian == .little ? index * 8 : (size - 1 - index) * 8
        return UInt8(truncatingIfNeeded: value >> shift)
    }
    data.append(contentsOf: bytes)
}
