//
//  DWARFNameIndexAttribute.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/21
//  
//

import Foundation
import DWARFC

public enum DWARFNameIndexAttribute: CaseIterable {
    /// DW_IDX_compile_unit
    case compile_unit
    /// DW_IDX_type_unit
    case type_unit
    /// DW_IDX_die_offset
    case die_offset
    /// DW_IDX_parent
    case parent
    /// DW_IDX_type_hash
    case type_hash
    /// DW_IDX_GNU_internal
    case gnu_internal
    /// DW_IDX_GNU_external
    case gnu_external
    /// DW_IDX_GNU_main
    case gnu_main
    /// DW_IDX_GNU_language
    case gnu_language
    /// DW_IDX_GNU_linkage_name
    case gnu_linkage_name
}

extension DWARFNameIndexAttribute: RawRepresentable {
    public typealias RawValue = UInt64

    public init?(rawValue: RawValue) {
        switch rawValue {
        case numericCast(DW_IDX_compile_unit): self = .compile_unit
        case numericCast(DW_IDX_type_unit): self = .type_unit
        case numericCast(DW_IDX_die_offset): self = .die_offset
        case numericCast(DW_IDX_parent): self = .parent
        case numericCast(DW_IDX_type_hash): self = .type_hash
        case numericCast(DW_IDX_GNU_internal): self = .gnu_internal
        case numericCast(DW_IDX_GNU_external): self = .gnu_external
        case numericCast(DW_IDX_GNU_main): self = .gnu_main
        case numericCast(DW_IDX_GNU_language): self = .gnu_language
        case numericCast(DW_IDX_GNU_linkage_name): self = .gnu_linkage_name
        default: return nil
        }
    }

    public var rawValue: RawValue {
        switch self {
        case .compile_unit: numericCast(DW_IDX_compile_unit)
        case .type_unit: numericCast(DW_IDX_type_unit)
        case .die_offset: numericCast(DW_IDX_die_offset)
        case .parent: numericCast(DW_IDX_parent)
        case .type_hash: numericCast(DW_IDX_type_hash)
        case .gnu_internal: numericCast(DW_IDX_GNU_internal)
        case .gnu_external: numericCast(DW_IDX_GNU_external)
        case .gnu_main: numericCast(DW_IDX_GNU_main)
        case .gnu_language: numericCast(DW_IDX_GNU_language)
        case .gnu_linkage_name: numericCast(DW_IDX_GNU_linkage_name)
        }
    }
}

extension DWARFNameIndexAttribute: CustomStringConvertible {
    public var description: String {
        switch self {
        case .compile_unit: "DW_IDX_compile_unit"
        case .type_unit: "DW_IDX_type_unit"
        case .die_offset: "DW_IDX_die_offset"
        case .parent: "DW_IDX_parent"
        case .type_hash: "DW_IDX_type_hash"
        case .gnu_internal: "DW_IDX_GNU_internal"
        case .gnu_external: "DW_IDX_GNU_external"
        case .gnu_main: "DW_IDX_GNU_main"
        case .gnu_language: "DW_IDX_GNU_language"
        case .gnu_linkage_name: "DW_IDX_GNU_linkage_name"
        }
    }
}
