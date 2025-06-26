//
//  DWARFTag.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/04/03
//  
//

import Foundation
import DWARFC

public enum DWARFTag: CaseIterable {
    /// DW_TAG_null
    case null
    /// DW_TAG_array_type
    case array_type
    /// DW_TAG_class_type
    case class_type
    /// DW_TAG_entry_point
    case entry_point
    /// DW_TAG_enumeration_type
    case enumeration_type
    /// DW_TAG_formal_parameter
    case formal_parameter
    /// DW_TAG_imported_declaration
    case imported_declaration
    /// DW_TAG_label
    case label
    /// DW_TAG_lexical_block
    case lexical_block
    /// DW_TAG_member
    case member
    /// DW_TAG_pointer_type
    case pointer_type
    /// DW_TAG_reference_type
    case reference_type
    /// DW_TAG_compile_unit
    case compile_unit
    /// DW_TAG_string_type
    case string_type
    /// DW_TAG_structure_type
    case structure_type
    /// DW_TAG_subroutine_type
    case subroutine_type
    /// DW_TAG_typedef
    case typedef
    /// DW_TAG_union_type
    case union_type
    /// DW_TAG_unspecified_parameters
    case unspecified_parameters
    /// DW_TAG_variant
    case variant
    /// DW_TAG_common_block
    case common_block
    /// DW_TAG_common_inclusion
    case common_inclusion
    /// DW_TAG_inheritance
    case inheritance
    /// DW_TAG_inlined_subroutine
    case inlined_subroutine
    /// DW_TAG_module
    case module
    /// DW_TAG_ptr_to_member_type
    case ptr_to_member_type
    /// DW_TAG_set_type
    case set_type
    /// DW_TAG_subrange_type
    case subrange_type
    /// DW_TAG_with_stmt
    case with_stmt
    /// DW_TAG_access_declaration
    case access_declaration
    /// DW_TAG_base_type
    case base_type
    /// DW_TAG_catch_block
    case catch_block
    /// DW_TAG_const_type
    case const_type
    /// DW_TAG_constant
    case constant
    /// DW_TAG_enumerator
    case enumerator
    /// DW_TAG_file_type
    case file_type
    /// DW_TAG_friend
    case friend
    /// DW_TAG_namelist
    case namelist
    /// DW_TAG_namelist_item
    case namelist_item
    /// DW_TAG_packed_type
    case packed_type
    /// DW_TAG_subprogram
    case subprogram
    /// DW_TAG_template_type_parameter
    case template_type_parameter
    /// DW_TAG_template_value_parameter
    case template_value_parameter
    /// DW_TAG_thrown_type
    case thrown_type
    /// DW_TAG_try_block
    case try_block
    /// DW_TAG_variant_part
    case variant_part
    /// DW_TAG_variable
    case variable
    /// DW_TAG_volatile_type
    case volatile_type
    /// DW_TAG_dwarf_procedure
    case dwarf_procedure
    /// DW_TAG_restrict_type
    case restrict_type
    /// DW_TAG_interface_type
    case interface_type
    /// DW_TAG_namespace
    case namespace
    /// DW_TAG_imported_module
    case imported_module
    /// DW_TAG_unspecified_type
    case unspecified_type
    /// DW_TAG_partial_unit
    case partial_unit
    /// DW_TAG_imported_unit
    case imported_unit
    /// DW_TAG_mutable_type
    case mutable_type
    /// DW_TAG_condition
    case condition
    /// DW_TAG_shared_type
    case shared_type
    /// DW_TAG_type_unit
    case type_unit
    /// DW_TAG_rvalue_reference_type
    case rvalue_reference_type
    /// DW_TAG_template_alias
    case template_alias
    /// DW_TAG_coarray_type
    case coarray_type
    /// DW_TAG_generic_subrange
    case generic_subrange
    /// DW_TAG_dynamic_type
    case dynamic_type
    /// DW_TAG_atomic_type
    case atomic_type
    /// DW_TAG_call_site
    case call_site
    /// DW_TAG_call_site_parameter
    case call_site_parameter
    /// DW_TAG_skeleton_unit
    case skeleton_unit
    /// DW_TAG_immutable_type
    case immutable_type
    /// DW_TAG_TI_far_type
    case ti_far_type
    /// DW_TAG_lo_user
//    case lo_user
    /// DW_TAG_MIPS_loop
    case mips_loop
    /// DW_TAG_TI_near_type
    case ti_near_type
    /// DW_TAG_TI_assign_register
    case ti_assign_register
    /// DW_TAG_TI_ioport_type
    case ti_ioport_type
    /// DW_TAG_TI_restrict_type
    case ti_restrict_type
    /// DW_TAG_TI_onchip_type
    case ti_onchip_type
    /// DW_TAG_HP_array_descriptor
    case hp_array_descriptor
    /// DW_TAG_format_label
    case format_label
    /// DW_TAG_function_template
    case function_template
    /// DW_TAG_class_template
    case class_template
    /// DW_TAG_GNU_BINCL
    case gnu_bincl
    /// DW_TAG_GNU_EINCL
    case gnu_eincl
    /// DW_TAG_GNU_template_template_parameter
    case gnu_template_template_parameter
    /// DW_TAG_GNU_template_template_param
    case gnu_template_template_param
    /// DW_TAG_GNU_template_parameter_pack
    case gnu_template_parameter_pack
    /// DW_TAG_GNU_formal_parameter_pack
    case gnu_formal_parameter_pack
    /// DW_TAG_GNU_call_site
    case gnu_call_site
    /// DW_TAG_GNU_call_site_parameter
    case gnu_call_site_parameter
    /// DW_TAG_APPLE_property
    case apple_property
    /// DW_TAG_SUN_function_template
    case sun_function_template
    /// DW_TAG_SUN_class_template
    case sun_class_template
    /// DW_TAG_SUN_struct_template
    case sun_struct_template
    /// DW_TAG_SUN_union_template
    case sun_union_template
    /// DW_TAG_SUN_indirect_inheritance
    case sun_indirect_inheritance
    /// DW_TAG_SUN_codeflags
    case sun_codeflags
    /// DW_TAG_SUN_memop_info
    case sun_memop_info
    /// DW_TAG_SUN_omp_child_func
    case sun_omp_child_func
    /// DW_TAG_SUN_rtti_descriptor
    case sun_rtti_descriptor
    /// DW_TAG_SUN_dtor_info
    case sun_dtor_info
    /// DW_TAG_SUN_dtor
    case sun_dtor
    /// DW_TAG_SUN_f90_interface
    case sun_f90_interface
    /// DW_TAG_SUN_fortran_vax_structure
    case sun_fortran_vax_structure
    /// DW_TAG_SUN_hi
//    case sun_hi
    /// DW_TAG_LLVM_ptrauth_type
    case llvm_ptrauth_type
    /// DW_TAG_ALTIUM_circ_type
    case altium_circ_type
    /// DW_TAG_ALTIUM_mwa_circ_type
    case altium_mwa_circ_type
    /// DW_TAG_ALTIUM_rev_carry_type
    case altium_rev_carry_type
    /// DW_TAG_ALTIUM_rom
    case altium_rom
    /// DW_TAG_LLVM_annotation
    case llvm_annotation
    /// DW_TAG_ghs_namespace
    case ghs_namespace
    /// DW_TAG_ghs_using_namespace
    case ghs_using_namespace
    /// DW_TAG_ghs_using_declaration
    case ghs_using_declaration
    /// DW_TAG_ghs_template_templ_param
    case ghs_template_templ_param
    /// DW_TAG_upc_shared_type
    case upc_shared_type
    /// DW_TAG_upc_strict_type
    case upc_strict_type
    /// DW_TAG_upc_relaxed_type
    case upc_relaxed_type
    /// DW_TAG_UPC_relaxed
    case upc_relaxed
    /// DW_TAG_PGI_kanji_type
    case pgi_kanji_type
    /// DW_TAG_PGI_interface_block
    case pgi_interface_block
    /// DW_TAG_BORLAND_property
    case borland_property
    /// DW_TAG_BORLAND_Delphi_string
    case borland_delphi_string
    /// DW_TAG_BORLAND_Delphi_dynamic_array
    case borland_delphi_dynamic_array
    /// DW_TAG_BORLAND_Delphi_set
    case borland_delphi_set
    /// DW_TAG_BORLAND_Delphi_variant
    case borland_delphi_variant
    /// DW_TAG_hi_user
//    case hi_user
}

extension DWARFTag: RawRepresentable {
    public typealias RawValue = UInt32

    public init?(rawValue: RawValue) {
        switch rawValue {
        case numericCast(DW_TAG_null): self = .null
        case numericCast(DW_TAG_array_type): self = .array_type
        case numericCast(DW_TAG_class_type): self = .class_type
        case numericCast(DW_TAG_entry_point): self = .entry_point
        case numericCast(DW_TAG_enumeration_type): self = .enumeration_type
        case numericCast(DW_TAG_formal_parameter): self = .formal_parameter
        case numericCast(DW_TAG_imported_declaration): self = .imported_declaration
        case numericCast(DW_TAG_label): self = .label
        case numericCast(DW_TAG_lexical_block): self = .lexical_block
        case numericCast(DW_TAG_member): self = .member
        case numericCast(DW_TAG_pointer_type): self = .pointer_type
        case numericCast(DW_TAG_reference_type): self = .reference_type
        case numericCast(DW_TAG_compile_unit): self = .compile_unit
        case numericCast(DW_TAG_string_type): self = .string_type
        case numericCast(DW_TAG_structure_type): self = .structure_type
        case numericCast(DW_TAG_subroutine_type): self = .subroutine_type
        case numericCast(DW_TAG_typedef): self = .typedef
        case numericCast(DW_TAG_union_type): self = .union_type
        case numericCast(DW_TAG_unspecified_parameters): self = .unspecified_parameters
        case numericCast(DW_TAG_variant): self = .variant
        case numericCast(DW_TAG_common_block): self = .common_block
        case numericCast(DW_TAG_common_inclusion): self = .common_inclusion
        case numericCast(DW_TAG_inheritance): self = .inheritance
        case numericCast(DW_TAG_inlined_subroutine): self = .inlined_subroutine
        case numericCast(DW_TAG_module): self = .module
        case numericCast(DW_TAG_ptr_to_member_type): self = .ptr_to_member_type
        case numericCast(DW_TAG_set_type): self = .set_type
        case numericCast(DW_TAG_subrange_type): self = .subrange_type
        case numericCast(DW_TAG_with_stmt): self = .with_stmt
        case numericCast(DW_TAG_access_declaration): self = .access_declaration
        case numericCast(DW_TAG_base_type): self = .base_type
        case numericCast(DW_TAG_catch_block): self = .catch_block
        case numericCast(DW_TAG_const_type): self = .const_type
        case numericCast(DW_TAG_constant): self = .constant
        case numericCast(DW_TAG_enumerator): self = .enumerator
        case numericCast(DW_TAG_file_type): self = .file_type
        case numericCast(DW_TAG_friend): self = .friend
        case numericCast(DW_TAG_namelist): self = .namelist
        case numericCast(DW_TAG_namelist_item): self = .namelist_item
        case numericCast(DW_TAG_packed_type): self = .packed_type
        case numericCast(DW_TAG_subprogram): self = .subprogram
        case numericCast(DW_TAG_template_type_parameter): self = .template_type_parameter
        case numericCast(DW_TAG_template_value_parameter): self = .template_value_parameter
        case numericCast(DW_TAG_thrown_type): self = .thrown_type
        case numericCast(DW_TAG_try_block): self = .try_block
        case numericCast(DW_TAG_variant_part): self = .variant_part
        case numericCast(DW_TAG_variable): self = .variable
        case numericCast(DW_TAG_volatile_type): self = .volatile_type
        case numericCast(DW_TAG_dwarf_procedure): self = .dwarf_procedure
        case numericCast(DW_TAG_restrict_type): self = .restrict_type
        case numericCast(DW_TAG_interface_type): self = .interface_type
        case numericCast(DW_TAG_namespace): self = .namespace
        case numericCast(DW_TAG_imported_module): self = .imported_module
        case numericCast(DW_TAG_unspecified_type): self = .unspecified_type
        case numericCast(DW_TAG_partial_unit): self = .partial_unit
        case numericCast(DW_TAG_imported_unit): self = .imported_unit
        case numericCast(DW_TAG_mutable_type): self = .mutable_type
        case numericCast(DW_TAG_condition): self = .condition
        case numericCast(DW_TAG_shared_type): self = .shared_type
        case numericCast(DW_TAG_type_unit): self = .type_unit
        case numericCast(DW_TAG_rvalue_reference_type): self = .rvalue_reference_type
        case numericCast(DW_TAG_template_alias): self = .template_alias
        case numericCast(DW_TAG_coarray_type): self = .coarray_type
        case numericCast(DW_TAG_generic_subrange): self = .generic_subrange
        case numericCast(DW_TAG_dynamic_type): self = .dynamic_type
        case numericCast(DW_TAG_atomic_type): self = .atomic_type
        case numericCast(DW_TAG_call_site): self = .call_site
        case numericCast(DW_TAG_call_site_parameter): self = .call_site_parameter
        case numericCast(DW_TAG_skeleton_unit): self = .skeleton_unit
        case numericCast(DW_TAG_immutable_type): self = .immutable_type
        case numericCast(DW_TAG_TI_far_type): self = .ti_far_type
//        case numericCast(DW_TAG_lo_user): self = .lo_user
        case numericCast(DW_TAG_MIPS_loop): self = .mips_loop
        case numericCast(DW_TAG_TI_near_type): self = .ti_near_type
        case numericCast(DW_TAG_TI_assign_register): self = .ti_assign_register
        case numericCast(DW_TAG_TI_ioport_type): self = .ti_ioport_type
        case numericCast(DW_TAG_TI_restrict_type): self = .ti_restrict_type
        case numericCast(DW_TAG_TI_onchip_type): self = .ti_onchip_type
        case numericCast(DW_TAG_HP_array_descriptor): self = .hp_array_descriptor
        case numericCast(DW_TAG_format_label): self = .format_label
        case numericCast(DW_TAG_function_template): self = .function_template
        case numericCast(DW_TAG_class_template): self = .class_template
        case numericCast(DW_TAG_GNU_BINCL): self = .gnu_bincl
        case numericCast(DW_TAG_GNU_EINCL): self = .gnu_eincl
        case numericCast(DW_TAG_GNU_template_template_parameter): self = .gnu_template_template_parameter
        case numericCast(DW_TAG_GNU_template_template_param): self = .gnu_template_template_param
        case numericCast(DW_TAG_GNU_template_parameter_pack): self = .gnu_template_parameter_pack
        case numericCast(DW_TAG_GNU_formal_parameter_pack): self = .gnu_formal_parameter_pack
        case numericCast(DW_TAG_GNU_call_site): self = .gnu_call_site
        case numericCast(DW_TAG_GNU_call_site_parameter): self = .gnu_call_site_parameter
        case numericCast(DW_TAG_APPLE_property): self = .apple_property
        case numericCast(DW_TAG_SUN_function_template): self = .sun_function_template
        case numericCast(DW_TAG_SUN_class_template): self = .sun_class_template
        case numericCast(DW_TAG_SUN_struct_template): self = .sun_struct_template
        case numericCast(DW_TAG_SUN_union_template): self = .sun_union_template
        case numericCast(DW_TAG_SUN_indirect_inheritance): self = .sun_indirect_inheritance
        case numericCast(DW_TAG_SUN_codeflags): self = .sun_codeflags
        case numericCast(DW_TAG_SUN_memop_info): self = .sun_memop_info
        case numericCast(DW_TAG_SUN_omp_child_func): self = .sun_omp_child_func
        case numericCast(DW_TAG_SUN_rtti_descriptor): self = .sun_rtti_descriptor
        case numericCast(DW_TAG_SUN_dtor_info): self = .sun_dtor_info
        case numericCast(DW_TAG_SUN_dtor): self = .sun_dtor
        case numericCast(DW_TAG_SUN_f90_interface): self = .sun_f90_interface
        case numericCast(DW_TAG_SUN_fortran_vax_structure): self = .sun_fortran_vax_structure
//        case numericCast(DW_TAG_SUN_hi): self = .sun_hi
        case numericCast(DW_TAG_LLVM_ptrauth_type): self = .llvm_ptrauth_type
        case numericCast(DW_TAG_ALTIUM_circ_type): self = .altium_circ_type
        case numericCast(DW_TAG_ALTIUM_mwa_circ_type): self = .altium_mwa_circ_type
        case numericCast(DW_TAG_ALTIUM_rev_carry_type): self = .altium_rev_carry_type
        case numericCast(DW_TAG_ALTIUM_rom): self = .altium_rom
        case numericCast(DW_TAG_LLVM_annotation): self = .llvm_annotation
        case numericCast(DW_TAG_ghs_namespace): self = .ghs_namespace
        case numericCast(DW_TAG_ghs_using_namespace): self = .ghs_using_namespace
        case numericCast(DW_TAG_ghs_using_declaration): self = .ghs_using_declaration
        case numericCast(DW_TAG_ghs_template_templ_param): self = .ghs_template_templ_param
        case numericCast(DW_TAG_upc_shared_type): self = .upc_shared_type
        case numericCast(DW_TAG_upc_strict_type): self = .upc_strict_type
        case numericCast(DW_TAG_upc_relaxed_type): self = .upc_relaxed_type
        case numericCast(DW_TAG_UPC_relaxed): self = .upc_relaxed
        case numericCast(DW_TAG_PGI_kanji_type): self = .pgi_kanji_type
        case numericCast(DW_TAG_PGI_interface_block): self = .pgi_interface_block
        case numericCast(DW_TAG_BORLAND_property): self = .borland_property
        case numericCast(DW_TAG_BORLAND_Delphi_string): self = .borland_delphi_string
        case numericCast(DW_TAG_BORLAND_Delphi_dynamic_array): self = .borland_delphi_dynamic_array
        case numericCast(DW_TAG_BORLAND_Delphi_set): self = .borland_delphi_set
        case numericCast(DW_TAG_BORLAND_Delphi_variant): self = .borland_delphi_variant
//        case numericCast(DW_TAG_hi_user): self = .hi_user
        default: return nil
        }
    }

    public var rawValue: RawValue {
        switch self {
        case .null: numericCast(DW_TAG_null)
        case .array_type: numericCast(DW_TAG_array_type)
        case .class_type: numericCast(DW_TAG_class_type)
        case .entry_point: numericCast(DW_TAG_entry_point)
        case .enumeration_type: numericCast(DW_TAG_enumeration_type)
        case .formal_parameter: numericCast(DW_TAG_formal_parameter)
        case .imported_declaration: numericCast(DW_TAG_imported_declaration)
        case .label: numericCast(DW_TAG_label)
        case .lexical_block: numericCast(DW_TAG_lexical_block)
        case .member: numericCast(DW_TAG_member)
        case .pointer_type: numericCast(DW_TAG_pointer_type)
        case .reference_type: numericCast(DW_TAG_reference_type)
        case .compile_unit: numericCast(DW_TAG_compile_unit)
        case .string_type: numericCast(DW_TAG_string_type)
        case .structure_type: numericCast(DW_TAG_structure_type)
        case .subroutine_type: numericCast(DW_TAG_subroutine_type)
        case .typedef: numericCast(DW_TAG_typedef)
        case .union_type: numericCast(DW_TAG_union_type)
        case .unspecified_parameters: numericCast(DW_TAG_unspecified_parameters)
        case .variant: numericCast(DW_TAG_variant)
        case .common_block: numericCast(DW_TAG_common_block)
        case .common_inclusion: numericCast(DW_TAG_common_inclusion)
        case .inheritance: numericCast(DW_TAG_inheritance)
        case .inlined_subroutine: numericCast(DW_TAG_inlined_subroutine)
        case .module: numericCast(DW_TAG_module)
        case .ptr_to_member_type: numericCast(DW_TAG_ptr_to_member_type)
        case .set_type: numericCast(DW_TAG_set_type)
        case .subrange_type: numericCast(DW_TAG_subrange_type)
        case .with_stmt: numericCast(DW_TAG_with_stmt)
        case .access_declaration: numericCast(DW_TAG_access_declaration)
        case .base_type: numericCast(DW_TAG_base_type)
        case .catch_block: numericCast(DW_TAG_catch_block)
        case .const_type: numericCast(DW_TAG_const_type)
        case .constant: numericCast(DW_TAG_constant)
        case .enumerator: numericCast(DW_TAG_enumerator)
        case .file_type: numericCast(DW_TAG_file_type)
        case .friend: numericCast(DW_TAG_friend)
        case .namelist: numericCast(DW_TAG_namelist)
        case .namelist_item: numericCast(DW_TAG_namelist_item)
        case .packed_type: numericCast(DW_TAG_packed_type)
        case .subprogram: numericCast(DW_TAG_subprogram)
        case .template_type_parameter: numericCast(DW_TAG_template_type_parameter)
        case .template_value_parameter: numericCast(DW_TAG_template_value_parameter)
        case .thrown_type: numericCast(DW_TAG_thrown_type)
        case .try_block: numericCast(DW_TAG_try_block)
        case .variant_part: numericCast(DW_TAG_variant_part)
        case .variable: numericCast(DW_TAG_variable)
        case .volatile_type: numericCast(DW_TAG_volatile_type)
        case .dwarf_procedure: numericCast(DW_TAG_dwarf_procedure)
        case .restrict_type: numericCast(DW_TAG_restrict_type)
        case .interface_type: numericCast(DW_TAG_interface_type)
        case .namespace: numericCast(DW_TAG_namespace)
        case .imported_module: numericCast(DW_TAG_imported_module)
        case .unspecified_type: numericCast(DW_TAG_unspecified_type)
        case .partial_unit: numericCast(DW_TAG_partial_unit)
        case .imported_unit: numericCast(DW_TAG_imported_unit)
        case .mutable_type: numericCast(DW_TAG_mutable_type)
        case .condition: numericCast(DW_TAG_condition)
        case .shared_type: numericCast(DW_TAG_shared_type)
        case .type_unit: numericCast(DW_TAG_type_unit)
        case .rvalue_reference_type: numericCast(DW_TAG_rvalue_reference_type)
        case .template_alias: numericCast(DW_TAG_template_alias)
        case .coarray_type: numericCast(DW_TAG_coarray_type)
        case .generic_subrange: numericCast(DW_TAG_generic_subrange)
        case .dynamic_type: numericCast(DW_TAG_dynamic_type)
        case .atomic_type: numericCast(DW_TAG_atomic_type)
        case .call_site: numericCast(DW_TAG_call_site)
        case .call_site_parameter: numericCast(DW_TAG_call_site_parameter)
        case .skeleton_unit: numericCast(DW_TAG_skeleton_unit)
        case .immutable_type: numericCast(DW_TAG_immutable_type)
        case .ti_far_type: numericCast(DW_TAG_TI_far_type)
//        case .lo_user: numericCast(DW_TAG_lo_user)
        case .mips_loop: numericCast(DW_TAG_MIPS_loop)
        case .ti_near_type: numericCast(DW_TAG_TI_near_type)
        case .ti_assign_register: numericCast(DW_TAG_TI_assign_register)
        case .ti_ioport_type: numericCast(DW_TAG_TI_ioport_type)
        case .ti_restrict_type: numericCast(DW_TAG_TI_restrict_type)
        case .ti_onchip_type: numericCast(DW_TAG_TI_onchip_type)
        case .hp_array_descriptor: numericCast(DW_TAG_HP_array_descriptor)
        case .format_label: numericCast(DW_TAG_format_label)
        case .function_template: numericCast(DW_TAG_function_template)
        case .class_template: numericCast(DW_TAG_class_template)
        case .gnu_bincl: numericCast(DW_TAG_GNU_BINCL)
        case .gnu_eincl: numericCast(DW_TAG_GNU_EINCL)
        case .gnu_template_template_parameter: numericCast(DW_TAG_GNU_template_template_parameter)
        case .gnu_template_template_param: numericCast(DW_TAG_GNU_template_template_param)
        case .gnu_template_parameter_pack: numericCast(DW_TAG_GNU_template_parameter_pack)
        case .gnu_formal_parameter_pack: numericCast(DW_TAG_GNU_formal_parameter_pack)
        case .gnu_call_site: numericCast(DW_TAG_GNU_call_site)
        case .gnu_call_site_parameter: numericCast(DW_TAG_GNU_call_site_parameter)
        case .apple_property: numericCast(DW_TAG_APPLE_property)
        case .sun_function_template: numericCast(DW_TAG_SUN_function_template)
        case .sun_class_template: numericCast(DW_TAG_SUN_class_template)
        case .sun_struct_template: numericCast(DW_TAG_SUN_struct_template)
        case .sun_union_template: numericCast(DW_TAG_SUN_union_template)
        case .sun_indirect_inheritance: numericCast(DW_TAG_SUN_indirect_inheritance)
        case .sun_codeflags: numericCast(DW_TAG_SUN_codeflags)
        case .sun_memop_info: numericCast(DW_TAG_SUN_memop_info)
        case .sun_omp_child_func: numericCast(DW_TAG_SUN_omp_child_func)
        case .sun_rtti_descriptor: numericCast(DW_TAG_SUN_rtti_descriptor)
        case .sun_dtor_info: numericCast(DW_TAG_SUN_dtor_info)
        case .sun_dtor: numericCast(DW_TAG_SUN_dtor)
        case .sun_f90_interface: numericCast(DW_TAG_SUN_f90_interface)
        case .sun_fortran_vax_structure: numericCast(DW_TAG_SUN_fortran_vax_structure)
//        case .sun_hi: numericCast(DW_TAG_SUN_hi)
        case .llvm_ptrauth_type: numericCast(DW_TAG_LLVM_ptrauth_type)
        case .altium_circ_type: numericCast(DW_TAG_ALTIUM_circ_type)
        case .altium_mwa_circ_type: numericCast(DW_TAG_ALTIUM_mwa_circ_type)
        case .altium_rev_carry_type: numericCast(DW_TAG_ALTIUM_rev_carry_type)
        case .altium_rom: numericCast(DW_TAG_ALTIUM_rom)
        case .llvm_annotation: numericCast(DW_TAG_LLVM_annotation)
        case .ghs_namespace: numericCast(DW_TAG_ghs_namespace)
        case .ghs_using_namespace: numericCast(DW_TAG_ghs_using_namespace)
        case .ghs_using_declaration: numericCast(DW_TAG_ghs_using_declaration)
        case .ghs_template_templ_param: numericCast(DW_TAG_ghs_template_templ_param)
        case .upc_shared_type: numericCast(DW_TAG_upc_shared_type)
        case .upc_strict_type: numericCast(DW_TAG_upc_strict_type)
        case .upc_relaxed_type: numericCast(DW_TAG_upc_relaxed_type)
        case .upc_relaxed: numericCast(DW_TAG_UPC_relaxed)
        case .pgi_kanji_type: numericCast(DW_TAG_PGI_kanji_type)
        case .pgi_interface_block: numericCast(DW_TAG_PGI_interface_block)
        case .borland_property: numericCast(DW_TAG_BORLAND_property)
        case .borland_delphi_string: numericCast(DW_TAG_BORLAND_Delphi_string)
        case .borland_delphi_dynamic_array: numericCast(DW_TAG_BORLAND_Delphi_dynamic_array)
        case .borland_delphi_set: numericCast(DW_TAG_BORLAND_Delphi_set)
        case .borland_delphi_variant: numericCast(DW_TAG_BORLAND_Delphi_variant)
//        case .hi_user: numericCast(DW_TAG_hi_user)
        }
    }
}

extension DWARFTag: CustomStringConvertible {
    public var description: String {
        switch self {
        case .null: "DW_TAG_null"
        case .array_type: "DW_TAG_array_type"
        case .class_type: "DW_TAG_class_type"
        case .entry_point: "DW_TAG_entry_point"
        case .enumeration_type: "DW_TAG_enumeration_type"
        case .formal_parameter: "DW_TAG_formal_parameter"
        case .imported_declaration: "DW_TAG_imported_declaration"
        case .label: "DW_TAG_label"
        case .lexical_block: "DW_TAG_lexical_block"
        case .member: "DW_TAG_member"
        case .pointer_type: "DW_TAG_pointer_type"
        case .reference_type: "DW_TAG_reference_type"
        case .compile_unit: "DW_TAG_compile_unit"
        case .string_type: "DW_TAG_string_type"
        case .structure_type: "DW_TAG_structure_type"
        case .subroutine_type: "DW_TAG_subroutine_type"
        case .typedef: "DW_TAG_typedef"
        case .union_type: "DW_TAG_union_type"
        case .unspecified_parameters: "DW_TAG_unspecified_parameters"
        case .variant: "DW_TAG_variant"
        case .common_block: "DW_TAG_common_block"
        case .common_inclusion: "DW_TAG_common_inclusion"
        case .inheritance: "DW_TAG_inheritance"
        case .inlined_subroutine: "DW_TAG_inlined_subroutine"
        case .module: "DW_TAG_module"
        case .ptr_to_member_type: "DW_TAG_ptr_to_member_type"
        case .set_type: "DW_TAG_set_type"
        case .subrange_type: "DW_TAG_subrange_type"
        case .with_stmt: "DW_TAG_with_stmt"
        case .access_declaration: "DW_TAG_access_declaration"
        case .base_type: "DW_TAG_base_type"
        case .catch_block: "DW_TAG_catch_block"
        case .const_type: "DW_TAG_const_type"
        case .constant: "DW_TAG_constant"
        case .enumerator: "DW_TAG_enumerator"
        case .file_type: "DW_TAG_file_type"
        case .friend: "DW_TAG_friend"
        case .namelist: "DW_TAG_namelist"
        case .namelist_item: "DW_TAG_namelist_item"
        case .packed_type: "DW_TAG_packed_type"
        case .subprogram: "DW_TAG_subprogram"
        case .template_type_parameter: "DW_TAG_template_type_parameter"
        case .template_value_parameter: "DW_TAG_template_value_parameter"
        case .thrown_type: "DW_TAG_thrown_type"
        case .try_block: "DW_TAG_try_block"
        case .variant_part: "DW_TAG_variant_part"
        case .variable: "DW_TAG_variable"
        case .volatile_type: "DW_TAG_volatile_type"
        case .dwarf_procedure: "DW_TAG_dwarf_procedure"
        case .restrict_type: "DW_TAG_restrict_type"
        case .interface_type: "DW_TAG_interface_type"
        case .namespace: "DW_TAG_namespace"
        case .imported_module: "DW_TAG_imported_module"
        case .unspecified_type: "DW_TAG_unspecified_type"
        case .partial_unit: "DW_TAG_partial_unit"
        case .imported_unit: "DW_TAG_imported_unit"
        case .mutable_type: "DW_TAG_mutable_type"
        case .condition: "DW_TAG_condition"
        case .shared_type: "DW_TAG_shared_type"
        case .type_unit: "DW_TAG_type_unit"
        case .rvalue_reference_type: "DW_TAG_rvalue_reference_type"
        case .template_alias: "DW_TAG_template_alias"
        case .coarray_type: "DW_TAG_coarray_type"
        case .generic_subrange: "DW_TAG_generic_subrange"
        case .dynamic_type: "DW_TAG_dynamic_type"
        case .atomic_type: "DW_TAG_atomic_type"
        case .call_site: "DW_TAG_call_site"
        case .call_site_parameter: "DW_TAG_call_site_parameter"
        case .skeleton_unit: "DW_TAG_skeleton_unit"
        case .immutable_type: "DW_TAG_immutable_type"
        case .ti_far_type: "DW_TAG_TI_far_type"
//        case .lo_user: "DW_TAG_lo_user"
        case .mips_loop: "DW_TAG_MIPS_loop"
        case .ti_near_type: "DW_TAG_TI_near_type"
        case .ti_assign_register: "DW_TAG_TI_assign_register"
        case .ti_ioport_type: "DW_TAG_TI_ioport_type"
        case .ti_restrict_type: "DW_TAG_TI_restrict_type"
        case .ti_onchip_type: "DW_TAG_TI_onchip_type"
        case .hp_array_descriptor: "DW_TAG_HP_array_descriptor"
        case .format_label: "DW_TAG_format_label"
        case .function_template: "DW_TAG_function_template"
        case .class_template: "DW_TAG_class_template"
        case .gnu_bincl: "DW_TAG_GNU_BINCL"
        case .gnu_eincl: "DW_TAG_GNU_EINCL"
        case .gnu_template_template_parameter: "DW_TAG_GNU_template_template_parameter"
        case .gnu_template_template_param: "DW_TAG_GNU_template_template_param"
        case .gnu_template_parameter_pack: "DW_TAG_GNU_template_parameter_pack"
        case .gnu_formal_parameter_pack: "DW_TAG_GNU_formal_parameter_pack"
        case .gnu_call_site: "DW_TAG_GNU_call_site"
        case .gnu_call_site_parameter: "DW_TAG_GNU_call_site_parameter"
        case .apple_property: "DW_TAG_APPLE_property"
        case .sun_function_template: "DW_TAG_SUN_function_template"
        case .sun_class_template: "DW_TAG_SUN_class_template"
        case .sun_struct_template: "DW_TAG_SUN_struct_template"
        case .sun_union_template: "DW_TAG_SUN_union_template"
        case .sun_indirect_inheritance: "DW_TAG_SUN_indirect_inheritance"
        case .sun_codeflags: "DW_TAG_SUN_codeflags"
        case .sun_memop_info: "DW_TAG_SUN_memop_info"
        case .sun_omp_child_func: "DW_TAG_SUN_omp_child_func"
        case .sun_rtti_descriptor: "DW_TAG_SUN_rtti_descriptor"
        case .sun_dtor_info: "DW_TAG_SUN_dtor_info"
        case .sun_dtor: "DW_TAG_SUN_dtor"
        case .sun_f90_interface: "DW_TAG_SUN_f90_interface"
        case .sun_fortran_vax_structure: "DW_TAG_SUN_fortran_vax_structure"
//        case .sun_hi: "DW_TAG_SUN_hi"
        case .llvm_ptrauth_type: "DW_TAG_LLVM_ptrauth_type"
        case .altium_circ_type: "DW_TAG_ALTIUM_circ_type"
        case .altium_mwa_circ_type: "DW_TAG_ALTIUM_mwa_circ_type"
        case .altium_rev_carry_type: "DW_TAG_ALTIUM_rev_carry_type"
        case .altium_rom: "DW_TAG_ALTIUM_rom"
        case .llvm_annotation: "DW_TAG_LLVM_annotation"
        case .ghs_namespace: "DW_TAG_ghs_namespace"
        case .ghs_using_namespace: "DW_TAG_ghs_using_namespace"
        case .ghs_using_declaration: "DW_TAG_ghs_using_declaration"
        case .ghs_template_templ_param: "DW_TAG_ghs_template_templ_param"
        case .upc_shared_type: "DW_TAG_upc_shared_type"
        case .upc_strict_type: "DW_TAG_upc_strict_type"
        case .upc_relaxed_type: "DW_TAG_upc_relaxed_type"
        case .upc_relaxed: "DW_TAG_UPC_relaxed"
        case .pgi_kanji_type: "DW_TAG_PGI_kanji_type"
        case .pgi_interface_block: "DW_TAG_PGI_interface_block"
        case .borland_property: "DW_TAG_BORLAND_property"
        case .borland_delphi_string: "DW_TAG_BORLAND_Delphi_string"
        case .borland_delphi_dynamic_array: "DW_TAG_BORLAND_Delphi_dynamic_array"
        case .borland_delphi_set: "DW_TAG_BORLAND_Delphi_set"
        case .borland_delphi_variant: "DW_TAG_BORLAND_Delphi_variant"
//        case .hi_user: "DW_TAG_hi_user"
        }
    }
}
