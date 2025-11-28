//
//  DWARFLineExtendedOperation.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/28
//  
//

public enum DWARFLineExtendedOperation {
    /// DW_LNE_end_sequence
    case end_sequence
    /// DW_LNE_set_address
    case set_address(address: UInt64)
    /// DW_LNE_define_file
    case define_file(DWARF4FileEntry)
    /// DW_LNE_set_discriminator
    case set_discriminator(discriminator: UInt64)
//    /// DW_LNE_HP_negate_is_UV_update
//    case hp_negate_is_uv_update
//    /// DW_LNE_HP_push_context
//    case hp_push_context
//    /// DW_LNE_HP_pop_context
//    case hp_pop_context
//    /// DW_LNE_HP_set_file_line_column
//    case hp_set_file_line_column
//    /// DW_LNE_HP_set_routine_name
//    case hp_set_routine_name
//    /// DW_LNE_HP_set_sequence
//    case hp_set_sequence
//    /// DW_LNE_HP_negate_post_semantics
//    case hp_negate_post_semantics
//    /// DW_LNE_HP_negate_function_exit
//    case hp_negate_function_exit
//    /// DW_LNE_HP_negate_front_end_logical
//    case hp_negate_front_end_logical
//    /// DW_LNE_HP_define_proc
//    case hp_define_proc
//    /// DW_LNE_HP_source_file_correlation
//    case hp_source_file_correlation
}

extension DWARFLineExtendedOperation {
    public var opcode: DWARFLineExtendedOpcode {
        switch self {
        case .end_sequence: .end_sequence
        case .set_address: .set_address
        case .define_file: .define_file
        case .set_discriminator: .set_discriminator
//        case .hp_negate_is_uv_update: .hp_negate_is_uv_update
//        case .hp_push_context: .hp_push_context
//        case .hp_pop_context: .hp_pop_context
//        case .hp_set_file_line_column: .hp_set_file_line_column
//        case .hp_set_routine_name: .hp_set_routine_name
//        case .hp_set_sequence: .hp_set_sequence
//        case .hp_negate_post_semantics: .hp_negate_post_semantics
//        case .hp_negate_function_exit: .hp_negate_function_exit
//        case .hp_negate_front_end_logical: .hp_negate_front_end_logical
//        case .hp_define_proc: .hp_define_proc
//        case .hp_source_file_correlation: .hp_source_file_correlation
        }
    }
}

extension DWARFLineExtendedOperation {
    internal static func readNext(
        basePointer: UnsafePointer<UInt8>,
        operaionsSize: Int,
        addressSize: Int,
        nextOffset: inout Int,
        done: inout Bool
    ) -> DWARFLineExtendedOperation? {
        guard !done, nextOffset < operaionsSize else { return nil }

        let prefix = basePointer.advanced(by: nextOffset).pointee
        nextOffset += MemoryLayout<UInt8>.size

        guard prefix == 0x00 else {
            return nil
        }

        let (length, size) = basePointer
            .advanced(by: nextOffset)
            .readULEB128()
        nextOffset += size

        let actualResultOfNextOffset = nextOffset + numericCast(length)

        defer {
            nextOffset = actualResultOfNextOffset
        }

        let opcodeRaw = basePointer.advanced(by: nextOffset).pointee
        nextOffset += MemoryLayout<UInt8>.size

        guard let opcode = DWARFLineExtendedOpcode(rawValue: opcodeRaw) else {
            return nil
        }

        switch opcode {
        case .end_sequence:
            return .end_sequence

        case .set_address:
            if addressSize == 4 {
                let operand: UInt32 = UnsafeRawPointer(basePointer)
                    .advanced(by: nextOffset)
                    .assumingMemoryBound(to: UInt32.self)
                    .pointee
                nextOffset += MemoryLayout<UInt32>.size
                return .set_address(address: numericCast(operand))
            } else {
                let operand: UInt64 = UnsafeRawPointer(basePointer)
                    .advanced(by: nextOffset)
                    .assumingMemoryBound(to: UInt64.self)
                    .pointee
                nextOffset += MemoryLayout<UInt64>.size
                return .set_address(address: operand)
            }

        case .define_file:
            let (path, size) = basePointer
                .advanced(by: nextOffset)
                .readString()
            nextOffset += size

            let (dir_index, size2) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size2

            let (modification_time, size3) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size3

            let (file_size, size4) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size4

            return .define_file(
                .init(
                    name: path,
                    dir_index: numericCast(dir_index),
                    modification_time: numericCast(modification_time),
                    file_size: numericCast(file_size)
                )
            )

        case .set_discriminator:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            return .set_discriminator(discriminator: numericCast(operand))
        }
    }
}
