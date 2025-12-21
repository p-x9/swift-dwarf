//
//  DWARFNameIndexAbbreviation.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/21
//  
//

import Foundation
@testable import MachOKit // FIXME: FileIO

public struct DWARFNameIndexAbbreviation {
    public let code: UInt
    public let tag: DWARFTag
    public let hasChildren: Bool
    public let attributes: [(DWARFNameIndexAttribute, DWARFAttributeFormat)]

    public let layoutSize: Int
}

extension DWARFNameIndexAbbreviation {
    public static func load(
        at offset: Int,
        from machO: MachOFile,
        isTerminater: inout Bool
    ) -> Self? {
        let initialOffset = offset + machO.headerStartOffset
        var offset = offset + machO.headerStartOffset

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

        var attributes: [(DWARFNameIndexAttribute, DWARFAttributeFormat)] = []
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

            guard let attribute = DWARFNameIndexAttribute(rawValue: .init(attributeCode)) else {
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
            layoutSize: offset - initialOffset
        )
    }
}
