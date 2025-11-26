//
//  DWARFDirectoryEntryFormat.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/25
//  
//

import Foundation
@testable @_spi(Support) import MachOKit
import DWARFC

public struct DWARFFileEntryFormat {
    public let type: DWARFLineContentType
    public let format: DWARFAttributeFormat
}

extension DWARFFileEntryFormat {
    public var layoutSize: Int {
        type.rawValue.uleb128Size + format.size
    }
}

extension DWARFFileEntryFormat {
    public static func load(at offset: Int, in machO: MachOFile) throws -> Self? {
        let offset = offset + machO.headerStartOffset

        let (_type, size) = machO.fileHandle.readULEB128(
            baseOffset: numericCast(offset)
        )
        guard let type = DWARFLineContentType(rawValue: numericCast(_type)) else {
            return nil
        }

        let format: DWARFAttributeFormat = .load(
            from: machO.fileHandle.ptr.advanced(by: offset + size)
        )

        return .init(
            type: type,
            format: format
        )
    }
}
