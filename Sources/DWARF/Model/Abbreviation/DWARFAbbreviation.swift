//
//  DWARFAbbreviation.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/23
//  
//

import Foundation

public struct DWARFAbbreviation: Sendable {
    public let code: UInt
    public let tag: DWARFTag
    public let hasChildren: Bool
    public let attributes: [(DWARFAttribute, DWARFAttributeFormat)]

    public let layoutSize: Int
}

extension DWARFAbbreviation {
    package static func _load(
        at offset: Int,
        from binary: some _DWARFBinary,
        isTerminator: inout Bool
    ) -> Self? {
        let initialOffset = offset + binary.headerStartOffset
        var offset = offset + binary.headerStartOffset

        let (code, codeSize) = UnsafeRawPointer(binary.fileHandle.ptr)
            .advanced(by: offset)
            .assumingMemoryBound(to: UInt8.self)
            .readULEB128()
        if code == 0 {
            isTerminator = true
            return nil
        }
        offset += numericCast(codeSize)

        let (tag, tagSize) = UnsafeRawPointer(binary.fileHandle.ptr)
            .advanced(by: offset)
            .assumingMemoryBound(to: UInt8.self)
            .readULEB128()
        offset += numericCast(tagSize)

        let hasChildren = binary.fileHandle.ptr
            .advanced(by: offset)
            .load(as: UInt8.self) != 0
        offset += 1

        var attributes: [(DWARFAttribute, DWARFAttributeFormat)] = []
        while true {
            let (attributeCode, attributeCodeSize) = UnsafeRawPointer(binary.fileHandle.ptr)
                .advanced(by: offset)
                .assumingMemoryBound(to: UInt8.self)
                .readULEB128()
            offset += numericCast(attributeCodeSize)

            let (formatCode, formatCodeSize) = UnsafeRawPointer(binary.fileHandle.ptr)
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
                from: UnsafeRawPointer(binary.fileHandle.ptr)
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
