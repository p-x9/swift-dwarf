//
//  DWARFFileEntry.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/25
//  
//

import Foundation
@_spi(Support) import MachOKit

public struct DWARF4FileEntry {
    public let name: String
    public let dir_index: UInt64 // uleb128
    public let modification_time: UInt64 // uleb128
    public let file_size: UInt64 // uleb128
}

extension DWARF4FileEntry {
    public var layoutSize: Int {
        let name = name.utf8.count + 1
        let dir_index = dir_index.uleb128Size
        let modification_time = modification_time.uleb128Size
        let file_size = file_size.uleb128Size
        return name + dir_index + modification_time + file_size
    }
}

extension DWARF4FileEntry {
    public static func load(at offset: Int, in machO: MachOFile) throws -> Self? {
        var pos: UInt64 = numericCast(offset + machO.headerStartOffset)
        guard let string = machO.fileHandle.readString(offset: pos),
              !string.isEmpty else {
            pos += 1
            return nil
        }
        pos += numericCast(string.utf8.count) + 1

        let (dir_index, size) = machO.fileHandle.readULEB128(baseOffset: pos)
        pos += UInt64(size)

        let (modification_time, size2) = machO.fileHandle.readULEB128(baseOffset: pos)
        pos += UInt64(size2)

        let (file_size, _) = machO.fileHandle.readULEB128(baseOffset: pos)

        return .init(
            name: string,
            dir_index: numericCast(dir_index),
            modification_time: numericCast(modification_time),
            file_size: numericCast(file_size)
        )
    }
}
