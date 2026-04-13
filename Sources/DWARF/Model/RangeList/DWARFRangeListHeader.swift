//
//  DWARFRangeListHeader.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/30
//  
//

import Foundation
import DWARFC

public enum DWARFRangeListHeader: Sendable {
    case version5(DWARF5RangeListHeader64)
    case version5_32(DWARF5RangeListHeader32)
}

extension DWARFRangeListHeader {
    public var offset: Int {
        switch self {
        case .version5(let header):
            header.offset
        case .version5_32(let header):
            header.offset
        }
    }
}

extension DWARFRangeListHeader {
    public var layoutSize: Int {
        switch self {
        case .version5(let header):
            header.layoutSize
        case .version5_32(let header):
            header.layoutSize
        }
    }
}

extension DWARFRangeListHeader {
    public var format: DWARFFormat {
        switch self {
        case .version5:
                ._64bit
        case .version5_32:
                ._32bit
        }
    }

    // size of `unit_length` field is not contained in `length`
    public var length: Int {
        switch self {
        case .version5(let header):
            numericCast(header.unit_length.value)
        case .version5_32(let header):
            numericCast(header.unit_length.value)
        }
    }

    public var version: DWARFVersion {
        switch self {
        case .version5(let header):
                .init(rawValue: numericCast(header.version))!
        case .version5_32(let header):
                .init(rawValue: numericCast(header.version))!
        }
    }

    public var addressSize: Int {
        switch self {
        case .version5(let header):
            numericCast(header.address_size)
        case .version5_32(let header):
            numericCast(header.address_size)
        }
    }
}

extension DWARFRangeListHeader {
    public var segmentSelectorSize: Int {
        switch self {
        case .version5(let header):
            numericCast(header.segment_selector_size)
        case .version5_32(let header):
            numericCast(header.segment_selector_size)
        }
    }

    public var offsetEntryCount: Int {
        switch self {
        case .version5(let header):
            numericCast(header.offset_entry_count)
        case .version5_32(let header):
            numericCast(header.offset_entry_count)
        }
    }
}

extension DWARFRangeListHeader {
    package static func _load(
        at offset: Int,
        in binary: some _DWARFBinary
    ) throws -> Self? {
        let offset = offset + binary.headerStartOffset
        let length: UInt32 = try binary.fileHandle.read(offset: offset)
        let is64Bit = length == 0xffffffff

        let version: UInt16 = try binary.fileHandle.read(
            offset: offset + (is64Bit ? MemoryLayout<dwarf_init_len64>.size : MemoryLayout<dwarf_init_len32>.size)
        )

        switch (is64Bit, version) {
        case (true, 5):
            return .version5(
                .init(
                    layout: try binary.fileHandle.read(offset: offset),
                    offset: offset - binary.headerStartOffset
                )
            )
        case (false, 5):
            return .version5_32(
                .init(
                    layout: try binary.fileHandle.read(offset: offset),
                    offset: offset - binary.headerStartOffset
                )
            )
        default: return nil
        }
    }
}

public struct DWARF5RangeListHeader32: LayoutWrapper, Sendable {
    public typealias Layout = dwarf5_rnglist_header32_t

    public var layout: Layout

    public let offset: Int
}

public struct DWARF5RangeListHeader64: LayoutWrapper, Sendable {
    public typealias Layout = dwarf5_rnglist_header64_t

    public var layout: Layout

    public let offset: Int
}
