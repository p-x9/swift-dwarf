//
//  DWARFAbbreviation.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/23
//  
//

import Foundation
@testable import MachOKit // FIXME: FileIO

public struct DWARFAbbreviation {
    public let code: UInt
    public let tag: DWARFTag
    public let hasChildren: Bool
    public let attributes: [(DWARFAttribute, DWARFAttributeFormat)]

    public let size: Int
}

extension DWARFAbbreviation {
    public static func load(
        at offset: Int,
        from machO: MachOFile,
        isTerminater: inout Bool
    ) -> Self? {
        let initialOffset = offset
        var offset = offset

        let (code, codeSize) = UnsafeRawPointer(machO.fileHandle.ptr)
            .advanced(by: offset)
            .assumingMemoryBound(to: UInt8.self)
            .readULEB128()
        if code == 0 {
            isTerminater = true
            return nil
        }
        offset += numericCast(codeSize)

        let (tag, tagSize) = UnsafeRawPointer(machO.fileHandle.ptr)
            .advanced(by: offset)
            .assumingMemoryBound(to: UInt8.self)
            .readULEB128()
        offset += numericCast(tagSize)

        let hasChildren = machO.fileHandle.ptr
            .advanced(by: offset)
            .load(as: UInt8.self) != 0
        offset += 1

        var attributes: [(DWARFAttribute, DWARFAttributeFormat)] = []
        while true {
            let (attributeCode, attributeCodeSize) = UnsafeRawPointer(machO.fileHandle.ptr)
                .advanced(by: offset)
                .assumingMemoryBound(to: UInt8.self)
                .readULEB128()
            offset += numericCast(attributeCodeSize)

            let (formatCode, formatCodeSize) = UnsafeRawPointer(machO.fileHandle.ptr)
                .advanced(by: offset)
                .assumingMemoryBound(to: UInt8.self)
                .readULEB128()

            guard attributeCode != 0 && formatCode != 0 else {
                offset += numericCast(formatCodeSize)
                break
            }

            guard let attribute = DWARFAttribute(rawValue: .init(attributeCode)) else {
                fatalError()
            }
            let format = DWARFAttributeFormat.load(
                from: UnsafeRawPointer(machO.fileHandle.ptr)
                    .advanced(by: offset)
            )
            offset += numericCast(format.size)

            attributes.append((attribute, format))
        }

        return .init(
            code: numericCast(code),
            tag: .init(rawValue: .init(tag))!,
            hasChildren: hasChildren,
            attributes: attributes,
            size: offset - initialOffset
        )
    }
}
