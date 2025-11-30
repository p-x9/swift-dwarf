//
//  DWARFLineHeader.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/24
//  
//

import Foundation
@testable @_spi(Support) import MachOKit
import DWARFC

public enum DWARFLineHeader {
    case upToVersion4(DWARF4LineHeader64)
    case version5(DWARF5LineHeader64)

    case upToVersion4_32(DWARF4LineHeader32)
    case version5_32(DWARF5LineHeader32)
}

extension DWARFLineHeader {
    public var offset: Int {
        switch self {
        case .upToVersion4(let header):
            header.offset
        case .version5(let header):
            header.offset
        case .upToVersion4_32(let header):
            header.offset
        case .version5_32(let header):
            header.offset
        }
    }
}

extension DWARFLineHeader {
    public var layoutSize: Int {
        switch self {
        case .upToVersion4(let header):
            header.layoutSize
        case .version5(let header):
            header.layoutSize
        case .upToVersion4_32(let header):
            header.layoutSize
        case .version5_32(let header):
            header.layoutSize
        }
    }
}

extension DWARFLineHeader {
    public var format: DWARFFormat {
        switch self {
        case .upToVersion4, .version5:
                ._64bit
        case .upToVersion4_32, .version5_32:
                ._32bit
        }
    }

    // size of `unit_length` field is not contained in `length`
    public var length: Int {
        switch self {
        case .upToVersion4(let header):
            numericCast(header.unit_length.value)
        case .version5(let header):
            numericCast(header.unit_length.value)
        case .upToVersion4_32(let header):
            numericCast(header.unit_length.value)
        case .version5_32(let header):
            numericCast(header.unit_length.value)
        }
    }

    public var version: DWARFVersion {
        switch self {
        case .upToVersion4(let header):
                .init(rawValue: numericCast(header.version))!
        case .version5(let header):
                .init(rawValue: numericCast(header.version))!
        case .upToVersion4_32(let header):
                .init(rawValue: numericCast(header.version))!
        case .version5_32(let header):
                .init(rawValue: numericCast(header.version))!
        }
    }

    public var addressSize: Int {
        switch self {
        case .upToVersion4(let header):
            header.addressSize
        case .version5(let header):
            numericCast(header.address_size)
        case .upToVersion4_32(let header):
            header.addressSize
        case .version5_32(let header):
            numericCast(header.address_size)
        }
    }
}

extension DWARFLineHeader {
    public var opecodeBase: UInt8 {
        switch self {
        case .upToVersion4(let header):
            header.opcode_base
        case .version5(let header):
            header.opcode_base
        case .upToVersion4_32(let header):
            header.opcode_base
        case .version5_32(let header):
            header.opcode_base
        }
    }

    public var lineBase: Int8 {
        switch self {
        case .upToVersion4(let header):
            header.line_base
        case .version5(let header):
            header.line_base
        case .upToVersion4_32(let header):
            header.line_base
        case .version5_32(let header):
            header.line_base
        }
    }

    public var lineRange: UInt8 {
        switch self {
        case .upToVersion4(let header):
            header.line_range
        case .version5(let header):
            header.line_range
        case .upToVersion4_32(let header):
            header.line_range
        case .version5_32(let header):
            header.line_range
        }
    }

    public var defaultOfIsStmt: Bool {
        switch self {
        case .upToVersion4(let header):
            header.default_is_stmt > 0
        case .version5(let header):
            header.default_is_stmt > 0
        case .upToVersion4_32(let header):
            header.default_is_stmt > 0
        case .version5_32(let header):
            header.default_is_stmt > 0
        }
    }

    public var minimumInstructionLength: UInt8 {
        switch self {
        case .upToVersion4(let header):
            header.minimum_instruction_length
        case .version5(let header):
            header.minimum_instruction_length
        case .upToVersion4_32(let header):
            header.minimum_instruction_length
        case .version5_32(let header):
            header.minimum_instruction_length
        }
    }

    public var maximumOperationsPerInstruction: UInt8 {
        switch self {
        case .upToVersion4(let header):
            header.maximum_operations_per_instruction
        case .version5(let header):
            header.maximum_operations_per_instruction
        case .upToVersion4_32(let header):
            header.maximum_operations_per_instruction
        case .version5_32(let header):
            header.maximum_operations_per_instruction
        }
    }
}

extension DWARFLineHeader {
    public static func load(at offset: Int, in machO: MachOFile) throws -> Self? {
        let offset = offset + machO.headerStartOffset
        let length: UInt32 = try machO.fileHandle.read(offset: offset)
        let is64Bit = length == 0xffffffff

        let version: UInt16 = try machO.fileHandle.read(
            offset: offset + (is64Bit ? MemoryLayout<dwarf_init_len64>.size : MemoryLayout<dwarf_init_len32>.size)
        )

        switch (is64Bit, version) {
        case (true, _) where version <= 4:
            guard let header: DWARF4LineHeader64 = try .load(at: offset - machO.headerStartOffset, in: machO) else {
                return nil
            }
            return .upToVersion4(header)
        case (false, _) where version <= 4:
            guard let header: DWARF4LineHeader32 = try .load(at: offset - machO.headerStartOffset, in: machO) else {
                return nil
            }
            return .upToVersion4_32(header)
        case (true, 5):
            guard let header: DWARF5LineHeader64 = try .load(at: offset - machO.headerStartOffset, in: machO) else {
                return nil
            }
            return .version5(header)
        case (false, 5):
            guard let header: DWARF5LineHeader32 = try .load(at: offset - machO.headerStartOffset, in: machO) else {
                return nil
            }
            return .version5_32(header)
        default: return nil
        }
    }
}

public struct DWARF5LineHeader64: LayoutWrapper {
    public typealias Layout = dwarf5_line_header64_t

    public var layout: Layout
    public let standard_opcode_lengths: [UInt8]
    /* Directory */
    public let directory_entry_format_count: UInt8
    public let directory_entry_format: [DWARFFileEntryFormat]
    public let directories_count: UInt64
    public let directories: [DWARFFileEntry]
    /* File */
    public let file_name_entry_format_count: UInt8
    public let file_name_entry_format: [DWARFFileEntryFormat]
    public let file_names_count: UInt64
    public let file_names: [DWARFFileEntry]

    public let offset: Int
    public let layoutSize: Int
}

extension DWARF5LineHeader64 {
    public static func load(at offset: Int, in machO: MachOFile) throws -> Self? {
        let offset = offset + machO.headerStartOffset

        let layout: Layout = try machO.fileHandle.read(offset: offset)

        let standard_opcode_lengths: [UInt8] = Array(
            machO.fileHandle.readDataSequence(
                offset: numericCast(offset + MemoryLayout<Layout>.size),
                numberOfElements: numericCast(layout.opcode_base) - 1
            )
        )

        var pos: UInt64 = numericCast(
            offset + MemoryLayout<Layout>.size + standard_opcode_lengths.count
        )
        let directory_entry_format_count: dwarf_ubyte = machO.fileHandle.read(offset: pos)
        pos += 1

        let directory_entry_format: [DWARFFileEntryFormat] = try readDWARF5FileEntryFormat(
            pos: &pos,
            from: machO,
            numberOfFormats: numericCast(directory_entry_format_count)
        )

        let (directories_count, size) = machO.fileHandle.readULEB128(
            baseOffset: pos
        )
        pos += numericCast(size)

        let directories: [DWARFFileEntry] = try readDWARF5FileEntries(
            pos: &pos,
            from: machO,
            numberOfEntries: numericCast(directories_count),
            format: directory_entry_format,
            dwarfFormat: ._64bit,
            addressSize: numericCast(layout.address_size)
        )

        let file_name_entry_format_count: dwarf_ubyte = machO.fileHandle.read(offset: pos)
        pos += 1

        let file_name_entry_format: [DWARFFileEntryFormat] = try readDWARF5FileEntryFormat(
            pos: &pos,
            from: machO,
            numberOfFormats: numericCast(file_name_entry_format_count)
        )

        let (file_names_count, size2) = machO.fileHandle.readULEB128(
            baseOffset: pos
        )
        pos += numericCast(size2)

        let file_names: [DWARFFileEntry] = try readDWARF5FileEntries(
            pos: &pos,
            from: machO,
            numberOfEntries: numericCast(file_names_count),
            format: file_name_entry_format,
            dwarfFormat: ._64bit,
            addressSize: numericCast(layout.address_size)
        )

        return .init(
            layout: layout,
            standard_opcode_lengths: standard_opcode_lengths,
            directory_entry_format_count: directory_entry_format_count,
            directory_entry_format: directory_entry_format,
            directories_count: numericCast(directories_count),
            directories: directories,
            file_name_entry_format_count: file_name_entry_format_count,
            file_name_entry_format: file_name_entry_format,
            file_names_count: numericCast(file_names_count),
            file_names: file_names,
            offset: offset - machO.headerStartOffset,
            layoutSize: numericCast(pos) - offset
        )
    }
}

public struct DWARF5LineHeader32: LayoutWrapper {
    public typealias Layout = dwarf5_line_header32_t

    public var layout: Layout
    public let standard_opcode_lengths: [UInt8]
    /* Directory */
    public let directory_entry_format_count: UInt8
    public let directory_entry_format: [DWARFFileEntryFormat]
    public let directories_count: UInt64
    public let directories: [DWARFFileEntry]
    /* File */
    public let file_name_entry_format_count: UInt8
    public let file_name_entry_format: [DWARFFileEntryFormat]
    public let file_names_count: UInt64
    public let file_names: [DWARFFileEntry]

    public let offset: Int
    public let layoutSize: Int
}

extension DWARF5LineHeader32 {
    public static func load(at offset: Int, in machO: MachOFile) throws -> Self? {
        let offset = offset + machO.headerStartOffset

        let layout: Layout = try machO.fileHandle.read(offset: offset)

        let standard_opcode_lengths: [UInt8] = Array(
            machO.fileHandle.readDataSequence(
                offset: numericCast(offset + MemoryLayout<Layout>.size),
                numberOfElements: numericCast(layout.opcode_base) - 1
            )
        )

        var pos: UInt64 = numericCast(
            offset + MemoryLayout<Layout>.size + standard_opcode_lengths.count
        )
        let directory_entry_format_count: dwarf_ubyte = machO.fileHandle.read(offset: pos)
        pos += 1

        let directory_entry_format: [DWARFFileEntryFormat] = try readDWARF5FileEntryFormat(
            pos: &pos,
            from: machO,
            numberOfFormats: numericCast(directory_entry_format_count)
        )

        let (directories_count, size) = machO.fileHandle.readULEB128(
            baseOffset: pos
        )
        pos += numericCast(size)
        
        let directories: [DWARFFileEntry] = try readDWARF5FileEntries(
            pos: &pos,
            from: machO,
            numberOfEntries: numericCast(directories_count),
            format: directory_entry_format,
            dwarfFormat: ._32bit,
            addressSize: numericCast(layout.address_size)
        )

        let file_name_entry_format_count: dwarf_ubyte = machO.fileHandle.read(offset: pos)
        pos += 1

        let file_name_entry_format: [DWARFFileEntryFormat] = try readDWARF5FileEntryFormat(
            pos: &pos,
            from: machO,
            numberOfFormats: numericCast(file_name_entry_format_count)
        )

        let (file_names_count, size2) = machO.fileHandle.readULEB128(
            baseOffset: pos
        )
        pos += numericCast(size2)

        let file_names: [DWARFFileEntry] = try readDWARF5FileEntries(
            pos: &pos,
            from: machO,
            numberOfEntries: numericCast(file_names_count),
            format: file_name_entry_format,
            dwarfFormat: ._32bit,
            addressSize: numericCast(layout.address_size)
        )

        return .init(
            layout: layout,
            standard_opcode_lengths: standard_opcode_lengths,
            directory_entry_format_count: directory_entry_format_count,
            directory_entry_format: directory_entry_format,
            directories_count: numericCast(directories_count),
            directories: directories,
            file_name_entry_format_count: file_name_entry_format_count,
            file_name_entry_format: file_name_entry_format,
            file_names_count: numericCast(file_names_count),
            file_names: file_names,
            offset: offset - machO.headerStartOffset,
            layoutSize: numericCast(pos) - offset
        )
    }
}

public struct DWARF4LineHeader64: LayoutWrapper {
    public typealias Layout = dwarf4_line_header64_t

    public var layout: Layout
    public let standard_opcode_lengths: [UInt8]
    public let include_directories: [String]
    public let file_names: [DWARF4FileEntry]

    public let addressSize: Int

    public let offset: Int
    public let layoutSize: Int
}

extension DWARF4LineHeader64 {
    public static func load(at offset: Int, in machO: MachOFile) throws -> Self? {
        let offset = offset + machO.headerStartOffset

        let layout: Layout = try machO.fileHandle.read(offset: offset)

        let standard_opcode_lengths: [UInt8] = Array(
            machO.fileHandle.readDataSequence(
                offset: numericCast(offset + MemoryLayout<Layout>.size),
                numberOfElements: numericCast(layout.opcode_base) - 1
            )
        )

        var pos: UInt64 = numericCast(
            offset + MemoryLayout<Layout>.size + standard_opcode_lengths.count
        )

        let include_directories = try readDWARF4IncludeDirectories(
            pos: &pos,
            in: machO
        )
        let file_names = try readDWARF4FileEntries(pos: &pos, in: machO)

        return .init(
            layout: layout,
            standard_opcode_lengths: standard_opcode_lengths,
            include_directories: include_directories,
            file_names: file_names,
            addressSize: machO.is64Bit ? 8 : 4,
            offset: offset - machO.headerStartOffset,
            layoutSize: numericCast(pos) - offset
        )
    }
}

public struct DWARF4LineHeader32: LayoutWrapper {
    public typealias Layout = dwarf4_line_header32_t

    public var layout: Layout
    public let standard_opcode_lengths: [UInt8]
    public let include_directories: [String]
    public let file_names: [DWARF4FileEntry]

    public let addressSize: Int

    public let offset: Int
    public let layoutSize: Int
}

extension DWARF4LineHeader32 {
    public static func load(at offset: Int, in machO: MachOFile) throws -> Self? {
        let offset = offset + machO.headerStartOffset

        let layout: Layout = try machO.fileHandle.read(offset: offset)

        let standard_opcode_lengths: [UInt8] = Array(
            machO.fileHandle.readDataSequence(
                offset: numericCast(offset + MemoryLayout<Layout>.size),
                numberOfElements: numericCast(layout.opcode_base) - 1
            )
        )

        var pos: UInt64 = numericCast(
            offset + MemoryLayout<Layout>.size + standard_opcode_lengths.count
        )

        let include_directories = try readDWARF4IncludeDirectories(
            pos: &pos,
            in: machO
        )
        let file_names = try readDWARF4FileEntries(pos: &pos, in: machO)

        return .init(
            layout: layout,
            standard_opcode_lengths: standard_opcode_lengths,
            include_directories: include_directories,
            file_names: file_names,
            addressSize: machO.is64Bit ? 8 : 4,
            offset: offset - machO.headerStartOffset,
            layoutSize: numericCast(pos) - offset
        )
    }
}

// MARK: - fileprivate functions

fileprivate func readDWARF5FileEntryFormat(
    pos: inout UInt64,
    from machO: MachOFile,
    numberOfFormats: Int
) throws -> [DWARFFileEntryFormat] {
    var formats: [DWARFFileEntryFormat] = []
    for _ in 0 ..< numberOfFormats {
        let format: DWARFFileEntryFormat = try .load(
            at: numericCast(pos),
            in: machO
        )!
        pos += numericCast(format.layoutSize)
        formats.append(format)
    }
    return formats
}

fileprivate func readDWARF5FileEntries(
    pos: inout UInt64,
    from machO: MachOFile,
    numberOfEntries: Int,
    format: [DWARFFileEntryFormat],
    dwarfFormat: DWARFFormat,
    addressSize: Int
) throws -> [DWARFFileEntry] {
    var entries: [DWARFFileEntry] = []
    for _ in 0 ..< numberOfEntries {
        let entry: DWARFFileEntry = try .load(
            at: numericCast(pos),
            for: format,
            in: machO,
            dwarfFormat: dwarfFormat,
            addressSize: addressSize
        )!
        entries.append(entry)
        pos += numericCast(entry.layoutSize)
    }
    return entries
}

fileprivate func readDWARF4FileEntries(
    pos: inout UInt64,
    in machO: MachOFile
) throws -> [DWARF4FileEntry] {
    var file_names: [DWARF4FileEntry] = []
    while true {
        guard let entry: DWARF4FileEntry = try .load(at: numericCast(pos) - machO.headerStartOffset, in: machO) else {
            pos += 1
            break
        }
        pos += numericCast(entry.layoutSize)
        file_names.append(entry)
    }
    return file_names
}

fileprivate func readDWARF4IncludeDirectories(
    pos: inout UInt64,
    in machO: MachOFile
) throws -> [String] {
    var include_directories: [String] = []
    while true {
        guard let string = machO.fileHandle.readString(offset: pos) else {
            pos += 1
            break
        }
        if string.isEmpty {
            pos += 1
            break
        }
        include_directories.append(string)
        pos += numericCast(string.utf8.count) + 1
    }
    return include_directories
}
