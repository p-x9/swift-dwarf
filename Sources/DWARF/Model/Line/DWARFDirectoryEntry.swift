//
//  DWARFDirectoryEntry.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/26
//  
//

import Foundation
@testable @_spi(Support) import MachOKit
import DWARFC

public struct DWARFDirectoryEntry {
    public let contents: [DWARFDirectoryEntryValue]
}

extension DWARFDirectoryEntry {
    public var layoutSize: Int {
        contents.reduce(into: 0, { $0 += $1.layoutSize })
    }
}

extension DWARFDirectoryEntry {
    public static func load(
        at offset: Int,
        for formats: [DWARFDirectoryEntryFormat],
        in machO: MachOFile,
        dwarfFormat: DWARFFormat,
        addressSize: Int
    ) throws -> Self? {
        var pos: Int = numericCast(offset + machO.headerStartOffset)

        var contents: [DWARFDirectoryEntryValue] = []
        for format in formats {
            let value: DWARFDirectoryEntryValue? = try .load(
                at: pos,
                for: format,
                in: machO,
                dwarfFormat: dwarfFormat,
                addressSize: addressSize
            )
            guard let value else { return nil }
            let size = value.value.size(
                dwarfFormat: dwarfFormat,
                addressSize: addressSize
            )
            pos += size
            contents.append(value)
        }

        return .init(contents: contents)
    }
}
