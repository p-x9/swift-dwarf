//
//  DWARFCompilationHeader.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/21
//  
//

import Foundation
import DWARFC

public enum DWARFCompilationUnitHeader: Sendable {
    case upToVersion4(DWARF4CompilationUnitHeader64)
    case version5(DWARF5CompilationUnitHeader64)
    case version5Split(DWARF5SplitCompilationUnitHeader64)
    case version5Type(DWARF5TypeUnitHeader64)

    case upToVersion4_32(DWARF4CompilationUnitHeader32)
    case version5_32(DWARF5CompilationUnitHeader32)
    case version5Split_32(DWARF5SplitCompilationUnitHeader32)
    case version5Type_32(DWARF5TypeUnitHeader32)
}

extension DWARFCompilationUnitHeader {
    public var offset: Int {
        switch self {
        case .upToVersion4(let header):
            header.offset
        case .version5(let header):
            header.offset
        case .version5Split(let header):
            header.offset
        case .version5Type(let header):
            header.offset
        case .upToVersion4_32(let header):
            header.offset
        case .version5_32(let header):
            header.offset
        case .version5Split_32(let header):
            header.offset
        case .version5Type_32(let header):
            header.offset
        }
    }

    public var actualLayoutSize: Int {
        switch self {
        case .upToVersion4(let header):
            header.layoutSize
        case .version5(let header):
            header.layoutSize
        case .version5Split(let header):
            header.layoutSize
        case .version5Type(let header):
            header.layoutSize
        case .upToVersion4_32(let header):
            header.layoutSize
        case .version5_32(let header):
            header.layoutSize
        case .version5Split_32(let header):
            header.layoutSize
        case .version5Type_32(let header):
            header.layoutSize
        }
    }
}

extension DWARFCompilationUnitHeader {
    public var format: DWARFFormat {
        switch self {
        case .upToVersion4, .version5, .version5Split, .version5Type:
                ._64bit
        case .upToVersion4_32, .version5_32, .version5Split_32, .version5Type_32:
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
        case .version5Split(let header):
            numericCast(header.unit_length.value)
        case .version5Type(let header):
            numericCast(header.unit_length.value)
        case .upToVersion4_32(let header):
            numericCast(header.unit_length.value)
        case .version5_32(let header):
            numericCast(header.unit_length.value)
        case .version5Split_32(let header):
            numericCast(header.unit_length.value)
        case .version5Type_32(let header):
            numericCast(header.unit_length.value)
        }
    }

    public var version: DWARFVersion {
        switch self {
        case .upToVersion4(let header):
                .init(rawValue: numericCast(header.version))!
        case .version5(let header):
                .init(rawValue: numericCast(header.version))!
        case .version5Split(let header):
                .init(rawValue: numericCast(header.version))!
        case .version5Type(let header):
                .init(rawValue: numericCast(header.version))!
        case .upToVersion4_32(let header):
                .init(rawValue: numericCast(header.version))!
        case .version5_32(let header):
                .init(rawValue: numericCast(header.version))!
        case .version5Split_32(let header):
                .init(rawValue: numericCast(header.version))!
        case .version5Type_32(let header):
                .init(rawValue: numericCast(header.version))!
        }
    }

    public var addressSize: Int {
        switch self {
        case .upToVersion4(let header):
            numericCast(header.address_size)
        case .version5(let header):
            numericCast(header.address_size)
        case .version5Split(let header):
            numericCast(header.address_size)
        case .version5Type(let header):
            numericCast(header.address_size)
        case .upToVersion4_32(let header):
            numericCast(header.address_size)
        case .version5_32(let header):
            numericCast(header.address_size)
        case .version5Split_32(let header):
            numericCast(header.address_size)
        case .version5Type_32(let header):
            numericCast(header.address_size)
        }
    }

    public var debugAbbrevOffset: Int {
        switch self {
        case .upToVersion4(let header):
            numericCast(header.debug_abbrev_offset)
        case .version5(let header):
            numericCast(header.debug_abbrev_offset)
        case .version5Split(let header):
            numericCast(header.debug_abbrev_offset)
        case .version5Type(let header):
            numericCast(header.debug_abbrev_offset)
        case .upToVersion4_32(let header):
            numericCast(header.debug_abbrev_offset)
        case .version5_32(let header):
            numericCast(header.debug_abbrev_offset)
        case .version5Split_32(let header):
            numericCast(header.debug_abbrev_offset)
        case .version5Type_32(let header):
            numericCast(header.debug_abbrev_offset)
        }
    }
}

extension DWARFCompilationUnitHeader {
    public var unitType: DWARFUnitType? {
        switch self {
        case .upToVersion4, .upToVersion4_32:
            nil
        case .version5(let header):
            header.unitType
        case .version5Split(let header):
            header.unitType
        case .version5Type(let header):
            header.unitType
        case .version5_32(let header):
            header.unitType
        case .version5Split_32(let header):
            header.unitType
        case .version5Type_32(let header):
            header.unitType
        }
    }

    public var dwoID: UInt64? {
        switch self {
        case .version5Split(let header):
            header.dwo_id
        case .version5Split_32(let header):
            header.dwo_id
        default:
            nil
        }
    }

    public var typeSignature: UInt64? {
        switch self {
        case .version5Type(let header):
            header.type_signature
        case .version5Type_32(let header):
            header.type_signature
        default:
            nil
        }
    }

    public var typeOffset: UInt64? {
        switch self {
        case .version5Type(let header):
            header.type_offset
        case .version5Type_32(let header):
            numericCast(header.type_offset)
        default:
            nil
        }
    }
}

extension DWARFCompilationUnitHeader {
    package static func _load(
        at offset: Int,
        from binary: some _DWARFBinary
    ) throws -> Self? {
        let offset = offset + binary.headerStartOffset
        let length: UInt32 = try binary.fileHandle.read(offset: offset)
        let is64Bit = length == 0xffffffff

        let version: UInt16 = try binary.fileHandle.read(
            offset: offset + (is64Bit ? MemoryLayout<dwarf_init_len64>.size : MemoryLayout<dwarf_init_len32>.size)
        )

        switch (is64Bit, version) {
        case (true, _) where version <= 4:
            return .upToVersion4(
                .init(
                    layout: try binary.fileHandle.read(offset: offset),
                    offset: offset - binary.headerStartOffset
                )
            )
        case (false, _) where version <= 4:
            return .upToVersion4_32(
                .init(
                    layout: try binary.fileHandle.read(offset: offset),
                    offset: offset - binary.headerStartOffset
                )
            )
        case (true, 5), (false, 5):
            let unitTypeOffset = offset
                + (is64Bit ? MemoryLayout<dwarf_init_len64>.size : MemoryLayout<dwarf_init_len32>.size)
                + MemoryLayout<UInt16>.size
            let unitTypeRaw: UInt8 = try binary.fileHandle.read(offset: unitTypeOffset)
            guard let unitType = DWARFUnitType(rawValue: unitTypeRaw) else {
                return nil
            }

            switch (is64Bit, unitType) {
            case (true, .compile), (true, .partial):
                return .version5(
                    .init(
                        layout: try binary.fileHandle.read(offset: offset),
                        offset: offset - binary.headerStartOffset
                    )
                )
            case (false, .compile), (false, .partial):
                return .version5_32(
                    .init(
                        layout: try binary.fileHandle.read(offset: offset),
                        offset: offset - binary.headerStartOffset
                    )
                )
            case (true, .skeleton), (true, .split_compile):
                return .version5Split(
                    .init(
                        layout: try binary.fileHandle.read(offset: offset),
                        offset: offset - binary.headerStartOffset
                    )
                )
            case (false, .skeleton), (false, .split_compile):
                return .version5Split_32(
                    .init(
                        layout: try binary.fileHandle.read(offset: offset),
                        offset: offset - binary.headerStartOffset
                    )
                )
            case (true, .type), (true, .split_type):
                return .version5Type(
                    .init(
                        layout: try binary.fileHandle.read(offset: offset),
                        offset: offset - binary.headerStartOffset
                    )
                )
            case (false, .type), (false, .split_type):
                return .version5Type_32(
                    .init(
                        layout: try binary.fileHandle.read(offset: offset),
                        offset: offset - binary.headerStartOffset
                    )
                )
            }
        default: return nil
        }
    }
}

public struct DWARF5CompilationUnitHeader64: LayoutWrapper, Sendable {
    public typealias Layout = dwarf5_cu_header64_t

    public var layout: Layout
    public let offset: Int
}

public struct DWARF5CompilationUnitHeader32: LayoutWrapper, Sendable {
    public typealias Layout = dwarf5_cu_header32_t

    public var layout: Layout
    public let offset: Int
}

public struct DWARF5SplitCompilationUnitHeader64: LayoutWrapper, Sendable {
    public typealias Layout = dwarf5_split_cu_header64_t

    public var layout: Layout
    public let offset: Int
}

public struct DWARF5SplitCompilationUnitHeader32: LayoutWrapper, Sendable {
    public typealias Layout = dwarf5_split_cu_header32_t

    public var layout: Layout
    public let offset: Int
}

public struct DWARF5TypeUnitHeader64: LayoutWrapper, Sendable {
    public typealias Layout = dwarf5_tu_header64_t

    public var layout: Layout
    public let offset: Int
}

public struct DWARF5TypeUnitHeader32: LayoutWrapper, Sendable {
    public typealias Layout = dwarf5_tu_header32_t

    public var layout: Layout
    public let offset: Int
}

public struct DWARF4CompilationUnitHeader64: LayoutWrapper, Sendable {
    public typealias Layout = dwarf4_cu_header64_t

    public var layout: Layout
    public let offset: Int
}

public struct DWARF4CompilationUnitHeader32: LayoutWrapper, Sendable {
    public typealias Layout = dwarf4_cu_header32_t

    public var layout: Layout
    public let offset: Int
}

extension DWARF5CompilationUnitHeader32 {
    public var unitType: DWARFUnitType {
        .init(rawValue: layout.unit_type)!
    }
}

extension DWARF5CompilationUnitHeader64 {
    public var unitType: DWARFUnitType {
        .init(rawValue: layout.unit_type)!
    }
}

extension DWARF5SplitCompilationUnitHeader32 {
    public var unitType: DWARFUnitType {
        .init(rawValue: layout.unit_type)!
    }
}

extension DWARF5SplitCompilationUnitHeader64 {
    public var unitType: DWARFUnitType {
        .init(rawValue: layout.unit_type)!
    }
}

extension DWARF5TypeUnitHeader32 {
    public var unitType: DWARFUnitType {
        .init(rawValue: layout.unit_type)!
    }
}

extension DWARF5TypeUnitHeader64 {
    public var unitType: DWARFUnitType {
        .init(rawValue: layout.unit_type)!
    }
}
