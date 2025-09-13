//
//  DWARFCompilationHeader.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/21
//  
//

import Foundation
@testable @_spi(Support) import MachOKit
import DWARFC

public enum DWARFCompilationUnitHeader {
    case upToVersion4(DWARF4CompilationUnitHeader64)
    case version5(DWARF5CompilationUnitHeader64)

    case upToVersion4_32(DWARF4CompilationUnitHeader32)
    case version5_32(DWARF5CompilationUnitHeader32)
}

extension DWARFCompilationUnitHeader {
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

    public var actualLayoutSize: Int {
        switch self {
        case .upToVersion4(let header):
            header.layoutSize
        case .version5(let header):
            header.actualLayoutSize
        case .upToVersion4_32(let header):
            header.layoutSize
        case .version5_32(let header):
            header.actualLayoutSize
        }
    }

    public var unitLayoutSize: Int {
        length + (format == ._64bit ? 12 : 4)
    }
}

extension DWARFCompilationUnitHeader {
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
            numericCast(header.address_size)
        case .version5(let header):
            numericCast(header.address_size)
        case .upToVersion4_32(let header):
            numericCast(header.address_size)
        case .version5_32(let header):
            numericCast(header.address_size)
        }
    }

    public var debugAbbrevOffset: Int {
        switch self {
        case .upToVersion4(let header):
            numericCast(header.debug_abbrev_offset)
        case .version5(let header):
            numericCast(header.debug_abbrev_offset)
        case .upToVersion4_32(let header):
            numericCast(header.debug_abbrev_offset)
        case .version5_32(let header):
            numericCast(header.debug_abbrev_offset)
        }
    }
}

extension DWARFCompilationUnitHeader {
    public static func load(at offset: Int, in machO: MachOFile) throws -> Self? {
        let offset = offset + machO.headerStartOffset
        let length: UInt32 = try machO.fileHandle.read(offset: offset)
        let is64Bit = length == 0xffffffff

        let version: UInt16 = try machO.fileHandle.read(
            offset: offset + (is64Bit ? MemoryLayout<dwarf_init_len64>.size : MemoryLayout<dwarf_init_len32>.size)
        )

        switch (is64Bit, version) {
        case (true, _) where version <= 4:
            return .upToVersion4(
                .init(
                    layout: try machO.fileHandle.read(offset: offset),
                    offset: offset - machO.headerStartOffset
                )
            )
        case (false, _) where version <= 4:
            return .upToVersion4_32(
                .init(
                    layout: try machO.fileHandle.read(offset: offset),
                    offset: offset - machO.headerStartOffset
                )
            )
        case (true, 5):
            return .version5(
                .init(
                    layout: try machO.fileHandle.read(offset: offset),
                    offset: offset - machO.headerStartOffset
                )
            )
        case (false, 5):
            return .version5_32(
                .init(
                    layout: try machO.fileHandle.read(offset: offset),
                    offset: offset - machO.headerStartOffset
                )
            )
        default: return nil
        }
    }
}

public struct DWARF5CompilationUnitHeader64: LayoutWrapper {
    public typealias Layout = dwarf5_cu_header64_t

    public var layout: Layout
    public let offset: Int
}

public struct DWARF5CompilationUnitHeader32: LayoutWrapper {
    public typealias Layout = dwarf5_cu_header32_t

    public var layout: Layout
    public let offset: Int
}

public struct DWARF4CompilationUnitHeader64: LayoutWrapper {
    public typealias Layout = dwarf4_cu_header64_t

    public var layout: Layout
    public let offset: Int
}

public struct DWARF4CompilationUnitHeader32: LayoutWrapper {
    public typealias Layout = dwarf4_cu_header32_t

    public var layout: Layout
    public let offset: Int
}

extension DWARF5CompilationUnitHeader32 {
    public var unitType: DWARFUnitType {
        .init(rawValue: layout.unit_type)!
    }

    public var actualLayoutSize: Int {
        // `dwo_id` is present only in the skeleton compilation unit.
        layoutSize - (unitType == .skeleton ? 0 : 1)
    }
}

extension DWARF5CompilationUnitHeader64 {
    public var unitType: DWARFUnitType {
        .init(rawValue: layout.unit_type)!
    }

    public var actualLayoutSize: Int {
        // `dwo_id` is present only in the skeleton compilation unit.
        layoutSize - (unitType == .skeleton ? 0 : 1)
    }
}
