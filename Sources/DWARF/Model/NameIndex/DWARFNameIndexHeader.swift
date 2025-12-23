//
//  DWARFNameIndexHeader.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/02
//  
//

import Foundation
@_spi(Support) import MachOKit
import DWARFC

public enum DWARFNameIndexHeader: Sendable {
    case _64(DWARFNameIndexHeader64)
    case _32(DWARFNameIndexHeader32)
}

extension DWARFNameIndexHeader {
    public var offset: Int {
        switch self {
        case ._64(let header):
            header.offset
        case ._32(let header):
            header.offset
        }
    }

    public var layoutSize: Int {
        switch self {
        case ._64(let header):
            header.layoutSize
        case ._32(let header):
            header.layoutSize
        }
    }
}

extension DWARFNameIndexHeader {
    public var format: DWARFFormat {
        switch self {
        case ._64:
                ._64bit
        case ._32:
                ._32bit
        }
    }

    // size of `unit_length` field is not contained in `length`
    public var length: Int {
        switch self {
        case ._64(let header):
            numericCast(header.unit_length.value)
        case ._32(let header):
            numericCast(header.unit_length.value)
        }
    }

    public var version: DWARFVersion {
        switch self {
        case ._64(let header):
                .init(rawValue: numericCast(header.version))!
        case ._32(let header):
                .init(rawValue: numericCast(header.version))!
        }
    }
}

extension DWARFNameIndexHeader {
    public var numberOfCompirationUnits: Int {
        switch self {
        case ._64(let header):
            numericCast(header.comp_unit_count)
        case ._32(let header):
            numericCast(header.comp_unit_count)
        }
    }

    public var numberOfLocalTypeUnits: Int {
        switch self {
        case ._64(let header):
            numericCast(header.local_type_unit_count)
        case ._32(let header):
            numericCast(header.local_type_unit_count)
        }
    }

    public var numberOfForeignTypeUnits: Int {
        switch self {
        case ._64(let header):
            numericCast(header.foreign_type_unit_count)
        case ._32(let header):
            numericCast(header.foreign_type_unit_count)
        }
    }

    public var numberOfBuckets: Int {
        switch self {
        case ._64(let header):
            numericCast(header.bucket_count)
        case ._32(let header):
            numericCast(header.bucket_count)
        }
    }

    public var numberOfNames: Int {
        switch self {
        case ._64(let header):
            numericCast(header.name_count)
        case ._32(let header):
            numericCast(header.name_count)
        }
    }

    public var abbreviationsTableSize: Int {
        switch self {
        case ._64(let header):
            numericCast(header.abbrev_table_size)
        case ._32(let header):
            numericCast(header.abbrev_table_size)
        }
    }

    public var augmentationStringSize: Int {
        switch self {
        case ._64(let header):
            numericCast(header.augmentation_string_size)
        case ._32(let header):
            numericCast(header.augmentation_string_size)
        }
    }
}

extension DWARFNameIndexHeader {
    public func augmentation(in machO: MachOFile) -> String {
        machO.fileHandle.readString(
            offset: numericCast(offset + layoutSize - augmentationStringSize),
            size: augmentationStringSize
        ) ?? ""
    }
}

extension DWARFNameIndexHeader {
    public static func load(at offset: Int, from machO: MachOFile) throws -> Self? {
        let offset = offset + machO.headerStartOffset
        let length: UInt32 = try machO.fileHandle.read(offset: offset)
        let is64Bit = length == 0xffffffff

        let version: UInt16 = try machO.fileHandle.read(
            offset: offset + (is64Bit ? MemoryLayout<dwarf_init_len64>.size : MemoryLayout<dwarf_init_len32>.size)
        )

        switch (is64Bit, version) {
        case (true, _):
            return ._64(
                .init(
                    layout: try machO.fileHandle.read(offset: offset),
                    offset: offset - machO.headerStartOffset
                )
            )
        case (false, _):
            return ._32(
                .init(
                    layout: try machO.fileHandle.read(offset: offset),
                    offset: offset - machO.headerStartOffset
                )
            )
        }
    }
}

public struct DWARFNameIndexHeader32: LayoutWrapper, Sendable {
    public typealias Layout = dwarf_name_index_header32_t

    public var layout: Layout

    public let offset: Int
}

extension DWARFNameIndexHeader32 {
    public var layoutSize: Int {
        MemoryLayout<Layout>.size + numericCast(layout.augmentation_string_size)
    }
}

public struct DWARFNameIndexHeader64: LayoutWrapper, Sendable {
    public typealias Layout = dwarf_name_index_header64_t

    public var layout: Layout

    public let offset: Int
}

extension DWARFNameIndexHeader64 {
    public var layoutSize: Int {
        MemoryLayout<Layout>.size + numericCast(layout.augmentation_string_size)
    }
}
