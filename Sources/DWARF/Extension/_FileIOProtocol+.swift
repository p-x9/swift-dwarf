//
//  _FileIOProtocol+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/29
//  
//

// Copied from https://github.com/p-x9/MachOKit/blob/e5c946ad1c9d5d07798d9885b2b66946b5db88c6/Sources/MachOKit/Extension/_FileIOProtocol%2B.swift

import Foundation
@_spi(Support) import MachOKit
#if compiler(>=6.0) || (compiler(>=5.10) && hasFeature(AccessLevelOnImport))
internal import FileIO
#else
@_implementationOnly import FileIO
#endif

extension _FileIOProtocol {
    func readDataSequence<Element>(
        offset: UInt64,
        numberOfElements: Int,
        swapHandler: ((inout Data) -> Void)? = nil
    ) /*throws*/ -> DataSequence<Element> where Element: LayoutWrapper {
        let size = Element.layoutSize * numberOfElements
        var data = try! readData(
            offset: numericCast(offset),
            length: size
        )
        precondition(
            Element.layoutSize == MemoryLayout<Element>.size,
            "Invalid Layout Size"
        )
        precondition(
            data.count >= size,
            "Invalid Data Size"
        )
        if let swapHandler { swapHandler(&data) }
        return .init(
            data: data,
            numberOfElements: numberOfElements
        )
    }

    @_disfavoredOverload
    func readDataSequence<Element>(
        offset: UInt64,
        numberOfElements: Int,
        swapHandler: ((inout Data) -> Void)? = nil
    ) /*throws*/ -> DataSequence<Element> {
        let size = MemoryLayout<Element>.size * numberOfElements
        var data = try! readData(
            offset: numericCast(offset),
            length: size
        )
        precondition(
            data.count >= size,
            "Invalid Data Size"
        )
        if let swapHandler { swapHandler(&data) }
        return .init(
            data: data,
            numberOfElements: numberOfElements
        )
    }


    func readDataSequence<Element>(
        offset: UInt64,
        entrySize: Int,
        numberOfElements: Int,
        swapHandler: ((inout Data) -> Void)? = nil
    ) -> DataSequence<Element> where Element: LayoutWrapper {
        let size = entrySize * numberOfElements
        var data = try! readData(
            offset: numericCast(offset),
            length: size
        )
        precondition(
            Element.layoutSize == MemoryLayout<Element>.size,
            "Invalid Layout Size"
        )
        precondition(
            data.count >= size,
            "Invalid Data Size"
        )
        if let swapHandler { swapHandler(&data) }
        return .init(
            data: data,
            entrySize: entrySize
        )
    }


    @_disfavoredOverload
    func readDataSequence<Element>(
        offset: UInt64,
        entrySize: Int,
        numberOfElements: Int,
        swapHandler: ((inout Data) -> Void)? = nil
    ) -> DataSequence<Element> {
        let size = entrySize * numberOfElements
        var data = try! readData(
            offset: numericCast(offset),
            length: size
        )
        precondition(
            data.count >= size,
            "Invalid Data Size"
        )
        if let swapHandler { swapHandler(&data) }
        return .init(
            data: data,
            entrySize: entrySize
        )
    }
}

extension _FileIOProtocol {
    @inline(__always)
    func read<Element>(
        offset: UInt64
    ) -> Optional<Element> where Element: LayoutWrapper {
        precondition(
            Element.layoutSize == MemoryLayout<Element>.size,
            "Invalid Layout Size"
        )
        return try! read(offset: numericCast(offset), as: Element.self)
    }

    @inline(__always)
    func read<Element>(
        offset: UInt64
    ) -> Optional<Element> {
        try! read(offset: numericCast(offset), as: Element.self)
    }


    @_disfavoredOverload
    @inline(__always)
    func read<Element>(
        offset: UInt64
    ) -> Element where Element: LayoutWrapper {
        precondition(
            Element.layoutSize == MemoryLayout<Element>.size,
            "Invalid Layout Size"
        )
        return try! read(offset: numericCast(offset), as: Element.self)
    }

    @_disfavoredOverload
    @inline(__always)
    func read<Element>(
        offset: UInt64
    ) -> Element {
        try! read(offset: numericCast(offset), as: Element.self)
    }
}

extension _FileIOProtocol {
    func read<Element>(
        offset: UInt64,
        swapHandler: ((inout Data) -> Void)?
    ) -> Optional<Element> where Element: LayoutWrapper {
        var data = try! readData(
            offset: numericCast(offset),
            length: Element.layoutSize
        )
        precondition(
            Element.layoutSize == MemoryLayout<Element>.size,
            "Invalid Layout Size"
        )
        precondition(
            data.count >= Element.layoutSize,
            "Invalid Data Size"
        )
        if let swapHandler { swapHandler(&data) }
        return data.withUnsafeBytes {
            $0.load(as: Element.self)
        }
    }

    func read<Element>(
        offset: UInt64,
        swapHandler: ((inout Data) -> Void)?
    ) -> Optional<Element> {
        var data = try! readData(
            offset: numericCast(offset),
            length: MemoryLayout<Element>.size
        )
        precondition(
            data.count >= MemoryLayout<Element>.size,
            "Invalid Data Size"
        )
        if let swapHandler { swapHandler(&data) }
        return data.withUnsafeBytes {
            $0.load(as: Element.self)
        }
    }

    @_disfavoredOverload
    func read<Element>(
        offset: UInt64,
        swapHandler: ((inout Data) -> Void)?
    ) -> Element where Element: LayoutWrapper {
        var data = try! readData(
            offset: numericCast(offset),
            length: Element.layoutSize
        )
        precondition(
            Element.layoutSize == MemoryLayout<Element>.size,
            "Invalid Layout Size"
        )
        precondition(
            data.count >= Element.layoutSize,
            "Invalid Data Size"
        )
        if let swapHandler { swapHandler(&data) }
        return data.withUnsafeBytes {
            $0.load(as: Element.self)
        }
    }

    @_disfavoredOverload
    func read<Element>(
        offset: UInt64,
        swapHandler: ((inout Data) -> Void)?
    ) -> Element {
        var data = try! readData(
            offset: numericCast(offset),
            length: MemoryLayout<Element>.size
        )
        precondition(
            data.count >= MemoryLayout<Element>.size,
            "Invalid Data Size"
        )
        if let swapHandler { swapHandler(&data) }
        return data.withUnsafeBytes {
            $0.load(as: Element.self)
        }
    }
}

extension _FileIOProtocol {
    @_disfavoredOverload
    @inline(__always)
    func readString(
        offset: UInt64,
        size: Int
    ) -> String? {
        let data = try! readData(
            offset: numericCast(offset),
            length: size
        )
        return String(cString: data)
    }

    @_disfavoredOverload
    @inline(__always)
    func readString(
        offset: UInt64,
        step: Int = 10
    ) -> String? {
        var data = Data()
        var offset = offset
        while true {
            guard let new = try? readData(
                offset: numericCast(offset),
                upToCount: step
            ) else { break }
            if new.isEmpty { break }
            data.append(new)
            if new.contains(0) { break }
            offset += UInt64(new.count)
        }

        return String(cString: data)
    }
}

extension MemoryMappedFile {
    @inline(__always)
    func readString(
        offset: UInt64
    ) -> String? {
        String(
            cString: ptr
                .advanced(by: numericCast(offset))
                .assumingMemoryBound(to: CChar.self)
        )
    }

    @inline(__always)
    func readString(
        offset: UInt64,
        size: Int // ignored
    ) -> String? {
        readString(offset: offset)
    }

    @inline(__always)
    func readString(
        offset: UInt64,
        step: Int = 10 // ignored
    ) -> String? {
        readString(offset: offset)
    }
}

extension _FileIOProtocol {
    @inline(__always)
    func readAllData() throws -> Data {
        try readData(offset: 0, length: size)
    }
}

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
