//
//  DWARFDirectoryEntryFormat.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/25
//  
//

import Foundation
import DWARFC

public struct DWARFFileEntryFormat: Sendable {
    public let type: DWARFLineContentType
    public let format: DWARFAttributeFormat
}

extension DWARFFileEntryFormat {
    public var layoutSize: Int {
        type.rawValue.uleb128Size + format.size
    }
}

extension DWARFFileEntryFormat {
    package static func _load(
        at offset: Int,
        in binary: some _DWARFBinary
    ) throws -> Self? {
        let offset = offset + binary.headerStartOffset

        let (_type, size) = binary.fileHandle.readULEB128(
            baseOffset: numericCast(offset)
        )
        guard let type = DWARFLineContentType(rawValue: numericCast(_type)) else {
            return nil
        }

        let format: DWARFAttributeFormat = .load(
            from: binary.fileHandle.ptr.advanced(by: offset + size)
        )

        return .init(
            type: type,
            format: format
        )
    }
}
