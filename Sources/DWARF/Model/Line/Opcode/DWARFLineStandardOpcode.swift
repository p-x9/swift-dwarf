//
//  DWARFLineOpcode.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/28
//  
//

import DWARFC

public enum DWARFLineStandardOpcode: Sendable, CaseIterable {
    /// DW_LNS_copy
    case copy
    /// DW_LNS_advance_pc
    case advance_pc
    /// DW_LNS_advance_line
    case advance_line
    /// DW_LNS_set_file
    case set_file
    /// DW_LNS_set_column
    case set_column
    /// DW_LNS_negate_stmt
    case negate_stmt
    /// DW_LNS_set_basic_block
    case set_basic_block
    /// DW_LNS_const_add_pc
    case const_add_pc
    /// DW_LNS_fixed_advance_pc
    case fixed_advance_pc
    /// DW_LNS_set_prologue_end
    case set_prologue_end
    /// DW_LNS_set_epilogue_begin
    case set_epilogue_begin
    /// DW_LNS_set_isa
    case set_isa
//    /// DW_LNS_set_address_from_logical
//    case set_address_from_logical
//    /// DW_LNS_set_subprogram
//    case set_subprogram
//    /// DW_LNS_inlined_call
//    case inlined_call
//    /// DW_LNS_pop_context
//    case pop_context
}

extension DWARFLineStandardOpcode: RawRepresentable {
    public typealias RawValue = UInt8

    public init?(rawValue: RawValue) {
        switch rawValue {
        case numericCast(DW_LNS_copy): self = .copy
        case numericCast(DW_LNS_advance_pc): self = .advance_pc
        case numericCast(DW_LNS_advance_line): self = .advance_line
        case numericCast(DW_LNS_set_file): self = .set_file
        case numericCast(DW_LNS_set_column): self = .set_column
        case numericCast(DW_LNS_negate_stmt): self = .negate_stmt
        case numericCast(DW_LNS_set_basic_block): self = .set_basic_block
        case numericCast(DW_LNS_const_add_pc): self = .const_add_pc
        case numericCast(DW_LNS_fixed_advance_pc): self = .fixed_advance_pc
        case numericCast(DW_LNS_set_prologue_end): self = .set_prologue_end
        case numericCast(DW_LNS_set_epilogue_begin): self = .set_epilogue_begin
        case numericCast(DW_LNS_set_isa): self = .set_isa
//        case numericCast(DW_LNS_set_address_from_logical): self = .set_address_from_logical
//        case numericCast(DW_LNS_set_subprogram): self = .set_subprogram
//        case numericCast(DW_LNS_inlined_call): self = .inlined_call
//        case numericCast(DW_LNS_pop_context): self = .pop_context
        default: return nil
        }
    }

    public var rawValue: RawValue {
        switch self {
        case .copy: numericCast(DW_LNS_copy)
        case .advance_pc: numericCast(DW_LNS_advance_pc)
        case .advance_line: numericCast(DW_LNS_advance_line)
        case .set_file: numericCast(DW_LNS_set_file)
        case .set_column: numericCast(DW_LNS_set_column)
        case .negate_stmt: numericCast(DW_LNS_negate_stmt)
        case .set_basic_block: numericCast(DW_LNS_set_basic_block)
        case .const_add_pc: numericCast(DW_LNS_const_add_pc)
        case .fixed_advance_pc: numericCast(DW_LNS_fixed_advance_pc)
        case .set_prologue_end: numericCast(DW_LNS_set_prologue_end)
        case .set_epilogue_begin: numericCast(DW_LNS_set_epilogue_begin)
        case .set_isa: numericCast(DW_LNS_set_isa)
//        case .set_address_from_logical: numericCast(DW_LNS_set_address_from_logical)
//        case .set_subprogram: numericCast(DW_LNS_set_subprogram)
//        case .inlined_call: numericCast(DW_LNS_inlined_call)
//        case .pop_context: numericCast(DW_LNS_pop_context)
        }
    }
}

extension DWARFLineStandardOpcode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .copy: "DW_LNS_copy"
        case .advance_pc: "DW_LNS_advance_pc"
        case .advance_line: "DW_LNS_advance_line"
        case .set_file: "DW_LNS_set_file"
        case .set_column: "DW_LNS_set_column"
        case .negate_stmt: "DW_LNS_negate_stmt"
        case .set_basic_block: "DW_LNS_set_basic_block"
        case .const_add_pc: "DW_LNS_const_add_pc"
        case .fixed_advance_pc: "DW_LNS_fixed_advance_pc"
        case .set_prologue_end: "DW_LNS_set_prologue_end"
        case .set_epilogue_begin: "DW_LNS_set_epilogue_begin"
        case .set_isa: "DW_LNS_set_isa"
//        case .set_address_from_logical: "DW_LNS_set_address_from_logical"
//        case .set_subprogram: "DW_LNS_set_subprogram"
//        case .inlined_call: "DW_LNS_inlined_call"
//        case .pop_context: "DW_LNS_pop_context"
        }
    }
}
