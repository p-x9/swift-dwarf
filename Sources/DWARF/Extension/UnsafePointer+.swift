//
//  UnsafePointer+.swift
//
//
//  Created by p-x9 on 2023/12/03.
//
//

import Foundation

extension UnsafePointer<UInt8> {
    func readFixedWidthInteger<T: FixedWidthInteger>(
        byteCount: Int = MemoryLayout<T>.size,
        endian: Endian,
        nextOffset: inout Int,
        endOffset: Int
    ) -> T? {
        guard nextOffset >= 0, endOffset >= nextOffset,
              byteCount > 0, byteCount <= MemoryLayout<T>.size else {
            return nil
        }
        let (operandEndOffset, overflow) = nextOffset
            .addingReportingOverflow(byteCount)
        guard !overflow, operandEndOffset <= endOffset else { return nil }

        let bytes = UnsafeBufferPointer(
            start: advanced(by: nextOffset),
            count: byteCount
        )
        nextOffset = operandEndOffset
        return T(bytes: bytes, endian: endian)
    }

    /// (value, size)
    @_spi(Support)
    public func readULEB128() -> (UInt, Int) {
        var value: UInt = 0
        var shift: UInt = 0
        var offset: Int = 0

        var byte: UInt8 = 0

        repeat {
            byte = advanced(by: offset).pointee

            value += UInt(byte & 0x7F) << shift
            shift += 7
            offset += 1
        } while byte >= 128

        return (value, offset)
    }

    /// (value, size)
    @_spi(Support)
    public func readSLEB128() -> (Int, Int) {
        var value: Int = 0
        var shift: UInt = 0
        var offset: Int = 0

        var byte: UInt8 = 0

        repeat {
            byte = advanced(by: offset).pointee

            value += Int(byte & 0x7F) << shift
            shift += 7
            offset += 1
        } while byte >= 128

        if byte & 0x40 != 0 {
            value |= -(1 << shift)
        }

        return (value, offset)
    }
}

extension UnsafePointer<UInt8> {
    func readString() -> (String, Int) {
        let offset = Int(bitPattern: strchr(self, 0)) + 1 - Int(bitPattern: self)
        let string = String(cString: self)

        return (string, offset)
    }
}

extension UnsafePointer<CChar> {
    func readString() -> (String, Int) {
        let offset = Int(bitPattern: strchr(self, 0)) + 1 - Int(bitPattern: self)
        let string = String(cString: self)

        return (string, offset)
    }
}

extension UnsafePointer where Pointee: FixedWidthInteger {
    func findNullTerminator() -> UnsafePointer<Pointee> {
        var ptr = self
        while ptr.pointee != 0 {
            ptr = ptr.advanced(by: 1)
        }
        return ptr
    }

    func readString<Encoding: _UnicodeEncoding>(
        as encoding: Encoding.Type
    ) -> (String, Int) where Pointee == Encoding.CodeUnit {
        let nullTerminator = findNullTerminator()
        let offset = Int(bitPattern: nullTerminator) + MemoryLayout<Pointee>.size - Int(bitPattern: self)
        let string = String(decodingCString: self, as: Encoding.self)

        return (string, offset)
    }
}
