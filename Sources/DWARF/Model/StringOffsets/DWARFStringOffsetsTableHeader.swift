//
//  DWARFStringOffsetsTableHeader.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/10
//  
//

import Foundation

public enum DWARFStringOffsetsTableHeader: Sendable {
    case version5(DWARF5StringOffsetsTableHeader64)
    case version5_32(DWARF5StringOffsetsTableHeader32)
}

extension DWARFStringOffsetsTableHeader {
    public var layoutSize: Int {
        switch self {
        case .version5(let header):
            numericCast(header.layoutSize)
        case .version5_32(let header):
            numericCast(header.layoutSize)
        }
    }

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
}

public struct DWARF5StringOffsetsTableHeader64: LayoutWrapper, Sendable {
    public typealias Layout = dwarf5_str_offsets_header64_t

    public var layout: Layout
}

public struct DWARF5StringOffsetsTableHeader32: LayoutWrapper, Sendable {
    public typealias Layout = dwarf5_str_offsets_header32_t

    public var layout: Layout
}
