//
//  _FileIOProtocol+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/29
//  
//

import Foundation
#if compiler(>=6.0) || (compiler(>=5.10) && hasFeature(AccessLevelOnImport))
internal import FileIO
internal import FileIOBinary
#else
@_implementationOnly import FileIO
@_implementationOnly import FileIOBinary
#endif

extension _FileIOProtocol {
    /// (value, size)
    func readULEB128(
        baseOffset: UInt64
    ) -> (UInt, Int) {
        var value: UInt = 0
        var shift: UInt = 0
        var offset: Int = 0

        var byte: UInt8 = 0

        repeat {
            byte = try! read(offset: numericCast(baseOffset) + offset)

            value += UInt(byte & 0x7F) << shift
            shift += 7
            offset += 1
        } while byte >= 128

        return (value, offset)
    }

    /// (value, size)
    func readSLEB128(
        baseOffset: UInt64
    ) -> (Int, Int) {
        var value: Int = 0
        var shift: UInt = 0
        var offset: Int = 0

        var byte: UInt8 = 0

        repeat {
            byte = try! read(offset: numericCast(baseOffset) + offset)

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
