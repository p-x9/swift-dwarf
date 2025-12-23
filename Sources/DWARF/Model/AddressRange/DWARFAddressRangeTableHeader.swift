//
//  DWARFAddressRangeTableHeader.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/01
//  
//

import Foundation
@_spi(Support) import MachOKit
import DWARFC

public enum DWARFAddressRangeTableHeader: Sendable {
    case _64(DWARFAddressRangeTableHeader64)
    case _32(DWARFAddressRangeTableHeader32)
}

extension DWARFAddressRangeTableHeader {
    public var offset: Int {
        switch self {
        case ._64(let header):
            header.offset
        case ._32(let header):
            header.offset
        }
    }
}

extension DWARFAddressRangeTableHeader {
    public var layoutSize: Int {
        switch self {
        case ._64(let header):
            header.layoutSize
        case ._32(let header):
            header.layoutSize
        }
    }
}

extension DWARFAddressRangeTableHeader {
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

    public var addressSize: Int {
        switch self {
        case ._64(let header):
            numericCast(header.address_size)
        case ._32(let header):
            numericCast(header.address_size)
        }
    }
}

extension DWARFAddressRangeTableHeader {
    public var debugInfoOffset: Int {
        switch self {
        case ._64(let header):
            numericCast(header.debug_info_offset)
        case ._32(let header):
            numericCast(header.debug_info_offset)
        }
    }

    public var segmentSelectorSize: Int {
        switch self {
        case ._64(let header):
            numericCast(header.segment_selector_size)
        case ._32(let header):
            numericCast(header.segment_selector_size)
        }
    }
}

extension DWARFAddressRangeTableHeader {
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

public struct DWARFAddressRangeTableHeader32: LayoutWrapper, Sendable {
    public typealias Layout = dwarf_aranges_header32_t

    public var layout: Layout

    public let offset: Int
}

public struct DWARFAddressRangeTableHeader64: LayoutWrapper, Sendable {
    public typealias Layout = dwarf_aranges_header64_t

    public var layout: Layout

    public let offset: Int
}
