//
//  DWARFNameIndexAbbreviation.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/21
//  
//

import Foundation

public struct DWARFNameIndexAbbreviation: Sendable {
    public let code: UInt
    public let tag: DWARFTag
    public let attributes: [(DWARFNameIndexAttribute, DWARFAttributeFormat)]

    public let layoutSize: Int
}

extension DWARFNameIndexAbbreviation {
    package static func _load(
        at offset: Int,
        from binary: some _DWARFBinary,
        isTerminater: inout Bool
    ) -> Self? {
        let initialOffset = offset + binary.headerStartOffset
        var offset = offset + binary.headerStartOffset

        let (code, codeSize) = UnsafeRawPointer(binary.fileHandle.ptr)
            .advanced(by: offset)
            .assumingMemoryBound(to: UInt8.self)
            .readULEB128()
        if code == 0 {
            isTerminater = true
            return nil
        }
        offset += numericCast(codeSize)

        let (tag, tagSize) = UnsafeRawPointer(binary.fileHandle.ptr)
            .advanced(by: offset)
            .assumingMemoryBound(to: UInt8.self)
            .readULEB128()
        offset += numericCast(tagSize)

        var attributes: [(DWARFNameIndexAttribute, DWARFAttributeFormat)] = []
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

            guard let attribute = DWARFNameIndexAttribute(rawValue: .init(attributeCode)) else {
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
            attributes: attributes,
            layoutSize: offset - initialOffset
        )
    }
}
