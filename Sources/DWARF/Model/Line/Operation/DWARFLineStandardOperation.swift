//
//  DWARFLineStandardOperation.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/28
//
//

public enum DWARFLineStandardOperation: Sendable {
    /// DW_LNS_copy
    case copy
    /// DW_LNS_advance_pc
    case advance_pc(pcOffset: UInt64)
    /// DW_LNS_advance_line
    case advance_line(lineOffset: Int64)
    /// DW_LNS_set_file
    case set_file(file: UInt64)
    /// DW_LNS_set_column
    case set_column(column: UInt64)
    /// DW_LNS_negate_stmt
    case negate_stmt
    /// DW_LNS_set_basic_block
    case set_basic_block
    /// DW_LNS_const_add_pc
    case const_add_pc
    /// DW_LNS_fixed_advance_pc
    case fixed_advance_pc(pcOffset: UInt16)
    /// DW_LNS_set_prologue_end
    case set_prologue_end
    /// DW_LNS_set_epilogue_begin
    case set_epilogue_begin
    /// DW_LNS_set_isa
    case set_isa(isa: UInt64)
//    /// DW_LNS_set_address_from_logical
//    case set_address_from_logical
//    /// DW_LNS_set_subprogram
//    case set_subprogram
//    /// DW_LNS_inlined_call
//    case inlined_call
//    /// DW_LNS_pop_context
//    case pop_context
}

extension DWARFLineStandardOperation {
    public var opcode: DWARFLineStandardOpcode {
        switch self {
        case .copy: .copy
        case .advance_pc: .advance_pc
        case .advance_line: .advance_line
        case .set_file: .set_file
        case .set_column: .set_column
        case .negate_stmt: .negate_stmt
        case .set_basic_block: .set_basic_block
        case .const_add_pc: .const_add_pc
        case .fixed_advance_pc: .fixed_advance_pc
        case .set_prologue_end: .set_prologue_end
        case .set_epilogue_begin: .set_epilogue_begin
        case .set_isa: .set_isa
//        case .set_address_from_logical: .set_address_from_logical
//        case .set_subprogram: .set_subprogram
//        case .inlined_call: .inlined_call
//        case .pop_context: .pop_context
        }
    }
}

extension DWARFLineStandardOperation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .copy:
            return opcode.description

        case .advance_pc(let pcOffset):
            return "\(opcode.description)(pcOffset: \(pcOffset))"

        case .advance_line(let lineOffset):
            return "\(opcode.description)(lineOffset: \(lineOffset))"

        case .set_file(let file):
            return "\(opcode.description)(file: \(file))"

        case .set_column(let column):
            return "\(opcode.description)(column: \(column))"

        case .negate_stmt:
            return opcode.description

        case .set_basic_block:
            return opcode.description

        case .const_add_pc:
            return opcode.description

        case .fixed_advance_pc(let pcOffset):
            return "\(opcode.description)(pcOffset: \(pcOffset))"

        case .set_prologue_end:
            return opcode.description

        case .set_epilogue_begin:
            return opcode.description

        case .set_isa(let isa):
            return "\(opcode.description)(isa: \(isa))"
        }
    }
}

extension DWARFLineStandardOperation {
    internal static func readNext(
        basePointer: UnsafePointer<UInt8>,
        operaionsSize: Int,
        nextOffset: inout Int,
        done: inout Bool
    ) -> DWARFLineStandardOperation? {
        guard !done, nextOffset < operaionsSize else { return nil }

        let opcodeRaw = basePointer.advanced(by: nextOffset).pointee
        nextOffset += MemoryLayout<UInt8>.size

        guard let opcode = DWARFLineStandardOpcode(rawValue: opcodeRaw) else {
            return nil
        }

        switch opcode {
        case .copy:
            return .copy
        case .advance_pc:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            return .advance_pc(pcOffset: numericCast(operand))
        case .advance_line:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .advance_line(lineOffset: numericCast(operand))
        case .set_file:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            return .set_file(file: numericCast(operand))
        case .set_column:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            return .set_column(column: numericCast(operand))
        case .negate_stmt:
            return .negate_stmt
        case .set_basic_block:
            return .set_basic_block
        case .const_add_pc:
            return .const_add_pc
        case .fixed_advance_pc:
            let operand: UInt16 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: UInt16.self)
                .pointee
            nextOffset += MemoryLayout<UInt16>.size
            return .fixed_advance_pc(pcOffset: operand)
        case .set_prologue_end:
            return .set_prologue_end
        case .set_epilogue_begin:
            return .set_epilogue_begin
        case .set_isa:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            return .set_isa(isa: numericCast(operand))
        }
    }
}
