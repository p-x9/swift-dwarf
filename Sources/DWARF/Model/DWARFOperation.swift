//
//  DWARFOperation.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/04/05
//  
//

import Foundation
import DWARFC

public enum DWARFOperation: CaseIterable {
    /// DW_OP_addr
    case addr
    /// DW_OP_deref
    case deref
    /// DW_OP_const1u
    case const1u
    /// DW_OP_const1s
    case const1s
    /// DW_OP_const2u
    case const2u
    /// DW_OP_const2s
    case const2s
    /// DW_OP_const4u
    case const4u
    /// DW_OP_const4s
    case const4s
    /// DW_OP_const8u
    case const8u
    /// DW_OP_const8s
    case const8s
    /// DW_OP_constu
    case constu
    /// DW_OP_consts
    case consts
    /// DW_OP_dup
    case dup
    /// DW_OP_drop
    case drop
    /// DW_OP_over
    case over
    /// DW_OP_pick
    case pick
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
    case plus_uconst
    /// DW_OP_shl
    case shl
    /// DW_OP_shr
    case shr
    /// DW_OP_shra
    case shra
    /// DW_OP_xor
    case xor
    /// DW_OP_bra
    case bra
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
    case skip
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
    case breg0
    /// DW_OP_breg1
    case breg1
    /// DW_OP_breg2
    case breg2
    /// DW_OP_breg3
    case breg3
    /// DW_OP_breg4
    case breg4
    /// DW_OP_breg5
    case breg5
    /// DW_OP_breg6
    case breg6
    /// DW_OP_breg7
    case breg7
    /// DW_OP_breg8
    case breg8
    /// DW_OP_breg9
    case breg9
    /// DW_OP_breg10
    case breg10
    /// DW_OP_breg11
    case breg11
    /// DW_OP_breg12
    case breg12
    /// DW_OP_breg13
    case breg13
    /// DW_OP_breg14
    case breg14
    /// DW_OP_breg15
    case breg15
    /// DW_OP_breg16
    case breg16
    /// DW_OP_breg17
    case breg17
    /// DW_OP_breg18
    case breg18
    /// DW_OP_breg19
    case breg19
    /// DW_OP_breg20
    case breg20
    /// DW_OP_breg21
    case breg21
    /// DW_OP_breg22
    case breg22
    /// DW_OP_breg23
    case breg23
    /// DW_OP_breg24
    case breg24
    /// DW_OP_breg25
    case breg25
    /// DW_OP_breg26
    case breg26
    /// DW_OP_breg27
    case breg27
    /// DW_OP_breg28
    case breg28
    /// DW_OP_breg29
    case breg29
    /// DW_OP_breg30
    case breg30
    /// DW_OP_breg31
    case breg31
    /// DW_OP_regx
    case regx
    /// DW_OP_fbreg
    case fbreg
    /// DW_OP_bregx
    case bregx
    /// DW_OP_piece
    case piece
    /// DW_OP_deref_size
    case deref_size
    /// DW_OP_xderef_size
    case xderef_size
    /// DW_OP_nop
    case nop
    /// DW_OP_push_object_address
    case push_object_address
    /// DW_OP_call2
    case call2
    /// DW_OP_call4
    case call4
    /// DW_OP_call_ref
    case call_ref
    /// DW_OP_form_tls_address
    case form_tls_address
    /// DW_OP_call_frame_cfa
    case call_frame_cfa
    /// DW_OP_bit_piece
    case bit_piece
    /// DW_OP_implicit_value
    case implicit_value
    /// DW_OP_stack_value
    case stack_value
    /// DW_OP_GNU_push_tls_address
    case gnu_push_tls_address
    /// DW_OP_lo_user
//    case lo_user
    /// DW_OP_HP_unknown
//    case hp_unknown /* HP conflict: GNU */
    /// DW_OP_HP_is_value
    case hp_is_value
    /// DW_OP_HP_fltconst4
    case hp_fltconst4
    /// DW_OP_HP_fltconst8
    case hp_fltconst8
    /// DW_OP_HP_mod_range
    case hp_mod_range
    /// DW_OP_HP_unmod_range
    case hp_unmod_range
    /// DW_OP_HP_tls
    case hp_tls
}

extension DWARFOperation: RawRepresentable {
    public typealias RawValue = UInt8

    public init?(rawValue: RawValue) {
        switch rawValue {
        case numericCast(DW_OP_addr): self = .addr
        case numericCast(DW_OP_deref): self = .deref
        case numericCast(DW_OP_const1u): self = .const1u
        case numericCast(DW_OP_const1s): self = .const1s
        case numericCast(DW_OP_const2u): self = .const2u
        case numericCast(DW_OP_const2s): self = .const2s
        case numericCast(DW_OP_const4u): self = .const4u
        case numericCast(DW_OP_const4s): self = .const4s
        case numericCast(DW_OP_const8u): self = .const8u
        case numericCast(DW_OP_const8s): self = .const8s
        case numericCast(DW_OP_constu): self = .constu
        case numericCast(DW_OP_consts): self = .consts
        case numericCast(DW_OP_dup): self = .dup
        case numericCast(DW_OP_drop): self = .drop
        case numericCast(DW_OP_over): self = .over
        case numericCast(DW_OP_pick): self = .pick
        case numericCast(DW_OP_swap): self = .swap
        case numericCast(DW_OP_rot): self = .rot
        case numericCast(DW_OP_xderef): self = .xderef
        case numericCast(DW_OP_abs): self = .abs
        case numericCast(DW_OP_and): self = .and
        case numericCast(DW_OP_div): self = .div
        case numericCast(DW_OP_minus): self = .minus
        case numericCast(DW_OP_mod): self = .mod
        case numericCast(DW_OP_mul): self = .mul
        case numericCast(DW_OP_neg): self = .neg
        case numericCast(DW_OP_not): self = .not
        case numericCast(DW_OP_or): self = .or
        case numericCast(DW_OP_plus): self = .plus
        case numericCast(DW_OP_plus_uconst): self = .plus_uconst
        case numericCast(DW_OP_shl): self = .shl
        case numericCast(DW_OP_shr): self = .shr
        case numericCast(DW_OP_shra): self = .shra
        case numericCast(DW_OP_xor): self = .xor
        case numericCast(DW_OP_bra): self = .bra
        case numericCast(DW_OP_eq): self = .eq
        case numericCast(DW_OP_ge): self = .ge
        case numericCast(DW_OP_gt): self = .gt
        case numericCast(DW_OP_le): self = .le
        case numericCast(DW_OP_lt): self = .lt
        case numericCast(DW_OP_ne): self = .ne
        case numericCast(DW_OP_skip): self = .skip
        case numericCast(DW_OP_lit0): self = .lit0
        case numericCast(DW_OP_lit1): self = .lit1
        case numericCast(DW_OP_lit2): self = .lit2
        case numericCast(DW_OP_lit3): self = .lit3
        case numericCast(DW_OP_lit4): self = .lit4
        case numericCast(DW_OP_lit5): self = .lit5
        case numericCast(DW_OP_lit6): self = .lit6
        case numericCast(DW_OP_lit7): self = .lit7
        case numericCast(DW_OP_lit8): self = .lit8
        case numericCast(DW_OP_lit9): self = .lit9
        case numericCast(DW_OP_lit10): self = .lit10
        case numericCast(DW_OP_lit11): self = .lit11
        case numericCast(DW_OP_lit12): self = .lit12
        case numericCast(DW_OP_lit13): self = .lit13
        case numericCast(DW_OP_lit14): self = .lit14
        case numericCast(DW_OP_lit15): self = .lit15
        case numericCast(DW_OP_lit16): self = .lit16
        case numericCast(DW_OP_lit17): self = .lit17
        case numericCast(DW_OP_lit18): self = .lit18
        case numericCast(DW_OP_lit19): self = .lit19
        case numericCast(DW_OP_lit20): self = .lit20
        case numericCast(DW_OP_lit21): self = .lit21
        case numericCast(DW_OP_lit22): self = .lit22
        case numericCast(DW_OP_lit23): self = .lit23
        case numericCast(DW_OP_lit24): self = .lit24
        case numericCast(DW_OP_lit25): self = .lit25
        case numericCast(DW_OP_lit26): self = .lit26
        case numericCast(DW_OP_lit27): self = .lit27
        case numericCast(DW_OP_lit28): self = .lit28
        case numericCast(DW_OP_lit29): self = .lit29
        case numericCast(DW_OP_lit30): self = .lit30
        case numericCast(DW_OP_lit31): self = .lit31
        case numericCast(DW_OP_reg0): self = .reg0
        case numericCast(DW_OP_reg1): self = .reg1
        case numericCast(DW_OP_reg2): self = .reg2
        case numericCast(DW_OP_reg3): self = .reg3
        case numericCast(DW_OP_reg4): self = .reg4
        case numericCast(DW_OP_reg5): self = .reg5
        case numericCast(DW_OP_reg6): self = .reg6
        case numericCast(DW_OP_reg7): self = .reg7
        case numericCast(DW_OP_reg8): self = .reg8
        case numericCast(DW_OP_reg9): self = .reg9
        case numericCast(DW_OP_reg10): self = .reg10
        case numericCast(DW_OP_reg11): self = .reg11
        case numericCast(DW_OP_reg12): self = .reg12
        case numericCast(DW_OP_reg13): self = .reg13
        case numericCast(DW_OP_reg14): self = .reg14
        case numericCast(DW_OP_reg15): self = .reg15
        case numericCast(DW_OP_reg16): self = .reg16
        case numericCast(DW_OP_reg17): self = .reg17
        case numericCast(DW_OP_reg18): self = .reg18
        case numericCast(DW_OP_reg19): self = .reg19
        case numericCast(DW_OP_reg20): self = .reg20
        case numericCast(DW_OP_reg21): self = .reg21
        case numericCast(DW_OP_reg22): self = .reg22
        case numericCast(DW_OP_reg23): self = .reg23
        case numericCast(DW_OP_reg24): self = .reg24
        case numericCast(DW_OP_reg25): self = .reg25
        case numericCast(DW_OP_reg26): self = .reg26
        case numericCast(DW_OP_reg27): self = .reg27
        case numericCast(DW_OP_reg28): self = .reg28
        case numericCast(DW_OP_reg29): self = .reg29
        case numericCast(DW_OP_reg30): self = .reg30
        case numericCast(DW_OP_reg31): self = .reg31
        case numericCast(DW_OP_breg0): self = .breg0
        case numericCast(DW_OP_breg1): self = .breg1
        case numericCast(DW_OP_breg2): self = .breg2
        case numericCast(DW_OP_breg3): self = .breg3
        case numericCast(DW_OP_breg4): self = .breg4
        case numericCast(DW_OP_breg5): self = .breg5
        case numericCast(DW_OP_breg6): self = .breg6
        case numericCast(DW_OP_breg7): self = .breg7
        case numericCast(DW_OP_breg8): self = .breg8
        case numericCast(DW_OP_breg9): self = .breg9
        case numericCast(DW_OP_breg10): self = .breg10
        case numericCast(DW_OP_breg11): self = .breg11
        case numericCast(DW_OP_breg12): self = .breg12
        case numericCast(DW_OP_breg13): self = .breg13
        case numericCast(DW_OP_breg14): self = .breg14
        case numericCast(DW_OP_breg15): self = .breg15
        case numericCast(DW_OP_breg16): self = .breg16
        case numericCast(DW_OP_breg17): self = .breg17
        case numericCast(DW_OP_breg18): self = .breg18
        case numericCast(DW_OP_breg19): self = .breg19
        case numericCast(DW_OP_breg20): self = .breg20
        case numericCast(DW_OP_breg21): self = .breg21
        case numericCast(DW_OP_breg22): self = .breg22
        case numericCast(DW_OP_breg23): self = .breg23
        case numericCast(DW_OP_breg24): self = .breg24
        case numericCast(DW_OP_breg25): self = .breg25
        case numericCast(DW_OP_breg26): self = .breg26
        case numericCast(DW_OP_breg27): self = .breg27
        case numericCast(DW_OP_breg28): self = .breg28
        case numericCast(DW_OP_breg29): self = .breg29
        case numericCast(DW_OP_breg30): self = .breg30
        case numericCast(DW_OP_breg31): self = .breg31
        case numericCast(DW_OP_regx): self = .regx
        case numericCast(DW_OP_fbreg): self = .fbreg
        case numericCast(DW_OP_bregx): self = .bregx
        case numericCast(DW_OP_piece): self = .piece
        case numericCast(DW_OP_deref_size): self = .deref_size
        case numericCast(DW_OP_xderef_size): self = .xderef_size
        case numericCast(DW_OP_nop): self = .nop
        case numericCast(DW_OP_push_object_address): self = .push_object_address
        case numericCast(DW_OP_call2): self = .call2
        case numericCast(DW_OP_call4): self = .call4
        case numericCast(DW_OP_call_ref): self = .call_ref
        case numericCast(DW_OP_form_tls_address): self = .form_tls_address
        case numericCast(DW_OP_call_frame_cfa): self = .call_frame_cfa
        case numericCast(DW_OP_bit_piece): self = .bit_piece
        case numericCast(DW_OP_implicit_value): self = .implicit_value
        case numericCast(DW_OP_stack_value): self = .stack_value
        case numericCast(DW_OP_GNU_push_tls_address): self = .gnu_push_tls_address
//        case numericCast(DW_OP_lo_user): self = .lo_user
//        case numericCast(DW_OP_HP_unknown): self = .hp_unknown
        case numericCast(DW_OP_HP_is_value): self = .hp_is_value
        case numericCast(DW_OP_HP_fltconst4): self = .hp_fltconst4
        case numericCast(DW_OP_HP_fltconst8): self = .hp_fltconst8
        case numericCast(DW_OP_HP_mod_range): self = .hp_mod_range
        case numericCast(DW_OP_HP_unmod_range): self = .hp_unmod_range
        case numericCast(DW_OP_HP_tls): self = .hp_tls
        default: return nil
        }
    }
    public var rawValue: RawValue {
        switch self {
        case .addr: numericCast(DW_OP_addr)
        case .deref: numericCast(DW_OP_deref)
        case .const1u: numericCast(DW_OP_const1u)
        case .const1s: numericCast(DW_OP_const1s)
        case .const2u: numericCast(DW_OP_const2u)
        case .const2s: numericCast(DW_OP_const2s)
        case .const4u: numericCast(DW_OP_const4u)
        case .const4s: numericCast(DW_OP_const4s)
        case .const8u: numericCast(DW_OP_const8u)
        case .const8s: numericCast(DW_OP_const8s)
        case .constu: numericCast(DW_OP_constu)
        case .consts: numericCast(DW_OP_consts)
        case .dup: numericCast(DW_OP_dup)
        case .drop: numericCast(DW_OP_drop)
        case .over: numericCast(DW_OP_over)
        case .pick: numericCast(DW_OP_pick)
        case .swap: numericCast(DW_OP_swap)
        case .rot: numericCast(DW_OP_rot)
        case .xderef: numericCast(DW_OP_xderef)
        case .abs: numericCast(DW_OP_abs)
        case .and: numericCast(DW_OP_and)
        case .div: numericCast(DW_OP_div)
        case .minus: numericCast(DW_OP_minus)
        case .mod: numericCast(DW_OP_mod)
        case .mul: numericCast(DW_OP_mul)
        case .neg: numericCast(DW_OP_neg)
        case .not: numericCast(DW_OP_not)
        case .or: numericCast(DW_OP_or)
        case .plus: numericCast(DW_OP_plus)
        case .plus_uconst: numericCast(DW_OP_plus_uconst)
        case .shl: numericCast(DW_OP_shl)
        case .shr: numericCast(DW_OP_shr)
        case .shra: numericCast(DW_OP_shra)
        case .xor: numericCast(DW_OP_xor)
        case .bra: numericCast(DW_OP_bra)
        case .eq: numericCast(DW_OP_eq)
        case .ge: numericCast(DW_OP_ge)
        case .gt: numericCast(DW_OP_gt)
        case .le: numericCast(DW_OP_le)
        case .lt: numericCast(DW_OP_lt)
        case .ne: numericCast(DW_OP_ne)
        case .skip: numericCast(DW_OP_skip)
        case .lit0: numericCast(DW_OP_lit0)
        case .lit1: numericCast(DW_OP_lit1)
        case .lit2: numericCast(DW_OP_lit2)
        case .lit3: numericCast(DW_OP_lit3)
        case .lit4: numericCast(DW_OP_lit4)
        case .lit5: numericCast(DW_OP_lit5)
        case .lit6: numericCast(DW_OP_lit6)
        case .lit7: numericCast(DW_OP_lit7)
        case .lit8: numericCast(DW_OP_lit8)
        case .lit9: numericCast(DW_OP_lit9)
        case .lit10: numericCast(DW_OP_lit10)
        case .lit11: numericCast(DW_OP_lit11)
        case .lit12: numericCast(DW_OP_lit12)
        case .lit13: numericCast(DW_OP_lit13)
        case .lit14: numericCast(DW_OP_lit14)
        case .lit15: numericCast(DW_OP_lit15)
        case .lit16: numericCast(DW_OP_lit16)
        case .lit17: numericCast(DW_OP_lit17)
        case .lit18: numericCast(DW_OP_lit18)
        case .lit19: numericCast(DW_OP_lit19)
        case .lit20: numericCast(DW_OP_lit20)
        case .lit21: numericCast(DW_OP_lit21)
        case .lit22: numericCast(DW_OP_lit22)
        case .lit23: numericCast(DW_OP_lit23)
        case .lit24: numericCast(DW_OP_lit24)
        case .lit25: numericCast(DW_OP_lit25)
        case .lit26: numericCast(DW_OP_lit26)
        case .lit27: numericCast(DW_OP_lit27)
        case .lit28: numericCast(DW_OP_lit28)
        case .lit29: numericCast(DW_OP_lit29)
        case .lit30: numericCast(DW_OP_lit30)
        case .lit31: numericCast(DW_OP_lit31)
        case .reg0: numericCast(DW_OP_reg0)
        case .reg1: numericCast(DW_OP_reg1)
        case .reg2: numericCast(DW_OP_reg2)
        case .reg3: numericCast(DW_OP_reg3)
        case .reg4: numericCast(DW_OP_reg4)
        case .reg5: numericCast(DW_OP_reg5)
        case .reg6: numericCast(DW_OP_reg6)
        case .reg7: numericCast(DW_OP_reg7)
        case .reg8: numericCast(DW_OP_reg8)
        case .reg9: numericCast(DW_OP_reg9)
        case .reg10: numericCast(DW_OP_reg10)
        case .reg11: numericCast(DW_OP_reg11)
        case .reg12: numericCast(DW_OP_reg12)
        case .reg13: numericCast(DW_OP_reg13)
        case .reg14: numericCast(DW_OP_reg14)
        case .reg15: numericCast(DW_OP_reg15)
        case .reg16: numericCast(DW_OP_reg16)
        case .reg17: numericCast(DW_OP_reg17)
        case .reg18: numericCast(DW_OP_reg18)
        case .reg19: numericCast(DW_OP_reg19)
        case .reg20: numericCast(DW_OP_reg20)
        case .reg21: numericCast(DW_OP_reg21)
        case .reg22: numericCast(DW_OP_reg22)
        case .reg23: numericCast(DW_OP_reg23)
        case .reg24: numericCast(DW_OP_reg24)
        case .reg25: numericCast(DW_OP_reg25)
        case .reg26: numericCast(DW_OP_reg26)
        case .reg27: numericCast(DW_OP_reg27)
        case .reg28: numericCast(DW_OP_reg28)
        case .reg29: numericCast(DW_OP_reg29)
        case .reg30: numericCast(DW_OP_reg30)
        case .reg31: numericCast(DW_OP_reg31)
        case .breg0: numericCast(DW_OP_breg0)
        case .breg1: numericCast(DW_OP_breg1)
        case .breg2: numericCast(DW_OP_breg2)
        case .breg3: numericCast(DW_OP_breg3)
        case .breg4: numericCast(DW_OP_breg4)
        case .breg5: numericCast(DW_OP_breg5)
        case .breg6: numericCast(DW_OP_breg6)
        case .breg7: numericCast(DW_OP_breg7)
        case .breg8: numericCast(DW_OP_breg8)
        case .breg9: numericCast(DW_OP_breg9)
        case .breg10: numericCast(DW_OP_breg10)
        case .breg11: numericCast(DW_OP_breg11)
        case .breg12: numericCast(DW_OP_breg12)
        case .breg13: numericCast(DW_OP_breg13)
        case .breg14: numericCast(DW_OP_breg14)
        case .breg15: numericCast(DW_OP_breg15)
        case .breg16: numericCast(DW_OP_breg16)
        case .breg17: numericCast(DW_OP_breg17)
        case .breg18: numericCast(DW_OP_breg18)
        case .breg19: numericCast(DW_OP_breg19)
        case .breg20: numericCast(DW_OP_breg20)
        case .breg21: numericCast(DW_OP_breg21)
        case .breg22: numericCast(DW_OP_breg22)
        case .breg23: numericCast(DW_OP_breg23)
        case .breg24: numericCast(DW_OP_breg24)
        case .breg25: numericCast(DW_OP_breg25)
        case .breg26: numericCast(DW_OP_breg26)
        case .breg27: numericCast(DW_OP_breg27)
        case .breg28: numericCast(DW_OP_breg28)
        case .breg29: numericCast(DW_OP_breg29)
        case .breg30: numericCast(DW_OP_breg30)
        case .breg31: numericCast(DW_OP_breg31)
        case .regx: numericCast(DW_OP_regx)
        case .fbreg: numericCast(DW_OP_fbreg)
        case .bregx: numericCast(DW_OP_bregx)
        case .piece: numericCast(DW_OP_piece)
        case .deref_size: numericCast(DW_OP_deref_size)
        case .xderef_size: numericCast(DW_OP_xderef_size)
        case .nop: numericCast(DW_OP_nop)
        case .push_object_address: numericCast(DW_OP_push_object_address)
        case .call2: numericCast(DW_OP_call2)
        case .call4: numericCast(DW_OP_call4)
        case .call_ref: numericCast(DW_OP_call_ref)
        case .form_tls_address: numericCast(DW_OP_form_tls_address)
        case .call_frame_cfa: numericCast(DW_OP_call_frame_cfa)
        case .bit_piece: numericCast(DW_OP_bit_piece)
        case .implicit_value: numericCast(DW_OP_implicit_value)
        case .stack_value: numericCast(DW_OP_stack_value)
        case .gnu_push_tls_address: numericCast(DW_OP_GNU_push_tls_address)
//        case .lo_user: numericCast(DW_OP_lo_user)
//        case .hp_unknown: numericCast(DW_OP_HP_unknown)
        case .hp_is_value: numericCast(DW_OP_HP_is_value)
        case .hp_fltconst4: numericCast(DW_OP_HP_fltconst4)
        case .hp_fltconst8: numericCast(DW_OP_HP_fltconst8)
        case .hp_mod_range: numericCast(DW_OP_HP_mod_range)
        case .hp_unmod_range: numericCast(DW_OP_HP_unmod_range)
        case .hp_tls: numericCast(DW_OP_HP_tls)
        }
    }
}
extension DWARFOperation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .addr: "DW_OP_addr"
        case .deref: "DW_OP_deref"
        case .const1u: "DW_OP_const1u"
        case .const1s: "DW_OP_const1s"
        case .const2u: "DW_OP_const2u"
        case .const2s: "DW_OP_const2s"
        case .const4u: "DW_OP_const4u"
        case .const4s: "DW_OP_const4s"
        case .const8u: "DW_OP_const8u"
        case .const8s: "DW_OP_const8s"
        case .constu: "DW_OP_constu"
        case .consts: "DW_OP_consts"
        case .dup: "DW_OP_dup"
        case .drop: "DW_OP_drop"
        case .over: "DW_OP_over"
        case .pick: "DW_OP_pick"
        case .swap: "DW_OP_swap"
        case .rot: "DW_OP_rot"
        case .xderef: "DW_OP_xderef"
        case .abs: "DW_OP_abs"
        case .and: "DW_OP_and"
        case .div: "DW_OP_div"
        case .minus: "DW_OP_minus"
        case .mod: "DW_OP_mod"
        case .mul: "DW_OP_mul"
        case .neg: "DW_OP_neg"
        case .not: "DW_OP_not"
        case .or: "DW_OP_or"
        case .plus: "DW_OP_plus"
        case .plus_uconst: "DW_OP_plus_uconst"
        case .shl: "DW_OP_shl"
        case .shr: "DW_OP_shr"
        case .shra: "DW_OP_shra"
        case .xor: "DW_OP_xor"
        case .bra: "DW_OP_bra"
        case .eq: "DW_OP_eq"
        case .ge: "DW_OP_ge"
        case .gt: "DW_OP_gt"
        case .le: "DW_OP_le"
        case .lt: "DW_OP_lt"
        case .ne: "DW_OP_ne"
        case .skip: "DW_OP_skip"
        case .lit0: "DW_OP_lit0"
        case .lit1: "DW_OP_lit1"
        case .lit2: "DW_OP_lit2"
        case .lit3: "DW_OP_lit3"
        case .lit4: "DW_OP_lit4"
        case .lit5: "DW_OP_lit5"
        case .lit6: "DW_OP_lit6"
        case .lit7: "DW_OP_lit7"
        case .lit8: "DW_OP_lit8"
        case .lit9: "DW_OP_lit9"
        case .lit10: "DW_OP_lit10"
        case .lit11: "DW_OP_lit11"
        case .lit12: "DW_OP_lit12"
        case .lit13: "DW_OP_lit13"
        case .lit14: "DW_OP_lit14"
        case .lit15: "DW_OP_lit15"
        case .lit16: "DW_OP_lit16"
        case .lit17: "DW_OP_lit17"
        case .lit18: "DW_OP_lit18"
        case .lit19: "DW_OP_lit19"
        case .lit20: "DW_OP_lit20"
        case .lit21: "DW_OP_lit21"
        case .lit22: "DW_OP_lit22"
        case .lit23: "DW_OP_lit23"
        case .lit24: "DW_OP_lit24"
        case .lit25: "DW_OP_lit25"
        case .lit26: "DW_OP_lit26"
        case .lit27: "DW_OP_lit27"
        case .lit28: "DW_OP_lit28"
        case .lit29: "DW_OP_lit29"
        case .lit30: "DW_OP_lit30"
        case .lit31: "DW_OP_lit31"
        case .reg0: "DW_OP_reg0"
        case .reg1: "DW_OP_reg1"
        case .reg2: "DW_OP_reg2"
        case .reg3: "DW_OP_reg3"
        case .reg4: "DW_OP_reg4"
        case .reg5: "DW_OP_reg5"
        case .reg6: "DW_OP_reg6"
        case .reg7: "DW_OP_reg7"
        case .reg8: "DW_OP_reg8"
        case .reg9: "DW_OP_reg9"
        case .reg10: "DW_OP_reg10"
        case .reg11: "DW_OP_reg11"
        case .reg12: "DW_OP_reg12"
        case .reg13: "DW_OP_reg13"
        case .reg14: "DW_OP_reg14"
        case .reg15: "DW_OP_reg15"
        case .reg16: "DW_OP_reg16"
        case .reg17: "DW_OP_reg17"
        case .reg18: "DW_OP_reg18"
        case .reg19: "DW_OP_reg19"
        case .reg20: "DW_OP_reg20"
        case .reg21: "DW_OP_reg21"
        case .reg22: "DW_OP_reg22"
        case .reg23: "DW_OP_reg23"
        case .reg24: "DW_OP_reg24"
        case .reg25: "DW_OP_reg25"
        case .reg26: "DW_OP_reg26"
        case .reg27: "DW_OP_reg27"
        case .reg28: "DW_OP_reg28"
        case .reg29: "DW_OP_reg29"
        case .reg30: "DW_OP_reg30"
        case .reg31: "DW_OP_reg31"
        case .breg0: "DW_OP_breg0"
        case .breg1: "DW_OP_breg1"
        case .breg2: "DW_OP_breg2"
        case .breg3: "DW_OP_breg3"
        case .breg4: "DW_OP_breg4"
        case .breg5: "DW_OP_breg5"
        case .breg6: "DW_OP_breg6"
        case .breg7: "DW_OP_breg7"
        case .breg8: "DW_OP_breg8"
        case .breg9: "DW_OP_breg9"
        case .breg10: "DW_OP_breg10"
        case .breg11: "DW_OP_breg11"
        case .breg12: "DW_OP_breg12"
        case .breg13: "DW_OP_breg13"
        case .breg14: "DW_OP_breg14"
        case .breg15: "DW_OP_breg15"
        case .breg16: "DW_OP_breg16"
        case .breg17: "DW_OP_breg17"
        case .breg18: "DW_OP_breg18"
        case .breg19: "DW_OP_breg19"
        case .breg20: "DW_OP_breg20"
        case .breg21: "DW_OP_breg21"
        case .breg22: "DW_OP_breg22"
        case .breg23: "DW_OP_breg23"
        case .breg24: "DW_OP_breg24"
        case .breg25: "DW_OP_breg25"
        case .breg26: "DW_OP_breg26"
        case .breg27: "DW_OP_breg27"
        case .breg28: "DW_OP_breg28"
        case .breg29: "DW_OP_breg29"
        case .breg30: "DW_OP_breg30"
        case .breg31: "DW_OP_breg31"
        case .regx: "DW_OP_regx"
        case .fbreg: "DW_OP_fbreg"
        case .bregx: "DW_OP_bregx"
        case .piece: "DW_OP_piece"
        case .deref_size: "DW_OP_deref_size"
        case .xderef_size: "DW_OP_xderef_size"
        case .nop: "DW_OP_nop"
        case .push_object_address: "DW_OP_push_object_address"
        case .call2: "DW_OP_call2"
        case .call4: "DW_OP_call4"
        case .call_ref: "DW_OP_call_ref"
        case .form_tls_address: "DW_OP_form_tls_address"
        case .call_frame_cfa: "DW_OP_call_frame_cfa"
        case .bit_piece: "DW_OP_bit_piece"
        case .implicit_value: "DW_OP_implicit_value"
        case .stack_value: "DW_OP_stack_value"
        case .gnu_push_tls_address: "DW_OP_GNU_push_tls_address"
//        case .lo_user: "DW_OP_lo_user"
//        case .hp_unknown: "DW_OP_HP_unknown"
        case .hp_is_value: "DW_OP_HP_is_value"
        case .hp_fltconst4: "DW_OP_HP_fltconst4"
        case .hp_fltconst8: "DW_OP_HP_fltconst8"
        case .hp_mod_range: "DW_OP_HP_mod_range"
        case .hp_unmod_range: "DW_OP_HP_unmod_range"
        case .hp_tls: "DW_OP_HP_tls"
        }
    }
}
