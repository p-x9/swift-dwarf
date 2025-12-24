//
//  DWARFOperation.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/04/05
//
//

import Foundation
import DWARFC

public enum DWARFOperation: Sendable, Equatable {
    /// DW_OP_addr
    case addr(UInt64) // machine address size
    /// DW_OP_deref
    case deref
    /// DW_OP_const1u
    case const1u(UInt8)
    /// DW_OP_const1s
    case const1s(Int8)
    /// DW_OP_const2u
    case const2u(UInt16)
    /// DW_OP_const2s
    case const2s(Int16)
    /// DW_OP_const4u
    case const4u(UInt32)
    /// DW_OP_const4s
    case const4s(Int32)
    /// DW_OP_const8u
    case const8u(UInt64)
    /// DW_OP_const8s
    case const8s(Int64)
    /// DW_OP_constu
    case constu(UInt64) // uleb128
    /// DW_OP_consts
    case consts(Int64) // sleb128
    /// DW_OP_dup
    case dup
    /// DW_OP_drop
    case drop
    /// DW_OP_over
    case over
    /// DW_OP_pick
    case pick(index: UInt8)
    /// DW_OP_swap
    case swap
    /// DW_OP_rot
    case rot
    /// DW_OP_xderef
    case xderef
    /// DW_OP_abs
    case abs
    /// DW_OP_and
    case and
    /// DW_OP_div
    case div
    /// DW_OP_minus
    case minus
    /// DW_OP_mod
    case mod
    /// DW_OP_mul
    case mul
    /// DW_OP_neg
    case neg
    /// DW_OP_not
    case not
    /// DW_OP_or
    case or
    /// DW_OP_plus
    case plus
    /// DW_OP_plus_uconst
    case plus_uconst(UInt64) // uleb128
    /// DW_OP_shl
    case shl
    /// DW_OP_shr
    case shr
    /// DW_OP_shra
    case shra
    /// DW_OP_xor
    case xor
    /// DW_OP_bra
    case bra(Int16)
    /// DW_OP_eq
    case eq
    /// DW_OP_ge
    case ge
    /// DW_OP_gt
    case gt
    /// DW_OP_le
    case le
    /// DW_OP_lt
    case lt
    /// DW_OP_ne
    case ne
    /// DW_OP_skip
    case skip(Int16)
    /// DW_OP_lit0
    case lit0
    /// DW_OP_lit1
    case lit1
    /// DW_OP_lit2
    case lit2
    /// DW_OP_lit3
    case lit3
    /// DW_OP_lit4
    case lit4
    /// DW_OP_lit5
    case lit5
    /// DW_OP_lit6
    case lit6
    /// DW_OP_lit7
    case lit7
    /// DW_OP_lit8
    case lit8
    /// DW_OP_lit9
    case lit9
    /// DW_OP_lit10
    case lit10
    /// DW_OP_lit11
    case lit11
    /// DW_OP_lit12
    case lit12
    /// DW_OP_lit13
    case lit13
    /// DW_OP_lit14
    case lit14
    /// DW_OP_lit15
    case lit15
    /// DW_OP_lit16
    case lit16
    /// DW_OP_lit17
    case lit17
    /// DW_OP_lit18
    case lit18
    /// DW_OP_lit19
    case lit19
    /// DW_OP_lit20
    case lit20
    /// DW_OP_lit21
    case lit21
    /// DW_OP_lit22
    case lit22
    /// DW_OP_lit23
    case lit23
    /// DW_OP_lit24
    case lit24
    /// DW_OP_lit25
    case lit25
    /// DW_OP_lit26
    case lit26
    /// DW_OP_lit27
    case lit27
    /// DW_OP_lit28
    case lit28
    /// DW_OP_lit29
    case lit29
    /// DW_OP_lit30
    case lit30
    /// DW_OP_lit31
    case lit31
    /// DW_OP_reg0
    case reg0
    /// DW_OP_reg1
    case reg1
    /// DW_OP_reg2
    case reg2
    /// DW_OP_reg3
    case reg3
    /// DW_OP_reg4
    case reg4
    /// DW_OP_reg5
    case reg5
    /// DW_OP_reg6
    case reg6
    /// DW_OP_reg7
    case reg7
    /// DW_OP_reg8
    case reg8
    /// DW_OP_reg9
    case reg9
    /// DW_OP_reg10
    case reg10
    /// DW_OP_reg11
    case reg11
    /// DW_OP_reg12
    case reg12
    /// DW_OP_reg13
    case reg13
    /// DW_OP_reg14
    case reg14
    /// DW_OP_reg15
    case reg15
    /// DW_OP_reg16
    case reg16
    /// DW_OP_reg17
    case reg17
    /// DW_OP_reg18
    case reg18
    /// DW_OP_reg19
    case reg19
    /// DW_OP_reg20
    case reg20
    /// DW_OP_reg21
    case reg21
    /// DW_OP_reg22
    case reg22
    /// DW_OP_reg23
    case reg23
    /// DW_OP_reg24
    case reg24
    /// DW_OP_reg25
    case reg25
    /// DW_OP_reg26
    case reg26
    /// DW_OP_reg27
    case reg27
    /// DW_OP_reg28
    case reg28
    /// DW_OP_reg29
    case reg29
    /// DW_OP_reg30
    case reg30
    /// DW_OP_reg31
    case reg31
    /// DW_OP_breg0
    case breg0(Int64) // sleb128
    /// DW_OP_breg1
    case breg1(Int64) // sleb128
    /// DW_OP_breg2
    case breg2(Int64) // sleb128
    /// DW_OP_breg3
    case breg3(Int64) // sleb128
    /// DW_OP_breg4
    case breg4(Int64) // sleb128
    /// DW_OP_breg5
    case breg5(Int64) // sleb128
    /// DW_OP_breg6
    case breg6(Int64) // sleb128
    /// DW_OP_breg7
    case breg7(Int64) // sleb128
    /// DW_OP_breg8
    case breg8(Int64) // sleb128
    /// DW_OP_breg9
    case breg9(Int64) // sleb128
    /// DW_OP_breg10
    case breg10(Int64) // sleb128
    /// DW_OP_breg11
    case breg11(Int64) // sleb128
    /// DW_OP_breg12
    case breg12(Int64) // sleb128
    /// DW_OP_breg13
    case breg13(Int64) // sleb128
    /// DW_OP_breg14
    case breg14(Int64) // sleb128
    /// DW_OP_breg15
    case breg15(Int64) // sleb128
    /// DW_OP_breg16
    case breg16(Int64) // sleb128
    /// DW_OP_breg17
    case breg17(Int64) // sleb128
    /// DW_OP_breg18
    case breg18(Int64) // sleb128
    /// DW_OP_breg19
    case breg19(Int64) // sleb128
    /// DW_OP_breg20
    case breg20(Int64) // sleb128
    /// DW_OP_breg21
    case breg21(Int64) // sleb128
    /// DW_OP_breg22
    case breg22(Int64) // sleb128
    /// DW_OP_breg23
    case breg23(Int64) // sleb128
    /// DW_OP_breg24
    case breg24(Int64) // sleb128
    /// DW_OP_breg25
    case breg25(Int64) // sleb128
    /// DW_OP_breg26
    case breg26(Int64) // sleb128
    /// DW_OP_breg27
    case breg27(Int64) // sleb128
    /// DW_OP_breg28
    case breg28(Int64) // sleb128
    /// DW_OP_breg29
    case breg29(Int64) // sleb128
    /// DW_OP_breg30
    case breg30(Int64) // sleb128
    /// DW_OP_breg31
    case breg31(Int64) // sleb128
    /// DW_OP_regx
    case regx(register: UInt64) // uleb128
    /// DW_OP_fbreg
    case fbreg(Int64) // sleb128
    /// DW_OP_bregx
    case bregx(register: UInt64, offset: Int64) // uleb128 / sleb128
    /// DW_OP_piece
    case piece(UInt64) // uleb128
    /// DW_OP_deref_size
    case deref_size(UInt8)
    /// DW_OP_xderef_size
    case xderef_size(UInt8)
    /// DW_OP_nop
    case nop
    /// DW_OP_push_object_address
    case push_object_address
    /// DW_OP_call2
    case call2(UInt16)
    /// DW_OP_call4
    case call4(UInt32)
    /// DW_OP_call_ref
    case call_ref(UInt64) // 32bit: 4, 64bit: 8
    /// DW_OP_form_tls_address
    case form_tls_address
    /// DW_OP_call_frame_cfa
    case call_frame_cfa
    /// DW_OP_bit_piece
    case bit_piece(size: UInt64, offset: UInt64) // uleb128 / uleb128
    /// DW_OP_implicit_value
    case implicit_value(length: UInt64, bytes: Data) // uleb128 / bytes(length)
    /// DW_OP_stack_value
    case stack_value
    /// DW_OP_implicit_pointer
    case implicit_pointer(dieOffset: UInt64, offset: Int64) // 32bit:4 64bit:8 / sleb128
    /// DW_OP_addrx
    case addrx(index: UInt64) // uleb128
    /// DW_OP_constx
    case constx(index: UInt64) // uleb128
    /// DW_OP_entry_value
    case entry_value(length: UInt64, block: Data) // uleb128 / block(length)
    /// DW_OP_const_type
    case const_type(dieOffset: UInt64, size: UInt8, bytes: Data) // uleb128 / size(uint8) / bytes(size)
    /// DW_OP_regval_type
    case regval_type(register: UInt64, dieOffset: UInt64) // uleb128 / uleb128
    /// DW_OP_deref_type
    case deref_type(size: UInt8, dieOffset: UInt64) // size(uint8) / uleb128
    /// DW_OP_xderef_type
    case xderef_type(size: UInt8, dieOffset: UInt64) // size(uint8) / uleb128
    /// DW_OP_convert
    case convert(dieOffset: UInt64) // uleb128
    /// DW_OP_reinterpret
    case reinterpret(dieOffset: UInt64) // uleb128
    /// DW_OP_GNU_push_tls_address
//    case gnu_push_tls_address
//    /// DW_OP_lo_user
//    //    case lo_user
//    /// DW_OP_HP_unknown
//    //    case hp_unknown /* HP conflict: GNU */
//    /// DW_OP_HP_is_value
//    case hp_is_value
//    /// DW_OP_HP_fltconst4
//    case hp_fltconst4
//    /// DW_OP_HP_fltconst8
//    case hp_fltconst8
//    /// DW_OP_HP_mod_range
//    case hp_mod_range
//    /// DW_OP_HP_unmod_range
//    case hp_unmod_range
//    /// DW_OP_HP_tls
//    case hp_tls
}

extension DWARFOperation {
    public var opcode: DWARFOpcode {
        switch self {
        case .addr: .addr
        case .deref: .deref
        case .const1u: .const1u
        case .const1s: .const1s
        case .const2u: .const2u
        case .const2s: .const2s
        case .const4u: .const4u
        case .const4s: .const4s
        case .const8u: .const8u
        case .const8s: .const8s
        case .constu: .constu
        case .consts: .consts
        case .dup: .dup
        case .drop: .drop
        case .over: .over
        case .pick: .pick
        case .swap: .swap
        case .rot: .rot
        case .xderef: .xderef
        case .abs: .abs
        case .and: .and
        case .div: .div
        case .minus: .minus
        case .mod: .mod
        case .mul: .mul
        case .neg: .neg
        case .not: .not
        case .or: .or
        case .plus: .plus
        case .plus_uconst: .plus_uconst
        case .shl: .shl
        case .shr: .shr
        case .shra: .shra
        case .xor: .xor
        case .bra: .bra
        case .eq: .eq
        case .ge: .ge
        case .gt: .gt
        case .le: .le
        case .lt: .lt
        case .ne: .ne
        case .skip: .skip
        case .lit0: .lit0
        case .lit1: .lit1
        case .lit2: .lit2
        case .lit3: .lit3
        case .lit4: .lit4
        case .lit5: .lit5
        case .lit6: .lit6
        case .lit7: .lit7
        case .lit8: .lit8
        case .lit9: .lit9
        case .lit10: .lit10
        case .lit11: .lit11
        case .lit12: .lit12
        case .lit13: .lit13
        case .lit14: .lit14
        case .lit15: .lit15
        case .lit16: .lit16
        case .lit17: .lit17
        case .lit18: .lit18
        case .lit19: .lit19
        case .lit20: .lit20
        case .lit21: .lit21
        case .lit22: .lit22
        case .lit23: .lit23
        case .lit24: .lit24
        case .lit25: .lit25
        case .lit26: .lit26
        case .lit27: .lit27
        case .lit28: .lit28
        case .lit29: .lit29
        case .lit30: .lit30
        case .lit31: .lit31
        case .reg0: .reg0
        case .reg1: .reg1
        case .reg2: .reg2
        case .reg3: .reg3
        case .reg4: .reg4
        case .reg5: .reg5
        case .reg6: .reg6
        case .reg7: .reg7
        case .reg8: .reg8
        case .reg9: .reg9
        case .reg10: .reg10
        case .reg11: .reg11
        case .reg12: .reg12
        case .reg13: .reg13
        case .reg14: .reg14
        case .reg15: .reg15
        case .reg16: .reg16
        case .reg17: .reg17
        case .reg18: .reg18
        case .reg19: .reg19
        case .reg20: .reg20
        case .reg21: .reg21
        case .reg22: .reg22
        case .reg23: .reg23
        case .reg24: .reg24
        case .reg25: .reg25
        case .reg26: .reg26
        case .reg27: .reg27
        case .reg28: .reg28
        case .reg29: .reg29
        case .reg30: .reg30
        case .reg31: .reg31
        case .breg0: .breg0
        case .breg1: .breg1
        case .breg2: .breg2
        case .breg3: .breg3
        case .breg4: .breg4
        case .breg5: .breg5
        case .breg6: .breg6
        case .breg7: .breg7
        case .breg8: .breg8
        case .breg9: .breg9
        case .breg10: .breg10
        case .breg11: .breg11
        case .breg12: .breg12
        case .breg13: .breg13
        case .breg14: .breg14
        case .breg15: .breg15
        case .breg16: .breg16
        case .breg17: .breg17
        case .breg18: .breg18
        case .breg19: .breg19
        case .breg20: .breg20
        case .breg21: .breg21
        case .breg22: .breg22
        case .breg23: .breg23
        case .breg24: .breg24
        case .breg25: .breg25
        case .breg26: .breg26
        case .breg27: .breg27
        case .breg28: .breg28
        case .breg29: .breg29
        case .breg30: .breg30
        case .breg31: .breg31
        case .regx: .regx
        case .fbreg: .fbreg
        case .bregx: .bregx
        case .piece: .piece
        case .deref_size: .deref_size
        case .xderef_size: .xderef_size
        case .nop: .nop
        case .push_object_address: .push_object_address
        case .call2: .call2
        case .call4: .call4
        case .call_ref: .call_ref
        case .form_tls_address: .form_tls_address
        case .call_frame_cfa: .call_frame_cfa
        case .bit_piece: .bit_piece
        case .implicit_value: .implicit_value
        case .stack_value: .stack_value
        case .implicit_pointer: .implicit_pointer
        case .addrx: .addrx
        case .constx: .constx
        case .entry_value: .entry_value
        case .const_type: .const_type
        case .regval_type: .regval_type
        case .deref_type: .deref_type
        case .xderef_type: .xderef_type
        case .convert: .convert
        case .reinterpret: .reinterpret
//        case .gnu_push_tls_address: .gnu_push_tls_address
//            //        case .lo_user: .lo_user
//        case .hp_is_value: .hp_is_value
//        case .hp_fltconst4: .hp_fltconst4
//        case .hp_fltconst8: .hp_fltconst8
//        case .hp_mod_range: .hp_mod_range
//        case .hp_unmod_range: .hp_unmod_range
//        case .hp_tls: .hp_tls
        }
    }
}

extension DWARFOperation {
    internal static func readNext(
        basePointer: UnsafePointer<UInt8>,
        operaionsSize: Int,
        addressSize: Int,
        format: DWARFFormat,
        nextOffset: inout Int,
        done: inout Bool
    ) -> DWARFOperation? {
        guard !done, nextOffset < operaionsSize else { return nil }

        let opcodeRaw = basePointer.advanced(by: nextOffset).pointee
        nextOffset += MemoryLayout<UInt8>.size

        guard let opcode = DWARFOpcode(rawValue: opcodeRaw) else {
            return nil
        }

        switch opcode {
        case .addr:
            if addressSize == 4 {
                let operand: UInt32 = UnsafeRawPointer(basePointer)
                    .advanced(by: nextOffset)
                    .assumingMemoryBound(to: UInt32.self)
                    .pointee
                nextOffset += MemoryLayout<UInt32>.size
                return .addr(numericCast(operand))
            } else {
                let operand: UInt64 = UnsafeRawPointer(basePointer)
                    .advanced(by: nextOffset)
                    .assumingMemoryBound(to: UInt64.self)
                    .pointee
                nextOffset += MemoryLayout<UInt64>.size
                return .addr(operand)
            }
        case .deref:
            return .deref
        case .const1u:
            let operand: UInt8 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: UInt8.self)
                .pointee
            nextOffset += MemoryLayout<UInt8>.size
            return .const1u(operand)
        case .const1s:
            let operand: Int8 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: Int8.self)
                .pointee
            nextOffset += MemoryLayout<Int8>.size
            return .const1s(operand)
        case .const2u:
            let operand: UInt16 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: UInt16.self)
                .pointee
            nextOffset += MemoryLayout<UInt16>.size
            return .const2u(operand)
        case .const2s:
            let operand: Int16 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: Int16.self)
                .pointee
            nextOffset += MemoryLayout<Int16>.size
            return .const2s(operand)
        case .const4u:
            let operand: UInt32 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: UInt32.self)
                .pointee
            nextOffset += MemoryLayout<UInt32>.size
            return .const4u(operand)
        case .const4s:
            let operand: Int32 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: Int32.self)
                .pointee
            nextOffset += MemoryLayout<Int32>.size
            return .const4s(operand)
        case .const8u:
            let operand: UInt64 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: UInt64.self)
                .pointee
            nextOffset += MemoryLayout<UInt64>.size
            return .const8u(operand)
        case .const8s:
            let operand: Int64 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: Int64.self)
                .pointee
            nextOffset += MemoryLayout<Int64>.size
            return .const8s(operand)
        case .constu:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            return .constu(numericCast(operand))
        case .consts:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .consts(numericCast(operand))
        case .dup:
            return .dup
        case .drop:
            return .drop
        case .over:
            return .over
        case .pick:
            let operand: UInt8 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: UInt8.self)
                .pointee
            nextOffset += MemoryLayout<UInt8>.size
            return .pick(index: operand)
        case .swap:
            return .swap
        case .rot:
            return .rot
        case .xderef:
            return .xderef
        case .abs:
            return .abs
        case .and:
            return .and
        case .div:
            return .div
        case .minus:
            return .minus
        case .mod:
            return .mod
        case .mul:
            return .mul
        case .neg:
            return .neg
        case .not:
            return .not
        case .or:
            return .or
        case .plus:
            return .plus
        case .plus_uconst:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            return .plus_uconst(numericCast(operand))
        case .shl:
            return .shl
        case .shr:
            return .shr
        case .shra:
            return .shra
        case .xor:
            return .xor
        case .bra:
            let operand: Int16 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: Int16.self)
                .pointee
            nextOffset += MemoryLayout<Int16>.size
            return .bra(operand)
        case .eq:
            return .eq
        case .ge:
            return .ge
        case .gt:
            return .gt
        case .le:
            return .le
        case .lt:
            return .lt
        case .ne:
            return .ne
        case .skip:
            let operand: Int16 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: Int16.self)
                .pointee
            nextOffset += MemoryLayout<Int16>.size
            return .skip(operand)
        case .lit0:
            return .lit0
        case .lit1:
            return .lit1
        case .lit2:
            return .lit2
        case .lit3:
            return .lit3
        case .lit4:
            return .lit4
        case .lit5:
            return .lit5
        case .lit6:
            return .lit6
        case .lit7:
            return .lit7
        case .lit8:
            return .lit8
        case .lit9:
            return .lit9
        case .lit10:
            return .lit10
        case .lit11:
            return .lit11
        case .lit12:
            return .lit12
        case .lit13:
            return .lit13
        case .lit14:
            return .lit14
        case .lit15:
            return .lit15
        case .lit16:
            return .lit16
        case .lit17:
            return .lit17
        case .lit18:
            return .lit18
        case .lit19:
            return .lit19
        case .lit20:
            return .lit20
        case .lit21:
            return .lit21
        case .lit22:
            return .lit22
        case .lit23:
            return .lit23
        case .lit24:
            return .lit24
        case .lit25:
            return .lit25
        case .lit26:
            return .lit26
        case .lit27:
            return .lit27
        case .lit28:
            return .lit28
        case .lit29:
            return .lit29
        case .lit30:
            return .lit30
        case .lit31:
            return .lit31
        case .reg0:
            return .reg0
        case .reg1:
            return .reg1
        case .reg2:
            return .reg2
        case .reg3:
            return .reg3
        case .reg4:
            return .reg4
        case .reg5:
            return .reg5
        case .reg6:
            return .reg6
        case .reg7:
            return .reg7
        case .reg8:
            return .reg8
        case .reg9:
            return .reg9
        case .reg10:
            return .reg10
        case .reg11:
            return .reg11
        case .reg12:
            return .reg12
        case .reg13:
            return .reg13
        case .reg14:
            return .reg14
        case .reg15:
            return .reg15
        case .reg16:
            return .reg16
        case .reg17:
            return .reg17
        case .reg18:
            return .reg18
        case .reg19:
            return .reg19
        case .reg20:
            return .reg20
        case .reg21:
            return .reg21
        case .reg22:
            return .reg22
        case .reg23:
            return .reg23
        case .reg24:
            return .reg24
        case .reg25:
            return .reg25
        case .reg26:
            return .reg26
        case .reg27:
            return .reg27
        case .reg28:
            return .reg28
        case .reg29:
            return .reg29
        case .reg30:
            return .reg30
        case .reg31:
            return .reg31
        case .breg0:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg0(numericCast(operand))
        case .breg1:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg1(numericCast(operand))
        case .breg2:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg2(numericCast(operand))
        case .breg3:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg3(numericCast(operand))
        case .breg4:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg4(numericCast(operand))
        case .breg5:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg5(numericCast(operand))
        case .breg6:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg6(numericCast(operand))
        case .breg7:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg7(numericCast(operand))
        case .breg8:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg8(numericCast(operand))
        case .breg9:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg9(numericCast(operand))
        case .breg10:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg10(numericCast(operand))
        case .breg11:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg11(numericCast(operand))
        case .breg12:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg12(numericCast(operand))
        case .breg13:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg13(numericCast(operand))
        case .breg14:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg14(numericCast(operand))
        case .breg15:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg15(numericCast(operand))
        case .breg16:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg16(numericCast(operand))
        case .breg17:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg17(numericCast(operand))
        case .breg18:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg18(numericCast(operand))
        case .breg19:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg19(numericCast(operand))
        case .breg20:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg20(numericCast(operand))
        case .breg21:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg21(numericCast(operand))
        case .breg22:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg22(numericCast(operand))
        case .breg23:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg23(numericCast(operand))
        case .breg24:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg24(numericCast(operand))
        case .breg25:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg25(numericCast(operand))
        case .breg26:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg26(numericCast(operand))
        case .breg27:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg27(numericCast(operand))
        case .breg28:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg28(numericCast(operand))
        case .breg29:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg29(numericCast(operand))
        case .breg30:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg30(numericCast(operand))
        case .breg31:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .breg31(numericCast(operand))
        case .regx:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            return .regx(register: numericCast(operand))
        case .fbreg:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .fbreg(numericCast(operand))
        case .bregx:
            let (register, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            let (offset, size2) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size2
            return .bregx(
                register: numericCast(register),
                offset: numericCast(offset)
            )
        case .piece:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            return .piece(numericCast(operand))
        case .deref_size:
            let operand: UInt8 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: UInt8.self)
                .pointee
            nextOffset += MemoryLayout<UInt8>.size
            return .deref_size(operand)
        case .xderef_size:
            let operand: UInt8 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: UInt8.self)
                .pointee
            nextOffset += MemoryLayout<UInt8>.size
            return .xderef_size(operand)
        case .nop:
            return .nop
        case .push_object_address:
            return .push_object_address
        case .call2:
            let operand: UInt16 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: UInt16.self)
                .pointee
            nextOffset += MemoryLayout<UInt16>.size
            return .call2(operand)
        case .call4:
            let operand: UInt32 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: UInt32.self)
                .pointee
            nextOffset += MemoryLayout<UInt32>.size
            return .call4(operand)
        case .call_ref:
            switch format {
            case ._32bit:
                let operand: UInt32 = UnsafeRawPointer(basePointer)
                    .advanced(by: nextOffset)
                    .assumingMemoryBound(to: UInt32.self)
                    .pointee
                nextOffset += MemoryLayout<UInt32>.size
                return .call_ref(numericCast(operand))
            case ._64bit:
                let operand: UInt64 = UnsafeRawPointer(basePointer)
                    .advanced(by: nextOffset)
                    .assumingMemoryBound(to: UInt64.self)
                    .pointee
                nextOffset += MemoryLayout<UInt64>.size
                return .call_ref(numericCast(operand))
            }
        case .form_tls_address:
            return .form_tls_address
        case .call_frame_cfa:
            return .call_frame_cfa
        case .bit_piece:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            let (operand2, size2) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size2
            return .bit_piece(
                size: numericCast(operand),
                offset: numericCast(operand2)
            )
        case .implicit_value:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            let bytes = Data(
                bytes: basePointer.advanced(by: nextOffset),
                count: numericCast(operand)
            )
            nextOffset += bytes.count
            return .implicit_value(
                length: numericCast(operand),
                bytes: bytes
            )
        case .stack_value:
            return .stack_value
        case .implicit_pointer:
            let operand: UInt64 = {
                switch format {
                case ._32bit:
                    let operand: UInt32 = UnsafeRawPointer(basePointer)
                        .advanced(by: nextOffset)
                        .assumingMemoryBound(to: UInt32.self)
                        .pointee
                    nextOffset += MemoryLayout<UInt32>.size
                    return numericCast(operand)
                case ._64bit:
                    let operand: UInt64 = UnsafeRawPointer(basePointer)
                        .advanced(by: nextOffset)
                        .assumingMemoryBound(to: UInt64.self)
                        .pointee
                    nextOffset += MemoryLayout<UInt64>.size
                    return operand
                }
            }()
            let (operand2, size) = basePointer
                .advanced(by: nextOffset)
                .readSLEB128()
            nextOffset += size
            return .implicit_pointer(
                dieOffset: numericCast(operand),
                offset: numericCast(operand2)
            )
        case .addrx:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            return .addrx(index: numericCast(operand))
        case .constx:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            return .constx(index: numericCast(operand))
        case .entry_value:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            let block = Data(
                bytes: basePointer.advanced(by: nextOffset),
                count: numericCast(operand)
            )
            nextOffset += block.count
            return .entry_value(
                length: numericCast(operand),
                block: block
            )
        case .const_type:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            let operand2: UInt8 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: UInt8.self)
                .pointee
            nextOffset += MemoryLayout<UInt8>.size
            let bytes = Data(
                bytes: basePointer.advanced(by: nextOffset),
                count: numericCast(operand2)
            )
            nextOffset += bytes.count
            return .const_type(
                dieOffset: numericCast(operand),
                size: operand2,
                bytes: bytes
            )
        case .regval_type:
            let (register, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            let (offset, size2) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size2
            return .regval_type(
                register: numericCast(register),
                dieOffset: numericCast(offset)
            )
        case .deref_type:
            let operand: UInt8 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: UInt8.self)
                .pointee
            nextOffset += MemoryLayout<UInt8>.size
            let (offset, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            return .deref_type(
                size: operand,
                dieOffset: numericCast(offset)
            )
        case .xderef_type:
            let operand: UInt8 = UnsafeRawPointer(basePointer)
                .advanced(by: nextOffset)
                .assumingMemoryBound(to: UInt8.self)
                .pointee
            nextOffset += MemoryLayout<UInt8>.size
            let (offset, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            return .xderef_type(
                size: operand,
                dieOffset: numericCast(offset)
            )
        case .convert:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            return .convert(dieOffset: numericCast(operand))
        case .reinterpret:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            return .reinterpret(dieOffset: numericCast(operand))
//        case .gnu_push_tls_address:
//            return .gnu_push_tls_address
//        case .hp_is_value:
//            return .hp_is_value
//        case .hp_fltconst4:
//            return .hp_fltconst4
//        case .hp_fltconst8:
//            return .hp_fltconst8
//        case .hp_mod_range:
//            return .hp_mod_range
//        case .hp_unmod_range:
//            return .hp_unmod_range
//        case .hp_tls:
//            return .hp_tls
        }
    }
}
