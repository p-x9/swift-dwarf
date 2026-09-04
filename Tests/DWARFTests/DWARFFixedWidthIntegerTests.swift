import Foundation
import XCTest
@testable import DWARF

final class DWARFFixedWidthIntegerTests: XCTestCase {
    func testShortInputsUseDestinationSignedness() {
        for endian: Endian in [.little, .big] {
            let bytes: [UInt8] = endian == .little ? [0xdc, 0xfe] : [0xfe, 0xdc]
            XCTAssertEqual(Int32(bytes: bytes, endian: endian), -292)
            XCTAssertEqual(UInt32(bytes: bytes, endian: endian), 0xfedc)
            XCTAssertEqual(Int16(bytes: [0xff], endian: endian), -1)
            XCTAssertEqual(UInt16(bytes: [0xff], endian: endian), 255)
            XCTAssertEqual(Int64(bytes: [0x80], endian: endian), -128)
            XCTAssertEqual(UInt64(bytes: [0x80], endian: endian), 128)
            XCTAssertEqual(Int64(bytes: [0x7f], endian: endian), 127)
            XCTAssertEqual(Int64(bytes: [0x00], endian: endian), 0)

            let dataValue: Int32? = Data(bytes).integerValue(endian: endian)
            XCTAssertEqual(dataValue, -292)
            bytes.withUnsafeBufferPointer { buffer in
                var offset = 0
                let signed: Int32? = buffer.readFixedWidthInteger(
                    byteCount: 2, endian: endian, nextOffset: &offset
                )
                XCTAssertEqual(signed, -292)
                XCTAssertEqual(offset, 2)
                offset = 0
                let unsigned: UInt32? = buffer.readFixedWidthInteger(
                    byteCount: 2, endian: endian, nextOffset: &offset
                )
                XCTAssertEqual(unsigned, 0xfedc)
                XCTAssertEqual(offset, 2)
            }
        }
    }

    func testEveryByteWidthAndIntegerType() {
        checkByteWidths(Int8.self)
        checkByteWidths(UInt8.self)
        checkByteWidths(Int16.self)
        checkByteWidths(UInt16.self)
        checkByteWidths(Int32.self)
        checkByteWidths(UInt32.self)
        checkByteWidths(Int64.self)
        checkByteWidths(UInt64.self)
        checkByteWidths(Int.self)
        checkByteWidths(UInt.self)
    }

    private func checkByteWidths<T: FixedWidthInteger>(_ type: T.Type) {
        for width in 1...(T.bitWidth / 8) {
            let negative = [UInt8](repeating: 0xff, count: width)
            let allOnes = T.isSigned ? ~T.zero : T.max >> (T.bitWidth - width * 8)
            let highBit: T = T.isSigned
                ? ~T.zero << (width * 8 - 1)
                : T(1) << (width * 8 - 1)
            for endian: Endian in [.little, .big] {
                var minimum = [UInt8](repeating: 0, count: width)
                minimum[endian == .little ? width - 1 : 0] = 0x80
                XCTAssertEqual(T(bytes: minimum, endian: endian), highBit)
                XCTAssertEqual(T(bytes: negative, endian: endian), allOnes)
                XCTAssertEqual(T(bytes: [UInt8](repeating: 0, count: width), endian: endian), 0)
            }
        }
    }

    func testEmptyAndOversizedInputsReturnNil() {
        for endian: Endian in [.little, .big] {
            XCTAssertNil(Int64(bytes: [UInt8](), endian: endian))
            XCTAssertNil(UInt64(bytes: [UInt8](), endian: endian))
            XCTAssertNil(Int8(bytes: [0, 1], endian: endian))
            XCTAssertNil(UInt64(bytes: [UInt8](repeating: 0, count: 9), endian: endian))
            let empty: Int16? = Data().integerValue(endian: endian)
            let oversized: UInt8? = Data([0, 1]).integerValue(endian: endian)
            XCTAssertNil(empty)
            XCTAssertNil(oversized)
        }
    }

    func testSlicesDoNotRequireZeroBasedIndices() {
        for endian: Endian in [.little, .big] {
            let bytes: [UInt8] = endian == .little ? [0xdc, 0xfe] : [0xfe, 0xdc]
            let arraySlice = ([0xaa] + bytes).dropFirst()
            let dataSlice = Data([0xaa] + bytes).dropFirst()
            XCTAssertEqual(arraySlice.startIndex, 1)
            XCTAssertEqual(dataSlice.startIndex, 1)
            XCTAssertEqual(Int32(bytes: arraySlice, endian: endian), -292)
            let value: Int32? = dataSlice.integerValue(endian: endian)
            XCTAssertEqual(value, -292)
        }
    }

    func testUnalignedBufferReadsAndCursorAdvancement() {
        let storage = UnsafeMutableRawPointer.allocate(byteCount: 16, alignment: 8)
        defer { storage.deallocate() }
        let bytes = storage.initializeMemory(as: UInt8.self, repeating: 0xee, count: 16)
        let encoded: [UInt8] = [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef]
        for (index, byte) in encoded.enumerated() {
            bytes[index + 1] = byte
        }
        // Guaranteed unaligned to UInt64, with allocated bytes beyond the buffer.
        let buffer = UnsafeBufferPointer(start: bytes.advanced(by: 1), count: 8)
        for endian: Endian in [.little, .big] {
            var offset = 0
            let value: UInt64? = buffer.readFixedWidthInteger(
                endian: endian, nextOffset: &offset
            )
            XCTAssertEqual(value, endian == .big ? 0x0123456789abcdef : 0xefcdab8967452301)
            XCTAssertEqual(offset, 8)
            let pastEnd: UInt8? = buffer.readFixedWidthInteger(
                endian: endian, nextOffset: &offset
            )
            XCTAssertNil(pastEnd)
            XCTAssertEqual(offset, 8)

            offset = 1
            let middle: UInt16? = buffer.readFixedWidthInteger(
                endian: endian, nextOffset: &offset
            )
            XCTAssertEqual(middle, endian == .big ? 0x2345 : 0x4523)
            XCTAssertEqual(offset, 3)
        }
    }

    func testInvalidBufferReadsLeaveCursorUnchanged() {
        let bytes: [UInt8] = [0xaa, 0xbb, 0xcc]
        bytes.withUnsafeBufferPointer { buffer in
            for endian: Endian in [.little, .big] {
                for (start, width) in [
                    (-1, 1), (Int.min, 1), (Int.max, 1), (4, 1), (3, 1),
                    (2, 2), (0, 4), (0, 0), (0, -1), (0, 9), (1, Int.max)
                ] {
                    var offset = start
                    let value: UInt64? = buffer.readFixedWidthInteger(
                        byteCount: width, endian: endian, nextOffset: &offset
                    )
                    XCTAssertNil(value, "offset: \(start), width: \(width)")
                    XCTAssertEqual(offset, start)
                }
                var offset = 0
                let tooWide: UInt8? = buffer.readFixedWidthInteger(
                    byteCount: 2, endian: endian, nextOffset: &offset
                )
                XCTAssertNil(tooWide)
                XCTAssertEqual(offset, 0)
            }
        }
        let empty = UnsafeBufferPointer<UInt8>(start: nil, count: 0)
        var offset = 0
        let value: UInt8? = empty.readFixedWidthInteger(endian: .little, nextOffset: &offset)
        XCTAssertNil(value)
        XCTAssertEqual(offset, 0)
    }

    func testAddressAndRangeDecodeSlicedData() {
        for endian: Endian in [.little, .big] {
            // One-byte segment selector; two-byte address and length.
            let addressBytes: [UInt8] = endian == .little ? [0xff, 0x80] : [0x80, 0xff]
            let lengthBytes: [UInt8] = endian == .little ? [0x34, 0x12] : [0x12, 0x34]
            for selectorSize in [0, 1] {
                let selector: [UInt8] = selectorSize == 0 ? [] : [0xff]
                let data = Data([0xaa] + selector + addressBytes + lengthBytes).dropFirst()
                let range = DWARFAddressRange(
                    data: data, addressSize: 2,
                    segmentSelectorSize: selectorSize, endian: endian
                )
                XCTAssertEqual(range?.address.address, 0x80ff)
                XCTAssertEqual(range?.address.segmentSelector, selectorSize == 0 ? nil : 255)
                XCTAssertEqual(range?.length, 0x1234)
            }
        }
    }

    func testInvalidAddressWidthsAndTruncationReturnNil() {
        for (addressSize, selectorSize) in [
            (0, 0), (-1, 0), (9, 0), (1, -1), (1, 9), (Int.max, Int.max)
        ] {
            XCTAssertNil(DWARFAddress(
                data: Data(), addressSize: addressSize,
                segmentSelectorSize: selectorSize, endian: .little
            ))
            XCTAssertNil(DWARFAddressRange(
                data: Data(), addressSize: addressSize,
                segmentSelectorSize: selectorSize, endian: .little
            ))
        }
        let bytes: [UInt8] = [0xaa, 0xff, 0x12]
        bytes.withUnsafeBufferPointer { buffer in
            var offset = 1
            let address = DWARFAddress.load(
                buffer: buffer, nextOffset: &offset, addressSize: 2,
                segmentSelectorSize: 1, endian: .little
            )
            XCTAssertNil(address)
            XCTAssertEqual(offset, 1)
        }
    }
}
