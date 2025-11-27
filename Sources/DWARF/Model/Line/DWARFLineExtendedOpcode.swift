//
//  DWARFLineExtendedOpcode.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/28
//  
//

import DWARFC

public enum DWARFLineExtendedOpcode: CaseIterable {
    /// DW_LNE_end_sequence
    case end_sequence
    /// DW_LNE_set_address
    case set_address
    /// DW_LNE_define_file
    case define_file
    /// DW_LNE_set_discriminator
    case set_discriminator
    /// DW_LNE_HP_negate_is_UV_update
    case hp_negate_is_uv_update
    /// DW_LNE_HP_push_context
    case hp_push_context
    /// DW_LNE_HP_pop_context
    case hp_pop_context
    /// DW_LNE_HP_set_file_line_column
    case hp_set_file_line_column
    /// DW_LNE_HP_set_routine_name
    case hp_set_routine_name
    /// DW_LNE_HP_set_sequence
    case hp_set_sequence
    /// DW_LNE_HP_negate_post_semantics
    case hp_negate_post_semantics
    /// DW_LNE_HP_negate_function_exit
    case hp_negate_function_exit
    /// DW_LNE_HP_negate_front_end_logical
    case hp_negate_front_end_logical
    /// DW_LNE_HP_define_proc
    case hp_define_proc
    /// DW_LNE_HP_source_file_correlation
    case hp_source_file_correlation
}

extension DWARFLineExtendedOpcode: RawRepresentable {
    public typealias RawValue = UInt64

    public init?(rawValue: RawValue) {
        switch rawValue {
        case numericCast(DW_LNE_end_sequence): self = .end_sequence
        case numericCast(DW_LNE_set_address): self = .set_address
        case numericCast(DW_LNE_define_file): self = .define_file
        case numericCast(DW_LNE_set_discriminator): self = .set_discriminator
        case numericCast(DW_LNE_HP_negate_is_UV_update): self = .hp_negate_is_uv_update
        case numericCast(DW_LNE_HP_push_context): self = .hp_push_context
        case numericCast(DW_LNE_HP_pop_context): self = .hp_pop_context
        case numericCast(DW_LNE_HP_set_file_line_column): self = .hp_set_file_line_column
        case numericCast(DW_LNE_HP_set_routine_name): self = .hp_set_routine_name
        case numericCast(DW_LNE_HP_set_sequence): self = .hp_set_sequence
        case numericCast(DW_LNE_HP_negate_post_semantics): self = .hp_negate_post_semantics
        case numericCast(DW_LNE_HP_negate_function_exit): self = .hp_negate_function_exit
        case numericCast(DW_LNE_HP_negate_front_end_logical): self = .hp_negate_front_end_logical
        case numericCast(DW_LNE_HP_define_proc): self = .hp_define_proc
        case numericCast(DW_LNE_HP_source_file_correlation): self = .hp_source_file_correlation
        default: return nil
        }
    }

    public var rawValue: RawValue {
        switch self {
        case .end_sequence: numericCast(DW_LNE_end_sequence)
        case .set_address: numericCast(DW_LNE_set_address)
        case .define_file: numericCast(DW_LNE_define_file)
        case .set_discriminator: numericCast(DW_LNE_set_discriminator)
        case .hp_negate_is_uv_update: numericCast(DW_LNE_HP_negate_is_UV_update)
        case .hp_push_context: numericCast(DW_LNE_HP_push_context)
        case .hp_pop_context: numericCast(DW_LNE_HP_pop_context)
        case .hp_set_file_line_column: numericCast(DW_LNE_HP_set_file_line_column)
        case .hp_set_routine_name: numericCast(DW_LNE_HP_set_routine_name)
        case .hp_set_sequence: numericCast(DW_LNE_HP_set_sequence)
        case .hp_negate_post_semantics: numericCast(DW_LNE_HP_negate_post_semantics)
        case .hp_negate_function_exit: numericCast(DW_LNE_HP_negate_function_exit)
        case .hp_negate_front_end_logical: numericCast(DW_LNE_HP_negate_front_end_logical)
        case .hp_define_proc: numericCast(DW_LNE_HP_define_proc)
        case .hp_source_file_correlation: numericCast(DW_LNE_HP_source_file_correlation)
        }
    }
}
extension DWARFLineExtendedOpcode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .end_sequence: "DW_LNE_end_sequence"
        case .set_address: "DW_LNE_set_address"
        case .define_file: "DW_LNE_define_file"
        case .set_discriminator: "DW_LNE_set_discriminator"
        case .hp_negate_is_uv_update: "DW_LNE_HP_negate_is_UV_update"
        case .hp_push_context: "DW_LNE_HP_push_context"
        case .hp_pop_context: "DW_LNE_HP_pop_context"
        case .hp_set_file_line_column: "DW_LNE_HP_set_file_line_column"
        case .hp_set_routine_name: "DW_LNE_HP_set_routine_name"
        case .hp_set_sequence: "DW_LNE_HP_set_sequence"
        case .hp_negate_post_semantics: "DW_LNE_HP_negate_post_semantics"
        case .hp_negate_function_exit: "DW_LNE_HP_negate_function_exit"
        case .hp_negate_front_end_logical: "DW_LNE_HP_negate_front_end_logical"
        case .hp_define_proc: "DW_LNE_HP_define_proc"
        case .hp_source_file_correlation: "DW_LNE_HP_source_file_correlation"
        }
    }
}
