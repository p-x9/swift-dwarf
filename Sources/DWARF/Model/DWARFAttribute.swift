//
//  DWARFAttribute.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/04/04
//  
//

import Foundation
import DWARFC

public enum DWARFAttribute: CaseIterable {
    /// DW_AT_sibling
    case sibling
    /// DW_AT_location
    case location
    /// DW_AT_name
    case name
    /// DW_AT_ordering
    case ordering
    /// DW_AT_subscr_data
    case subscr_data
    /// DW_AT_byte_size
    case byte_size
    /// DW_AT_bit_offset
    case bit_offset
    /// DW_AT_bit_size
    case bit_size
    /// DW_AT_element_list
    case element_list
    /// DW_AT_stmt_list
    case stmt_list
    /// DW_AT_low_pc
    case low_pc
    /// DW_AT_high_pc
    case high_pc
    /// DW_AT_language
    case language
    /// DW_AT_member
    case member
    /// DW_AT_discr
    case discr
    /// DW_AT_discr_value
    case discr_value
    /// DW_AT_visibility
    case visibility
    /// DW_AT_import
    case `import`
    /// DW_AT_string_length
    case string_length
    /// DW_AT_common_reference
    case common_reference
    /// DW_AT_comp_dir
    case comp_dir
    /// DW_AT_const_value
    case const_value
    /// DW_AT_containing_type
    case containing_type
    /// DW_AT_default_value
    case default_value
    /// DW_AT_inline
    case inline
    /// DW_AT_is_optional
    case is_optional
    /// DW_AT_lower_bound
    case lower_bound
    /// DW_AT_producer
    case producer
    /// DW_AT_prototyped
    case prototyped
    /// DW_AT_return_addr
    case return_addr
    /// DW_AT_start_scope
    case start_scope
    /// DW_AT_bit_stride
    case bit_stride
    /// DW_AT_stride_size
    case stride_size
    /// DW_AT_upper_bound
    case upper_bound
    /// DW_AT_abstract_origin
    case abstract_origin
    /// DW_AT_accessibility
    case accessibility
    /// DW_AT_address_class
    case address_class
    /// DW_AT_artificial
    case artificial
    /// DW_AT_base_types
    case base_types
    /// DW_AT_calling_convention
    case calling_convention
    /// DW_AT_count
    case count
    /// DW_AT_data_member_location
    case data_member_location
    /// DW_AT_decl_column
    case decl_column
    /// DW_AT_decl_file
    case decl_file
    /// DW_AT_decl_line
    case decl_line
    /// DW_AT_declaration
    case declaration
    /// DW_AT_discr_list
    case discr_list
    /// DW_AT_encoding
    case encoding
    /// DW_AT_external
    case external
    /// DW_AT_frame_base
    case frame_base
    /// DW_AT_friend
    case friend
    /// DW_AT_identifier_case
    case identifier_case
    /// DW_AT_macro_info
    case macro_info
    /// DW_AT_namelist_item
    case namelist_item
    /// DW_AT_priority
    case priority
    /// DW_AT_segment
    case segment
    /// DW_AT_specification
    case specification
    /// DW_AT_static_link
    case static_link
    /// DW_AT_type
    case type
    /// DW_AT_use_location
    case use_location
    /// DW_AT_variable_parameter
    case variable_parameter
    /// DW_AT_virtuality
    case virtuality
    /// DW_AT_vtable_elem_location
    case vtable_elem_location
    /// DW_AT_allocated
    case allocated
    /// DW_AT_associated
    case associated
    /// DW_AT_data_location
    case data_location
    /// DW_AT_byte_stride
    case byte_stride
    /// DW_AT_stride
    case stride
    /// DW_AT_entry_pc
    case entry_pc
    /// DW_AT_use_UTF8
    case use_utf8
    /// DW_AT_extension
    case `extension`
    /// DW_AT_ranges
    case ranges
    /// DW_AT_trampoline
    case trampoline
    /// DW_AT_call_column
    case call_column
    /// DW_AT_call_file
    case call_file
    /// DW_AT_call_line
    case call_line
    /// DW_AT_description
    case description
    /// DW_AT_binary_scale
    case binary_scale
    /// DW_AT_decimal_scale
    case decimal_scale
    /// DW_AT_small
    case small
    /// DW_AT_decimal_sign
    case decimal_sign
    /// DW_AT_digit_count
    case digit_count
    /// DW_AT_picture_string
    case picture_string
    /// DW_AT_mutable
    case mutable
    /// DW_AT_threads_scaled
    case threads_scaled
    /// DW_AT_explicit
    case explicit
    /// DW_AT_object_pointer
    case object_pointer
    /// DW_AT_endianity
    case endianity
    /// DW_AT_elemental
    case elemental
    /// DW_AT_pure
    case pure
    /// DW_AT_recursive
    case recursive
    /// DW_AT_signature
    case signature
    /// DW_AT_main_subprogram
    case main_subprogram
    /// DW_AT_data_bit_offset
    case data_bit_offset
    /// DW_AT_const_expr
    case const_expr
    /// DW_AT_enum_class
    case enum_class
    /// DW_AT_linkage_name
    case linkage_name
    /// DW_AT_string_length_bit_size
    case string_length_bit_size
    /// DW_AT_string_length_byte_size
    case string_length_byte_size
    /// DW_AT_rank
    case rank
    /// DW_AT_str_offsets_base
    case str_offsets_base
    /// DW_AT_addr_base
    case addr_base
    /// DW_AT_rnglists_base
    case rnglists_base
    /// DW_AT_dwo_id
    case dwo_id
    /// DW_AT_dwo_name
    case dwo_name
    /// DW_AT_reference
    case reference
    /// DW_AT_rvalue_reference
    case rvalue_reference
    /// DW_AT_macros
    case macros
    /// DW_AT_call_all_calls
    case call_all_calls
    /// DW_AT_call_all_source_calls
    case call_all_source_calls
    /// DW_AT_call_all_tail_calls
    case call_all_tail_calls
    /// DW_AT_call_return_pc
    case call_return_pc
    /// DW_AT_call_value
    case call_value
    /// DW_AT_call_origin
    case call_origin
    /// DW_AT_call_parameter
    case call_parameter
    /// DW_AT_call_pc
    case call_pc
    /// DW_AT_call_tail_call
    case call_tail_call
    /// DW_AT_call_target
    case call_target
    /// DW_AT_call_target_clobbered
    case call_target_clobbered
    /// DW_AT_call_data_location
    case call_data_location
    /// DW_AT_call_data_value
    case call_data_value
    /// DW_AT_noreturn
    case noreturn
    /// DW_AT_alignment
    case alignment
    /// DW_AT_export_symbols
    case export_symbols
    /// DW_AT_deleted
    case deleted
    /// DW_AT_defaulted
    case defaulted
    /// DW_AT_loclists_base
    case loclists_base
    /// DW_AT_language_name
    case language_name
    /// DW_AT_language_version
    case language_version
    /// DW_AT_ghs_namespace_alias
    case ghs_namespace_alias
    /// DW_AT_ghs_using_namespace
    case ghs_using_namespace
    /// DW_AT_ghs_using_declaration
    case ghs_using_declaration
    /// DW_AT_HP_block_index
    case hp_block_index
    /// DW_AT_lo_user
//    case lo_user
    /// DW_AT_TI_veneer
    case ti_veneer
    /// DW_AT_MIPS_fde
    case mips_fde
    /// DW_AT_TI_symbol_name
    case ti_symbol_name
    /// DW_AT_HP_unmodifiable
//    case hp_unmodifiable
    /// DW_AT_CPQ_discontig_ranges
//    case cpq_discontig_ranges
    /// DW_AT_MIPS_loop_begin
    case mips_loop_begin
    /// DW_AT_CPQ_semantic_events
//    case cpq_semantic_events
    /// DW_AT_MIPS_tail_loop_begin
    case mips_tail_loop_begin
    /// DW_AT_CPQ_split_lifetimes_var
//    case cpq_split_lifetimes_var
    /// DW_AT_MIPS_epilog_begin
    case mips_epilog_begin
    /// DW_AT_CPQ_split_lifetimes_rtn
//    case cpq_split_lifetimes_rtn
    /// DW_AT_MIPS_loop_unroll_factor
    case mips_loop_unroll_factor
    /// DW_AT_HP_prologue
//    case hp_prologue
    /// DW_AT_CPQ_prologue_length
//    case cpq_prologue_length
    /// DW_AT_MIPS_software_pipeline_depth
    case mips_software_pipeline_depth
    /// DW_AT_MIPS_linkage_name
    case mips_linkage_name
    /// DW_AT_ghs_mangled
//    case ghs_mangled
    /// DW_AT_MIPS_stride
    case mips_stride
    /// DW_AT_HP_epilogue
//    case hp_epilogue
    /// DW_AT_MIPS_abstract_name
    case mips_abstract_name
    /// DW_AT_MIPS_clone_origin
    case mips_clone_origin
    /// DW_AT_MIPS_has_inlines
    case mips_has_inlines
    /// DW_AT_TI_version
    case ti_version
    /// DW_AT_MIPS_stride_byte
    case mips_stride_byte
    /// DW_AT_TI_asm
    case ti_asm
    /// DW_AT_MIPS_stride_elem
    case mips_stride_elem
    /// DW_AT_MIPS_ptr_dopetype
    case mips_ptr_dopetype
    /// DW_AT_TI_skeletal
    case ti_skeletal
    /// DW_AT_MIPS_allocatable_dopetype
    case mips_allocatable_dopetype
    /// DW_AT_MIPS_assumed_shape_dopetype
    case mips_assumed_shape_dopetype
    /// DW_AT_HP_actuals_stmt_list
//    case hp_actuals_stmt_list
    /// DW_AT_MIPS_assumed_size
    case mips_assumed_size
    /// DW_AT_TI_interrupt
    case ti_interrupt
    /// DW_AT_HP_proc_per_section
//    case hp_proc_per_section
    /// DW_AT_HP_raw_data_ptr
    case hp_raw_data_ptr
    /// DW_AT_HP_pass_by_reference
    case hp_pass_by_reference
    /// DW_AT_HP_opt_level
    case hp_opt_level
    /// DW_AT_HP_prof_version_id
    case hp_prof_version_id
    /// DW_AT_HP_opt_flags
    case hp_opt_flags
    /// DW_AT_HP_cold_region_low_pc
    case hp_cold_region_low_pc
    /// DW_AT_HP_cold_region_high_pc
    case hp_cold_region_high_pc
    /// DW_AT_HP_all_variables_modifiable
    case hp_all_variables_modifiable
    /// DW_AT_HP_linkage_name
    case hp_linkage_name
    /// DW_AT_HP_prof_flags
    case hp_prof_flags
    /// DW_AT_HP_unit_name
    case hp_unit_name
    /// DW_AT_HP_unit_size
    case hp_unit_size
    /// DW_AT_HP_widened_byte_size
    case hp_widened_byte_size
    /// DW_AT_HP_definition_points
    case hp_definition_points
    /// DW_AT_HP_default_location
    case hp_default_location
    /// DW_AT_INTEL_other_endian
    case intel_other_endian
    /// DW_AT_HP_is_result_param
    case hp_is_result_param
    /// DW_AT_ghs_rsm
    case ghs_rsm
    /// DW_AT_ghs_frsm
    case ghs_frsm
    /// DW_AT_ghs_frames
    case ghs_frames
    /// DW_AT_ghs_rso
    case ghs_rso
    /// DW_AT_ghs_subcpu
    case ghs_subcpu
    /// DW_AT_ghs_lbrace_line
    case ghs_lbrace_line
    /// DW_AT_sf_names
    case sf_names
    /// DW_AT_src_info
    case src_info
    /// DW_AT_mac_info
    case mac_info
    /// DW_AT_src_coords
    case src_coords
    /// DW_AT_body_begin
    case body_begin
    /// DW_AT_body_end
    case body_end
    /// DW_AT_GNU_vector
    case gnu_vector
    /// DW_AT_GNU_guarded_by
    case gnu_guarded_by
    /// DW_AT_GNU_pt_guarded_by
    case gnu_pt_guarded_by
    /// DW_AT_GNU_guarded
    case gnu_guarded
    /// DW_AT_GNU_pt_guarded
    case gnu_pt_guarded
    /// DW_AT_GNU_locks_excluded
    case gnu_locks_excluded
    /// DW_AT_GNU_exclusive_locks_required
    case gnu_exclusive_locks_required
    /// DW_AT_GNU_shared_locks_required
    case gnu_shared_locks_required
    /// DW_AT_GNU_odr_signature
    case gnu_odr_signature
    /// DW_AT_GNU_template_name
    case gnu_template_name
    /// DW_AT_GNU_call_site_value
    case gnu_call_site_value
    /// DW_AT_GNU_call_site_data_value
    case gnu_call_site_data_value
    /// DW_AT_GNU_call_site_target
    case gnu_call_site_target
    /// DW_AT_GNU_call_site_target_clobbered
    case gnu_call_site_target_clobbered
    /// DW_AT_GNU_tail_call
    case gnu_tail_call
    /// DW_AT_GNU_all_tail_call_sites
    case gnu_all_tail_call_sites
    /// DW_AT_GNU_all_call_sites
    case gnu_all_call_sites
    /// DW_AT_GNU_all_source_call_sites
    case gnu_all_source_call_sites
    /// DW_AT_GNU_macros
    case gnu_macros
    /// DW_AT_GNU_deleted
    case gnu_deleted
    /// DW_AT_GNU_dwo_name
    case gnu_dwo_name
    /// DW_AT_GNU_dwo_id
    case gnu_dwo_id
    /// DW_AT_GNU_ranges_base
    case gnu_ranges_base
    /// DW_AT_GNU_addr_base
    case gnu_addr_base
    /// DW_AT_GNU_pubnames
    case gnu_pubnames
    /// DW_AT_GNU_pubtypes
    case gnu_pubtypes
    /// DW_AT_GNU_discriminator
    case gnu_discriminator
    /// DW_AT_GNU_locviews
    case gnu_locviews
    /// DW_AT_GNU_entry_view
    case gnu_entry_view
    /// DW_AT_SUN_template
    case sun_template
    /// DW_AT_VMS_rtnbeg_pd_address
    case vms_rtnbeg_pd_address
    /// DW_AT_SUN_alignment
    case sun_alignment
    /// DW_AT_SUN_vtable
    case sun_vtable
    /// DW_AT_SUN_count_guarantee
    case sun_count_guarantee
    /// DW_AT_SUN_command_line
    case sun_command_line
    /// DW_AT_SUN_vbase
    case sun_vbase
    /// DW_AT_SUN_compile_options
    case sun_compile_options
    /// DW_AT_SUN_language
    case sun_language
    /// DW_AT_SUN_browser_file
    case sun_browser_file
    /// DW_AT_SUN_vtable_abi
    case sun_vtable_abi
    /// DW_AT_SUN_func_offsets
    case sun_func_offsets
    /// DW_AT_SUN_cf_kind
    case sun_cf_kind
    /// DW_AT_SUN_vtable_index
    case sun_vtable_index
    /// DW_AT_SUN_omp_tpriv_addr
    case sun_omp_tpriv_addr
    /// DW_AT_SUN_omp_child_func
    case sun_omp_child_func
    /// DW_AT_SUN_func_offset
    case sun_func_offset
    /// DW_AT_SUN_memop_type_ref
    case sun_memop_type_ref
    /// DW_AT_SUN_profile_id
    case sun_profile_id
    /// DW_AT_SUN_memop_signature
    case sun_memop_signature
    /// DW_AT_SUN_obj_dir
    case sun_obj_dir
    /// DW_AT_SUN_obj_file
    case sun_obj_file
    /// DW_AT_SUN_original_name
    case sun_original_name
    /// DW_AT_SUN_hwcprof_signature
    case sun_hwcprof_signature
    /// DW_AT_SUN_amd64_parmdump
    case sun_amd64_parmdump
    /// DW_AT_SUN_part_link_name
    case sun_part_link_name
    /// DW_AT_SUN_link_name
    case sun_link_name
    /// DW_AT_SUN_pass_with_const
    case sun_pass_with_const
    /// DW_AT_SUN_return_with_const
    case sun_return_with_const
    /// DW_AT_SUN_import_by_name
    case sun_import_by_name
    /// DW_AT_SUN_f90_pointer
    case sun_f90_pointer
    /// DW_AT_SUN_90_pointer
    case sun_90_pointer
    /// DW_AT_SUN_pass_by_ref
    case sun_pass_by_ref
    /// DW_AT_SUN_f90_allocatable
    case sun_f90_allocatable
    /// DW_AT_SUN_f90_assumed_shape_array
    case sun_f90_assumed_shape_array
    /// DW_AT_SUN_c_vla
    case sun_c_vla
    /// DW_AT_SUN_return_value_ptr
    case sun_return_value_ptr
    /// DW_AT_SUN_dtor_start
    case sun_dtor_start
    /// DW_AT_SUN_dtor_length
    case sun_dtor_length
    /// DW_AT_SUN_dtor_state_initial
    case sun_dtor_state_initial
    /// DW_AT_SUN_dtor_state_final
    case sun_dtor_state_final
    /// DW_AT_SUN_dtor_state_deltas
    case sun_dtor_state_deltas
    /// DW_AT_SUN_import_by_lname
    case sun_import_by_lname
    /// DW_AT_SUN_f90_use_only
    case sun_f90_use_only
    /// DW_AT_SUN_namelist_spec
    case sun_namelist_spec
    /// DW_AT_SUN_is_omp_child_func
    case sun_is_omp_child_func
    /// DW_AT_SUN_fortran_main_alias
    case sun_fortran_main_alias
    /// DW_AT_SUN_fortran_based
    case sun_fortran_based
    /// DW_AT_ALTIUM_loclist
    case altium_loclist
    /// DW_AT_use_GNAT_descriptive_type
    case use_gnat_descriptive_type
    /// DW_AT_GNAT_descriptive_type
    case gnat_descriptive_type
    /// DW_AT_GNU_numerator
    case gnu_numerator
    /// DW_AT_GNU_denominator
    case gnu_denominator
    /// DW_AT_GNU_bias
    case gnu_bias
    /// DW_AT_go_kind
    case go_kind
    /// DW_AT_go_key
    case go_key
    /// DW_AT_go_elem
    case go_elem
    /// DW_AT_go_embedded_field
    case go_embedded_field
    /// DW_AT_go_runtime_type
    case go_runtime_type
    /// DW_AT_upc_threads_scaled
    case upc_threads_scaled
    /// DW_AT_IBM_wsa_addr
    case ibm_wsa_addr
    /// DW_AT_IBM_home_location
    case ibm_home_location
    /// DW_AT_IBM_alt_srcview
    case ibm_alt_srcview
    /// DW_AT_PGI_lbase
    case pgi_lbase
    /// DW_AT_PGI_soffset
    case pgi_soffset
    /// DW_AT_PGI_lstride
    case pgi_lstride
    /// DW_AT_BORLAND_property_read
    case borland_property_read
    /// DW_AT_BORLAND_property_write
    case borland_property_write
    /// DW_AT_BORLAND_property_implements
    case borland_property_implements
    /// DW_AT_BORLAND_property_index
    case borland_property_index
    /// DW_AT_BORLAND_property_default
    case borland_property_default
    /// DW_AT_BORLAND_Delphi_unit
    case borland_delphi_unit
    /// DW_AT_BORLAND_Delphi_class
    case borland_delphi_class
    /// DW_AT_BORLAND_Delphi_record
    case borland_delphi_record
    /// DW_AT_BORLAND_Delphi_metaclass
    case borland_delphi_metaclass
    /// DW_AT_BORLAND_Delphi_constructor
    case borland_delphi_constructor
    /// DW_AT_BORLAND_Delphi_destructor
    case borland_delphi_destructor
    /// DW_AT_BORLAND_Delphi_anonymous_method
    case borland_delphi_anonymous_method
    /// DW_AT_BORLAND_Delphi_interface
    case borland_delphi_interface
    /// DW_AT_BORLAND_Delphi_ABI
    case borland_delphi_abi
    /// DW_AT_BORLAND_Delphi_return
    case borland_delphi_return
    /// DW_AT_BORLAND_Delphi_frameptr
    case borland_delphi_frameptr
    /// DW_AT_BORLAND_closure
    case borland_closure
    /// DW_AT_LLVM_include_path
    case llvm_include_path
    /// DW_AT_LLVM_config_macros
    case llvm_config_macros
    /// DW_AT_LLVM_sysroot
    case llvm_sysroot
    /// DW_AT_LLVM_tag_offset
    case llvm_tag_offset
    /// DW_AT_LLVM_ptrauth_key
    case llvm_ptrauth_key
    /// DW_AT_LLVM_ptrauth_address_discriminated
    case llvm_ptrauth_address_discriminated
    /// DW_AT_LLVM_ptrauth_extra_discriminator
    case llvm_ptrauth_extra_discriminator
    /// DW_AT_LLVM_apinotes
    case llvm_apinotes
    /// DW_AT_LLVM_active_lane
    case llvm_active_lane
    /// DW_AT_LLVM_ptrauth_isa_pointer
    case llvm_ptrauth_isa_pointer
    /// DW_AT_LLVM_augmentation
    case llvm_augmentation
    /// DW_AT_LLVM_ptrauth_authenticates_null_values
    case llvm_ptrauth_authenticates_null_values
    /// DW_AT_LLVM_lanes
    case llvm_lanes
    /// DW_AT_LLVM_ptrauth_authentication_mode
    case llvm_ptrauth_authentication_mode
    /// DW_AT_LLVM_lane_pc
    case llvm_lane_pc
    /// DW_AT_LLVM_num_extra_inhabitants
    case llvm_num_extra_inhabitants
    /// DW_AT_LLVM_vector_size
    case llvm_vector_size
    /// DW_AT_LLVM_stmt_sequence
    case llvm_stmt_sequence
    /// DW_AT_APPLE_optimized
    case apple_optimized
    /// DW_AT_APPLE_flags
    case apple_flags
    /// DW_AT_APPLE_isa
    case apple_isa
    /// DW_AT_APPLE_block
    case apple_block
    /// DW_AT_APPLE_major_runtime_vers
    case apple_major_runtime_vers
    /// DW_AT_APPLE_runtime_class
    case apple_runtime_class
    /// DW_AT_APPLE_omit_frame_ptr
    case apple_omit_frame_ptr
    /// DW_AT_APPLE_property_name
    case apple_property_name
    /// DW_AT_APPLE_property_getter
    case apple_property_getter
    /// DW_AT_APPLE_property_setter
    case apple_property_setter
    /// DW_AT_APPLE_property_attribute
    case apple_property_attribute
    /// DW_AT_APPLE_objc_complete_type
    case apple_objc_complete_type
    /// DW_AT_APPLE_property
    case apple_property
    /// DW_AT_APPLE_objc_direct
    case apple_objc_direct
    /// DW_AT_APPLE_sdk
    case apple_sdk
    /// DW_AT_APPLE_origin
    case apple_origin
    /// DW_AT_APPLE_enum_kind
    case apple_enum_kind
}

extension DWARFAttribute: RawRepresentable {
    public typealias RawValue = UInt64

    public init?(rawValue: RawValue) {
        switch rawValue {
        case numericCast(DW_AT_sibling): self = .sibling
        case numericCast(DW_AT_location): self = .location
        case numericCast(DW_AT_name): self = .name
        case numericCast(DW_AT_ordering): self = .ordering
        case numericCast(DW_AT_subscr_data): self = .subscr_data
        case numericCast(DW_AT_byte_size): self = .byte_size
        case numericCast(DW_AT_bit_offset): self = .bit_offset
        case numericCast(DW_AT_bit_size): self = .bit_size
        case numericCast(DW_AT_element_list): self = .element_list
        case numericCast(DW_AT_stmt_list): self = .stmt_list
        case numericCast(DW_AT_low_pc): self = .low_pc
        case numericCast(DW_AT_high_pc): self = .high_pc
        case numericCast(DW_AT_language): self = .language
        case numericCast(DW_AT_member): self = .member
        case numericCast(DW_AT_discr): self = .discr
        case numericCast(DW_AT_discr_value): self = .discr_value
        case numericCast(DW_AT_visibility): self = .visibility
        case numericCast(DW_AT_import): self = .import
        case numericCast(DW_AT_string_length): self = .string_length
        case numericCast(DW_AT_common_reference): self = .common_reference
        case numericCast(DW_AT_comp_dir): self = .comp_dir
        case numericCast(DW_AT_const_value): self = .const_value
        case numericCast(DW_AT_containing_type): self = .containing_type
        case numericCast(DW_AT_default_value): self = .default_value
        case numericCast(DW_AT_inline): self = .inline
        case numericCast(DW_AT_is_optional): self = .is_optional
        case numericCast(DW_AT_lower_bound): self = .lower_bound
        case numericCast(DW_AT_producer): self = .producer
        case numericCast(DW_AT_prototyped): self = .prototyped
        case numericCast(DW_AT_return_addr): self = .return_addr
        case numericCast(DW_AT_start_scope): self = .start_scope
        case numericCast(DW_AT_bit_stride): self = .bit_stride
        case numericCast(DW_AT_stride_size): self = .stride_size
        case numericCast(DW_AT_upper_bound): self = .upper_bound
        case numericCast(DW_AT_abstract_origin): self = .abstract_origin
        case numericCast(DW_AT_accessibility): self = .accessibility
        case numericCast(DW_AT_address_class): self = .address_class
        case numericCast(DW_AT_artificial): self = .artificial
        case numericCast(DW_AT_base_types): self = .base_types
        case numericCast(DW_AT_calling_convention): self = .calling_convention
        case numericCast(DW_AT_count): self = .count
        case numericCast(DW_AT_data_member_location): self = .data_member_location
        case numericCast(DW_AT_decl_column): self = .decl_column
        case numericCast(DW_AT_decl_file): self = .decl_file
        case numericCast(DW_AT_decl_line): self = .decl_line
        case numericCast(DW_AT_declaration): self = .declaration
        case numericCast(DW_AT_discr_list): self = .discr_list
        case numericCast(DW_AT_encoding): self = .encoding
        case numericCast(DW_AT_external): self = .external
        case numericCast(DW_AT_frame_base): self = .frame_base
        case numericCast(DW_AT_friend): self = .friend
        case numericCast(DW_AT_identifier_case): self = .identifier_case
        case numericCast(DW_AT_macro_info): self = .macro_info
        case numericCast(DW_AT_namelist_item): self = .namelist_item
        case numericCast(DW_AT_priority): self = .priority
        case numericCast(DW_AT_segment): self = .segment
        case numericCast(DW_AT_specification): self = .specification
        case numericCast(DW_AT_static_link): self = .static_link
        case numericCast(DW_AT_type): self = .type
        case numericCast(DW_AT_use_location): self = .use_location
        case numericCast(DW_AT_variable_parameter): self = .variable_parameter
        case numericCast(DW_AT_virtuality): self = .virtuality
        case numericCast(DW_AT_vtable_elem_location): self = .vtable_elem_location
        case numericCast(DW_AT_allocated): self = .allocated
        case numericCast(DW_AT_associated): self = .associated
        case numericCast(DW_AT_data_location): self = .data_location
        case numericCast(DW_AT_byte_stride): self = .byte_stride
        case numericCast(DW_AT_stride): self = .stride
        case numericCast(DW_AT_entry_pc): self = .entry_pc
        case numericCast(DW_AT_use_UTF8): self = .use_utf8
        case numericCast(DW_AT_extension): self = .extension
        case numericCast(DW_AT_ranges): self = .ranges
        case numericCast(DW_AT_trampoline): self = .trampoline
        case numericCast(DW_AT_call_column): self = .call_column
        case numericCast(DW_AT_call_file): self = .call_file
        case numericCast(DW_AT_call_line): self = .call_line
        case numericCast(DW_AT_description): self = .description
        case numericCast(DW_AT_binary_scale): self = .binary_scale
        case numericCast(DW_AT_decimal_scale): self = .decimal_scale
        case numericCast(DW_AT_small): self = .small
        case numericCast(DW_AT_decimal_sign): self = .decimal_sign
        case numericCast(DW_AT_digit_count): self = .digit_count
        case numericCast(DW_AT_picture_string): self = .picture_string
        case numericCast(DW_AT_mutable): self = .mutable
        case numericCast(DW_AT_threads_scaled): self = .threads_scaled
        case numericCast(DW_AT_explicit): self = .explicit
        case numericCast(DW_AT_object_pointer): self = .object_pointer
        case numericCast(DW_AT_endianity): self = .endianity
        case numericCast(DW_AT_elemental): self = .elemental
        case numericCast(DW_AT_pure): self = .pure
        case numericCast(DW_AT_recursive): self = .recursive
        case numericCast(DW_AT_signature): self = .signature
        case numericCast(DW_AT_main_subprogram): self = .main_subprogram
        case numericCast(DW_AT_data_bit_offset): self = .data_bit_offset
        case numericCast(DW_AT_const_expr): self = .const_expr
        case numericCast(DW_AT_enum_class): self = .enum_class
        case numericCast(DW_AT_linkage_name): self = .linkage_name
        case numericCast(DW_AT_string_length_bit_size): self = .string_length_bit_size
        case numericCast(DW_AT_string_length_byte_size): self = .string_length_byte_size
        case numericCast(DW_AT_rank): self = .rank
        case numericCast(DW_AT_str_offsets_base): self = .str_offsets_base
        case numericCast(DW_AT_addr_base): self = .addr_base
        case numericCast(DW_AT_rnglists_base): self = .rnglists_base
        case numericCast(DW_AT_dwo_id): self = .dwo_id
        case numericCast(DW_AT_dwo_name): self = .dwo_name
        case numericCast(DW_AT_reference): self = .reference
        case numericCast(DW_AT_rvalue_reference): self = .rvalue_reference
        case numericCast(DW_AT_macros): self = .macros
        case numericCast(DW_AT_call_all_calls): self = .call_all_calls
        case numericCast(DW_AT_call_all_source_calls): self = .call_all_source_calls
        case numericCast(DW_AT_call_all_tail_calls): self = .call_all_tail_calls
        case numericCast(DW_AT_call_return_pc): self = .call_return_pc
        case numericCast(DW_AT_call_value): self = .call_value
        case numericCast(DW_AT_call_origin): self = .call_origin
        case numericCast(DW_AT_call_parameter): self = .call_parameter
        case numericCast(DW_AT_call_pc): self = .call_pc
        case numericCast(DW_AT_call_tail_call): self = .call_tail_call
        case numericCast(DW_AT_call_target): self = .call_target
        case numericCast(DW_AT_call_target_clobbered): self = .call_target_clobbered
        case numericCast(DW_AT_call_data_location): self = .call_data_location
        case numericCast(DW_AT_call_data_value): self = .call_data_value
        case numericCast(DW_AT_noreturn): self = .noreturn
        case numericCast(DW_AT_alignment): self = .alignment
        case numericCast(DW_AT_export_symbols): self = .export_symbols
        case numericCast(DW_AT_deleted): self = .deleted
        case numericCast(DW_AT_defaulted): self = .defaulted
        case numericCast(DW_AT_loclists_base): self = .loclists_base
        case numericCast(DW_AT_language_name): self = .language_name
        case numericCast(DW_AT_language_version): self = .language_version
        case numericCast(DW_AT_ghs_namespace_alias): self = .ghs_namespace_alias
        case numericCast(DW_AT_ghs_using_namespace): self = .ghs_using_namespace
        case numericCast(DW_AT_ghs_using_declaration): self = .ghs_using_declaration
        case numericCast(DW_AT_HP_block_index): self = .hp_block_index
//        case numericCast(DW_AT_lo_user): self = .lo_user
        case numericCast(DW_AT_TI_veneer): self = .ti_veneer
        case numericCast(DW_AT_MIPS_fde): self = .mips_fde
        case numericCast(DW_AT_TI_symbol_name): self = .ti_symbol_name
//        case numericCast(DW_AT_HP_unmodifiable): self = .hp_unmodifiable
//        case numericCast(DW_AT_CPQ_discontig_ranges): self = .cpq_discontig_ranges
        case numericCast(DW_AT_MIPS_loop_begin): self = .mips_loop_begin
//        case numericCast(DW_AT_CPQ_semantic_events): self = .cpq_semantic_events
        case numericCast(DW_AT_MIPS_tail_loop_begin): self = .mips_tail_loop_begin
//        case numericCast(DW_AT_CPQ_split_lifetimes_var): self = .cpq_split_lifetimes_var
        case numericCast(DW_AT_MIPS_epilog_begin): self = .mips_epilog_begin
//        case numericCast(DW_AT_CPQ_split_lifetimes_rtn): self = .cpq_split_lifetimes_rtn
        case numericCast(DW_AT_MIPS_loop_unroll_factor): self = .mips_loop_unroll_factor
//        case numericCast(DW_AT_HP_prologue): self = .hp_prologue
//        case numericCast(DW_AT_CPQ_prologue_length): self = .cpq_prologue_length
        case numericCast(DW_AT_MIPS_software_pipeline_depth): self = .mips_software_pipeline_depth
        case numericCast(DW_AT_MIPS_linkage_name): self = .mips_linkage_name
//        case numericCast(DW_AT_ghs_mangled): self = .ghs_mangled
        case numericCast(DW_AT_MIPS_stride): self = .mips_stride
//        case numericCast(DW_AT_HP_epilogue): self = .hp_epilogue
        case numericCast(DW_AT_MIPS_abstract_name): self = .mips_abstract_name
        case numericCast(DW_AT_MIPS_clone_origin): self = .mips_clone_origin
        case numericCast(DW_AT_MIPS_has_inlines): self = .mips_has_inlines
        case numericCast(DW_AT_TI_version): self = .ti_version
        case numericCast(DW_AT_MIPS_stride_byte): self = .mips_stride_byte
        case numericCast(DW_AT_TI_asm): self = .ti_asm
        case numericCast(DW_AT_MIPS_stride_elem): self = .mips_stride_elem
        case numericCast(DW_AT_MIPS_ptr_dopetype): self = .mips_ptr_dopetype
        case numericCast(DW_AT_TI_skeletal): self = .ti_skeletal
        case numericCast(DW_AT_MIPS_allocatable_dopetype): self = .mips_allocatable_dopetype
        case numericCast(DW_AT_MIPS_assumed_shape_dopetype): self = .mips_assumed_shape_dopetype
//        case numericCast(DW_AT_HP_actuals_stmt_list): self = .hp_actuals_stmt_list
        case numericCast(DW_AT_MIPS_assumed_size): self = .mips_assumed_size
        case numericCast(DW_AT_TI_interrupt): self = .ti_interrupt
//        case numericCast(DW_AT_HP_proc_per_section): self = .hp_proc_per_section
        case numericCast(DW_AT_HP_raw_data_ptr): self = .hp_raw_data_ptr
        case numericCast(DW_AT_HP_pass_by_reference): self = .hp_pass_by_reference
        case numericCast(DW_AT_HP_opt_level): self = .hp_opt_level
        case numericCast(DW_AT_HP_prof_version_id): self = .hp_prof_version_id
        case numericCast(DW_AT_HP_opt_flags): self = .hp_opt_flags
        case numericCast(DW_AT_HP_cold_region_low_pc): self = .hp_cold_region_low_pc
        case numericCast(DW_AT_HP_cold_region_high_pc): self = .hp_cold_region_high_pc
        case numericCast(DW_AT_HP_all_variables_modifiable): self = .hp_all_variables_modifiable
        case numericCast(DW_AT_HP_linkage_name): self = .hp_linkage_name
        case numericCast(DW_AT_HP_prof_flags): self = .hp_prof_flags
        case numericCast(DW_AT_HP_unit_name): self = .hp_unit_name
        case numericCast(DW_AT_HP_unit_size): self = .hp_unit_size
        case numericCast(DW_AT_HP_widened_byte_size): self = .hp_widened_byte_size
        case numericCast(DW_AT_HP_definition_points): self = .hp_definition_points
        case numericCast(DW_AT_HP_default_location): self = .hp_default_location
        case numericCast(DW_AT_INTEL_other_endian): self = .intel_other_endian
        case numericCast(DW_AT_HP_is_result_param): self = .hp_is_result_param
        case numericCast(DW_AT_ghs_rsm): self = .ghs_rsm
        case numericCast(DW_AT_ghs_frsm): self = .ghs_frsm
        case numericCast(DW_AT_ghs_frames): self = .ghs_frames
        case numericCast(DW_AT_ghs_rso): self = .ghs_rso
        case numericCast(DW_AT_ghs_subcpu): self = .ghs_subcpu
        case numericCast(DW_AT_ghs_lbrace_line): self = .ghs_lbrace_line
        case numericCast(DW_AT_sf_names): self = .sf_names
        case numericCast(DW_AT_src_info): self = .src_info
        case numericCast(DW_AT_mac_info): self = .mac_info
        case numericCast(DW_AT_src_coords): self = .src_coords
        case numericCast(DW_AT_body_begin): self = .body_begin
        case numericCast(DW_AT_body_end): self = .body_end
        case numericCast(DW_AT_GNU_vector): self = .gnu_vector
        case numericCast(DW_AT_GNU_guarded_by): self = .gnu_guarded_by
        case numericCast(DW_AT_GNU_pt_guarded_by): self = .gnu_pt_guarded_by
        case numericCast(DW_AT_GNU_guarded): self = .gnu_guarded
        case numericCast(DW_AT_GNU_pt_guarded): self = .gnu_pt_guarded
        case numericCast(DW_AT_GNU_locks_excluded): self = .gnu_locks_excluded
        case numericCast(DW_AT_GNU_exclusive_locks_required): self = .gnu_exclusive_locks_required
        case numericCast(DW_AT_GNU_shared_locks_required): self = .gnu_shared_locks_required
        case numericCast(DW_AT_GNU_odr_signature): self = .gnu_odr_signature
        case numericCast(DW_AT_GNU_template_name): self = .gnu_template_name
        case numericCast(DW_AT_GNU_call_site_value): self = .gnu_call_site_value
        case numericCast(DW_AT_GNU_call_site_data_value): self = .gnu_call_site_data_value
        case numericCast(DW_AT_GNU_call_site_target): self = .gnu_call_site_target
        case numericCast(DW_AT_GNU_call_site_target_clobbered): self = .gnu_call_site_target_clobbered
        case numericCast(DW_AT_GNU_tail_call): self = .gnu_tail_call
        case numericCast(DW_AT_GNU_all_tail_call_sites): self = .gnu_all_tail_call_sites
        case numericCast(DW_AT_GNU_all_call_sites): self = .gnu_all_call_sites
        case numericCast(DW_AT_GNU_all_source_call_sites): self = .gnu_all_source_call_sites
        case numericCast(DW_AT_GNU_macros): self = .gnu_macros
        case numericCast(DW_AT_GNU_deleted): self = .gnu_deleted
        case numericCast(DW_AT_GNU_dwo_name): self = .gnu_dwo_name
        case numericCast(DW_AT_GNU_dwo_id): self = .gnu_dwo_id
        case numericCast(DW_AT_GNU_ranges_base): self = .gnu_ranges_base
        case numericCast(DW_AT_GNU_addr_base): self = .gnu_addr_base
        case numericCast(DW_AT_GNU_pubnames): self = .gnu_pubnames
        case numericCast(DW_AT_GNU_pubtypes): self = .gnu_pubtypes
        case numericCast(DW_AT_GNU_discriminator): self = .gnu_discriminator
        case numericCast(DW_AT_GNU_locviews): self = .gnu_locviews
        case numericCast(DW_AT_GNU_entry_view): self = .gnu_entry_view
        case numericCast(DW_AT_SUN_template): self = .sun_template
        case numericCast(DW_AT_VMS_rtnbeg_pd_address): self = .vms_rtnbeg_pd_address
        case numericCast(DW_AT_SUN_alignment): self = .sun_alignment
        case numericCast(DW_AT_SUN_vtable): self = .sun_vtable
        case numericCast(DW_AT_SUN_count_guarantee): self = .sun_count_guarantee
        case numericCast(DW_AT_SUN_command_line): self = .sun_command_line
        case numericCast(DW_AT_SUN_vbase): self = .sun_vbase
        case numericCast(DW_AT_SUN_compile_options): self = .sun_compile_options
        case numericCast(DW_AT_SUN_language): self = .sun_language
        case numericCast(DW_AT_SUN_browser_file): self = .sun_browser_file
        case numericCast(DW_AT_SUN_vtable_abi): self = .sun_vtable_abi
        case numericCast(DW_AT_SUN_func_offsets): self = .sun_func_offsets
        case numericCast(DW_AT_SUN_cf_kind): self = .sun_cf_kind
        case numericCast(DW_AT_SUN_vtable_index): self = .sun_vtable_index
        case numericCast(DW_AT_SUN_omp_tpriv_addr): self = .sun_omp_tpriv_addr
        case numericCast(DW_AT_SUN_omp_child_func): self = .sun_omp_child_func
        case numericCast(DW_AT_SUN_func_offset): self = .sun_func_offset
        case numericCast(DW_AT_SUN_memop_type_ref): self = .sun_memop_type_ref
        case numericCast(DW_AT_SUN_profile_id): self = .sun_profile_id
        case numericCast(DW_AT_SUN_memop_signature): self = .sun_memop_signature
        case numericCast(DW_AT_SUN_obj_dir): self = .sun_obj_dir
        case numericCast(DW_AT_SUN_obj_file): self = .sun_obj_file
        case numericCast(DW_AT_SUN_original_name): self = .sun_original_name
        case numericCast(DW_AT_SUN_hwcprof_signature): self = .sun_hwcprof_signature
        case numericCast(DW_AT_SUN_amd64_parmdump): self = .sun_amd64_parmdump
        case numericCast(DW_AT_SUN_part_link_name): self = .sun_part_link_name
        case numericCast(DW_AT_SUN_link_name): self = .sun_link_name
        case numericCast(DW_AT_SUN_pass_with_const): self = .sun_pass_with_const
        case numericCast(DW_AT_SUN_return_with_const): self = .sun_return_with_const
        case numericCast(DW_AT_SUN_import_by_name): self = .sun_import_by_name
        case numericCast(DW_AT_SUN_f90_pointer): self = .sun_f90_pointer
        case numericCast(DW_AT_SUN_90_pointer): self = .sun_90_pointer
        case numericCast(DW_AT_SUN_pass_by_ref): self = .sun_pass_by_ref
        case numericCast(DW_AT_SUN_f90_allocatable): self = .sun_f90_allocatable
        case numericCast(DW_AT_SUN_f90_assumed_shape_array): self = .sun_f90_assumed_shape_array
        case numericCast(DW_AT_SUN_c_vla): self = .sun_c_vla
        case numericCast(DW_AT_SUN_return_value_ptr): self = .sun_return_value_ptr
        case numericCast(DW_AT_SUN_dtor_start): self = .sun_dtor_start
        case numericCast(DW_AT_SUN_dtor_length): self = .sun_dtor_length
        case numericCast(DW_AT_SUN_dtor_state_initial): self = .sun_dtor_state_initial
        case numericCast(DW_AT_SUN_dtor_state_final): self = .sun_dtor_state_final
        case numericCast(DW_AT_SUN_dtor_state_deltas): self = .sun_dtor_state_deltas
        case numericCast(DW_AT_SUN_import_by_lname): self = .sun_import_by_lname
        case numericCast(DW_AT_SUN_f90_use_only): self = .sun_f90_use_only
        case numericCast(DW_AT_SUN_namelist_spec): self = .sun_namelist_spec
        case numericCast(DW_AT_SUN_is_omp_child_func): self = .sun_is_omp_child_func
        case numericCast(DW_AT_SUN_fortran_main_alias): self = .sun_fortran_main_alias
        case numericCast(DW_AT_SUN_fortran_based): self = .sun_fortran_based
        case numericCast(DW_AT_ALTIUM_loclist): self = .altium_loclist
        case numericCast(DW_AT_use_GNAT_descriptive_type): self = .use_gnat_descriptive_type
        case numericCast(DW_AT_GNAT_descriptive_type): self = .gnat_descriptive_type
        case numericCast(DW_AT_GNU_numerator): self = .gnu_numerator
        case numericCast(DW_AT_GNU_denominator): self = .gnu_denominator
        case numericCast(DW_AT_GNU_bias): self = .gnu_bias
        case numericCast(DW_AT_go_kind): self = .go_kind
        case numericCast(DW_AT_go_key): self = .go_key
        case numericCast(DW_AT_go_elem): self = .go_elem
        case numericCast(DW_AT_go_embedded_field): self = .go_embedded_field
        case numericCast(DW_AT_go_runtime_type): self = .go_runtime_type
        case numericCast(DW_AT_upc_threads_scaled): self = .upc_threads_scaled
        case numericCast(DW_AT_IBM_wsa_addr): self = .ibm_wsa_addr
        case numericCast(DW_AT_IBM_home_location): self = .ibm_home_location
        case numericCast(DW_AT_IBM_alt_srcview): self = .ibm_alt_srcview
        case numericCast(DW_AT_PGI_lbase): self = .pgi_lbase
        case numericCast(DW_AT_PGI_soffset): self = .pgi_soffset
        case numericCast(DW_AT_PGI_lstride): self = .pgi_lstride
        case numericCast(DW_AT_BORLAND_property_read): self = .borland_property_read
        case numericCast(DW_AT_BORLAND_property_write): self = .borland_property_write
        case numericCast(DW_AT_BORLAND_property_implements): self = .borland_property_implements
        case numericCast(DW_AT_BORLAND_property_index): self = .borland_property_index
        case numericCast(DW_AT_BORLAND_property_default): self = .borland_property_default
        case numericCast(DW_AT_BORLAND_Delphi_unit): self = .borland_delphi_unit
        case numericCast(DW_AT_BORLAND_Delphi_class): self = .borland_delphi_class
        case numericCast(DW_AT_BORLAND_Delphi_record): self = .borland_delphi_record
        case numericCast(DW_AT_BORLAND_Delphi_metaclass): self = .borland_delphi_metaclass
        case numericCast(DW_AT_BORLAND_Delphi_constructor): self = .borland_delphi_constructor
        case numericCast(DW_AT_BORLAND_Delphi_destructor): self = .borland_delphi_destructor
        case numericCast(DW_AT_BORLAND_Delphi_anonymous_method): self = .borland_delphi_anonymous_method
        case numericCast(DW_AT_BORLAND_Delphi_interface): self = .borland_delphi_interface
        case numericCast(DW_AT_BORLAND_Delphi_ABI): self = .borland_delphi_abi
        case numericCast(DW_AT_BORLAND_Delphi_return): self = .borland_delphi_return
        case numericCast(DW_AT_BORLAND_Delphi_frameptr): self = .borland_delphi_frameptr
        case numericCast(DW_AT_BORLAND_closure): self = .borland_closure
        case numericCast(DW_AT_LLVM_include_path): self = .llvm_include_path
        case numericCast(DW_AT_LLVM_config_macros): self = .llvm_config_macros
        case numericCast(DW_AT_LLVM_sysroot): self = .llvm_sysroot
        case numericCast(DW_AT_LLVM_tag_offset): self = .llvm_tag_offset
        case numericCast(DW_AT_LLVM_ptrauth_key): self = .llvm_ptrauth_key
        case numericCast(DW_AT_LLVM_ptrauth_address_discriminated): self = .llvm_ptrauth_address_discriminated
        case numericCast(DW_AT_LLVM_ptrauth_extra_discriminator): self = .llvm_ptrauth_extra_discriminator
        case numericCast(DW_AT_LLVM_apinotes): self = .llvm_apinotes
        case numericCast(DW_AT_LLVM_active_lane): self = .llvm_active_lane
        case numericCast(DW_AT_LLVM_ptrauth_isa_pointer): self = .llvm_ptrauth_isa_pointer
        case numericCast(DW_AT_LLVM_augmentation): self = .llvm_augmentation
        case numericCast(DW_AT_LLVM_ptrauth_authenticates_null_values): self = .llvm_ptrauth_authenticates_null_values
        case numericCast(DW_AT_LLVM_lanes): self = .llvm_lanes
        case numericCast(DW_AT_LLVM_ptrauth_authentication_mode): self = .llvm_ptrauth_authentication_mode
        case numericCast(DW_AT_LLVM_lane_pc): self = .llvm_lane_pc
        case numericCast(DW_AT_LLVM_num_extra_inhabitants): self = .llvm_num_extra_inhabitants
        case numericCast(DW_AT_LLVM_vector_size): self = .llvm_vector_size
        case numericCast(DW_AT_LLVM_stmt_sequence): self = .llvm_stmt_sequence
        case numericCast(DW_AT_APPLE_optimized): self = .apple_optimized
        case numericCast(DW_AT_APPLE_flags): self = .apple_flags
        case numericCast(DW_AT_APPLE_isa): self = .apple_isa
        case numericCast(DW_AT_APPLE_block): self = .apple_block
        case numericCast(DW_AT_APPLE_major_runtime_vers): self = .apple_major_runtime_vers
        case numericCast(DW_AT_APPLE_runtime_class): self = .apple_runtime_class
        case numericCast(DW_AT_APPLE_omit_frame_ptr): self = .apple_omit_frame_ptr
        case numericCast(DW_AT_APPLE_property_name): self = .apple_property_name
        case numericCast(DW_AT_APPLE_property_getter): self = .apple_property_getter
        case numericCast(DW_AT_APPLE_property_setter): self = .apple_property_setter
        case numericCast(DW_AT_APPLE_property_attribute): self = .apple_property_attribute
        case numericCast(DW_AT_APPLE_objc_complete_type): self = .apple_objc_complete_type
        case numericCast(DW_AT_APPLE_property): self = .apple_property
        case numericCast(DW_AT_APPLE_objc_direct): self = .apple_objc_direct
        case numericCast(DW_AT_APPLE_sdk): self = .apple_sdk
        case numericCast(DW_AT_APPLE_origin): self = .apple_origin
        case numericCast(DW_AT_APPLE_enum_kind): self = .apple_enum_kind
        default: return nil
        }
    }

    public var rawValue: RawValue {
        switch self {
        case .sibling: numericCast(DW_AT_sibling)
        case .location: numericCast(DW_AT_location)
        case .name: numericCast(DW_AT_name)
        case .ordering: numericCast(DW_AT_ordering)
        case .subscr_data: numericCast(DW_AT_subscr_data)
        case .byte_size: numericCast(DW_AT_byte_size)
        case .bit_offset: numericCast(DW_AT_bit_offset)
        case .bit_size: numericCast(DW_AT_bit_size)
        case .element_list: numericCast(DW_AT_element_list)
        case .stmt_list: numericCast(DW_AT_stmt_list)
        case .low_pc: numericCast(DW_AT_low_pc)
        case .high_pc: numericCast(DW_AT_high_pc)
        case .language: numericCast(DW_AT_language)
        case .member: numericCast(DW_AT_member)
        case .discr: numericCast(DW_AT_discr)
        case .discr_value: numericCast(DW_AT_discr_value)
        case .visibility: numericCast(DW_AT_visibility)
        case .import: numericCast(DW_AT_import)
        case .string_length: numericCast(DW_AT_string_length)
        case .common_reference: numericCast(DW_AT_common_reference)
        case .comp_dir: numericCast(DW_AT_comp_dir)
        case .const_value: numericCast(DW_AT_const_value)
        case .containing_type: numericCast(DW_AT_containing_type)
        case .default_value: numericCast(DW_AT_default_value)
        case .inline: numericCast(DW_AT_inline)
        case .is_optional: numericCast(DW_AT_is_optional)
        case .lower_bound: numericCast(DW_AT_lower_bound)
        case .producer: numericCast(DW_AT_producer)
        case .prototyped: numericCast(DW_AT_prototyped)
        case .return_addr: numericCast(DW_AT_return_addr)
        case .start_scope: numericCast(DW_AT_start_scope)
        case .bit_stride: numericCast(DW_AT_bit_stride)
        case .stride_size: numericCast(DW_AT_stride_size)
        case .upper_bound: numericCast(DW_AT_upper_bound)
        case .abstract_origin: numericCast(DW_AT_abstract_origin)
        case .accessibility: numericCast(DW_AT_accessibility)
        case .address_class: numericCast(DW_AT_address_class)
        case .artificial: numericCast(DW_AT_artificial)
        case .base_types: numericCast(DW_AT_base_types)
        case .calling_convention: numericCast(DW_AT_calling_convention)
        case .count: numericCast(DW_AT_count)
        case .data_member_location: numericCast(DW_AT_data_member_location)
        case .decl_column: numericCast(DW_AT_decl_column)
        case .decl_file: numericCast(DW_AT_decl_file)
        case .decl_line: numericCast(DW_AT_decl_line)
        case .declaration: numericCast(DW_AT_declaration)
        case .discr_list: numericCast(DW_AT_discr_list)
        case .encoding: numericCast(DW_AT_encoding)
        case .external: numericCast(DW_AT_external)
        case .frame_base: numericCast(DW_AT_frame_base)
        case .friend: numericCast(DW_AT_friend)
        case .identifier_case: numericCast(DW_AT_identifier_case)
        case .macro_info: numericCast(DW_AT_macro_info)
        case .namelist_item: numericCast(DW_AT_namelist_item)
        case .priority: numericCast(DW_AT_priority)
        case .segment: numericCast(DW_AT_segment)
        case .specification: numericCast(DW_AT_specification)
        case .static_link: numericCast(DW_AT_static_link)
        case .type: numericCast(DW_AT_type)
        case .use_location: numericCast(DW_AT_use_location)
        case .variable_parameter: numericCast(DW_AT_variable_parameter)
        case .virtuality: numericCast(DW_AT_virtuality)
        case .vtable_elem_location: numericCast(DW_AT_vtable_elem_location)
        case .allocated: numericCast(DW_AT_allocated)
        case .associated: numericCast(DW_AT_associated)
        case .data_location: numericCast(DW_AT_data_location)
        case .byte_stride: numericCast(DW_AT_byte_stride)
        case .stride: numericCast(DW_AT_stride)
        case .entry_pc: numericCast(DW_AT_entry_pc)
        case .use_utf8: numericCast(DW_AT_use_UTF8)
        case .extension: numericCast(DW_AT_extension)
        case .ranges: numericCast(DW_AT_ranges)
        case .trampoline: numericCast(DW_AT_trampoline)
        case .call_column: numericCast(DW_AT_call_column)
        case .call_file: numericCast(DW_AT_call_file)
        case .call_line: numericCast(DW_AT_call_line)
        case .description: numericCast(DW_AT_description)
        case .binary_scale: numericCast(DW_AT_binary_scale)
        case .decimal_scale: numericCast(DW_AT_decimal_scale)
        case .small: numericCast(DW_AT_small)
        case .decimal_sign: numericCast(DW_AT_decimal_sign)
        case .digit_count: numericCast(DW_AT_digit_count)
        case .picture_string: numericCast(DW_AT_picture_string)
        case .mutable: numericCast(DW_AT_mutable)
        case .threads_scaled: numericCast(DW_AT_threads_scaled)
        case .explicit: numericCast(DW_AT_explicit)
        case .object_pointer: numericCast(DW_AT_object_pointer)
        case .endianity: numericCast(DW_AT_endianity)
        case .elemental: numericCast(DW_AT_elemental)
        case .pure: numericCast(DW_AT_pure)
        case .recursive: numericCast(DW_AT_recursive)
        case .signature: numericCast(DW_AT_signature)
        case .main_subprogram: numericCast(DW_AT_main_subprogram)
        case .data_bit_offset: numericCast(DW_AT_data_bit_offset)
        case .const_expr: numericCast(DW_AT_const_expr)
        case .enum_class: numericCast(DW_AT_enum_class)
        case .linkage_name: numericCast(DW_AT_linkage_name)
        case .string_length_bit_size: numericCast(DW_AT_string_length_bit_size)
        case .string_length_byte_size: numericCast(DW_AT_string_length_byte_size)
        case .rank: numericCast(DW_AT_rank)
        case .str_offsets_base: numericCast(DW_AT_str_offsets_base)
        case .addr_base: numericCast(DW_AT_addr_base)
        case .rnglists_base: numericCast(DW_AT_rnglists_base)
        case .dwo_id: numericCast(DW_AT_dwo_id)
        case .dwo_name: numericCast(DW_AT_dwo_name)
        case .reference: numericCast(DW_AT_reference)
        case .rvalue_reference: numericCast(DW_AT_rvalue_reference)
        case .macros: numericCast(DW_AT_macros)
        case .call_all_calls: numericCast(DW_AT_call_all_calls)
        case .call_all_source_calls: numericCast(DW_AT_call_all_source_calls)
        case .call_all_tail_calls: numericCast(DW_AT_call_all_tail_calls)
        case .call_return_pc: numericCast(DW_AT_call_return_pc)
        case .call_value: numericCast(DW_AT_call_value)
        case .call_origin: numericCast(DW_AT_call_origin)
        case .call_parameter: numericCast(DW_AT_call_parameter)
        case .call_pc: numericCast(DW_AT_call_pc)
        case .call_tail_call: numericCast(DW_AT_call_tail_call)
        case .call_target: numericCast(DW_AT_call_target)
        case .call_target_clobbered: numericCast(DW_AT_call_target_clobbered)
        case .call_data_location: numericCast(DW_AT_call_data_location)
        case .call_data_value: numericCast(DW_AT_call_data_value)
        case .noreturn: numericCast(DW_AT_noreturn)
        case .alignment: numericCast(DW_AT_alignment)
        case .export_symbols: numericCast(DW_AT_export_symbols)
        case .deleted: numericCast(DW_AT_deleted)
        case .defaulted: numericCast(DW_AT_defaulted)
        case .loclists_base: numericCast(DW_AT_loclists_base)
        case .language_name: numericCast(DW_AT_language_name)
        case .language_version: numericCast(DW_AT_language_version)
        case .ghs_namespace_alias: numericCast(DW_AT_ghs_namespace_alias)
        case .ghs_using_namespace: numericCast(DW_AT_ghs_using_namespace)
        case .ghs_using_declaration: numericCast(DW_AT_ghs_using_declaration)
        case .hp_block_index: numericCast(DW_AT_HP_block_index)
//        case .lo_user: numericCast(DW_AT_lo_user)
        case .ti_veneer: numericCast(DW_AT_TI_veneer)
        case .mips_fde: numericCast(DW_AT_MIPS_fde)
        case .ti_symbol_name: numericCast(DW_AT_TI_symbol_name)
//        case .hp_unmodifiable: numericCast(DW_AT_HP_unmodifiable)
//        case .cpq_discontig_ranges: numericCast(DW_AT_CPQ_discontig_ranges)
        case .mips_loop_begin: numericCast(DW_AT_MIPS_loop_begin)
//        case .cpq_semantic_events: numericCast(DW_AT_CPQ_semantic_events)
        case .mips_tail_loop_begin: numericCast(DW_AT_MIPS_tail_loop_begin)
//        case .cpq_split_lifetimes_var: numericCast(DW_AT_CPQ_split_lifetimes_var)
        case .mips_epilog_begin: numericCast(DW_AT_MIPS_epilog_begin)
//        case .cpq_split_lifetimes_rtn: numericCast(DW_AT_CPQ_split_lifetimes_rtn)
        case .mips_loop_unroll_factor: numericCast(DW_AT_MIPS_loop_unroll_factor)
//        case .hp_prologue: numericCast(DW_AT_HP_prologue)
//        case .cpq_prologue_length: numericCast(DW_AT_CPQ_prologue_length)
        case .mips_software_pipeline_depth: numericCast(DW_AT_MIPS_software_pipeline_depth)
        case .mips_linkage_name: numericCast(DW_AT_MIPS_linkage_name)
//        case .ghs_mangled: numericCast(DW_AT_ghs_mangled)
        case .mips_stride: numericCast(DW_AT_MIPS_stride)
//        case .hp_epilogue: numericCast(DW_AT_HP_epilogue)
        case .mips_abstract_name: numericCast(DW_AT_MIPS_abstract_name)
        case .mips_clone_origin: numericCast(DW_AT_MIPS_clone_origin)
        case .mips_has_inlines: numericCast(DW_AT_MIPS_has_inlines)
        case .ti_version: numericCast(DW_AT_TI_version)
        case .mips_stride_byte: numericCast(DW_AT_MIPS_stride_byte)
        case .ti_asm: numericCast(DW_AT_TI_asm)
        case .mips_stride_elem: numericCast(DW_AT_MIPS_stride_elem)
        case .mips_ptr_dopetype: numericCast(DW_AT_MIPS_ptr_dopetype)
        case .ti_skeletal: numericCast(DW_AT_TI_skeletal)
        case .mips_allocatable_dopetype: numericCast(DW_AT_MIPS_allocatable_dopetype)
        case .mips_assumed_shape_dopetype: numericCast(DW_AT_MIPS_assumed_shape_dopetype)
//        case .hp_actuals_stmt_list: numericCast(DW_AT_HP_actuals_stmt_list)
        case .mips_assumed_size: numericCast(DW_AT_MIPS_assumed_size)
        case .ti_interrupt: numericCast(DW_AT_TI_interrupt)
//        case .hp_proc_per_section: numericCast(DW_AT_HP_proc_per_section)
        case .hp_raw_data_ptr: numericCast(DW_AT_HP_raw_data_ptr)
        case .hp_pass_by_reference: numericCast(DW_AT_HP_pass_by_reference)
        case .hp_opt_level: numericCast(DW_AT_HP_opt_level)
        case .hp_prof_version_id: numericCast(DW_AT_HP_prof_version_id)
        case .hp_opt_flags: numericCast(DW_AT_HP_opt_flags)
        case .hp_cold_region_low_pc: numericCast(DW_AT_HP_cold_region_low_pc)
        case .hp_cold_region_high_pc: numericCast(DW_AT_HP_cold_region_high_pc)
        case .hp_all_variables_modifiable: numericCast(DW_AT_HP_all_variables_modifiable)
        case .hp_linkage_name: numericCast(DW_AT_HP_linkage_name)
        case .hp_prof_flags: numericCast(DW_AT_HP_prof_flags)
        case .hp_unit_name: numericCast(DW_AT_HP_unit_name)
        case .hp_unit_size: numericCast(DW_AT_HP_unit_size)
        case .hp_widened_byte_size: numericCast(DW_AT_HP_widened_byte_size)
        case .hp_definition_points: numericCast(DW_AT_HP_definition_points)
        case .hp_default_location: numericCast(DW_AT_HP_default_location)
        case .intel_other_endian: numericCast(DW_AT_INTEL_other_endian)
        case .hp_is_result_param: numericCast(DW_AT_HP_is_result_param)
        case .ghs_rsm: numericCast(DW_AT_ghs_rsm)
        case .ghs_frsm: numericCast(DW_AT_ghs_frsm)
        case .ghs_frames: numericCast(DW_AT_ghs_frames)
        case .ghs_rso: numericCast(DW_AT_ghs_rso)
        case .ghs_subcpu: numericCast(DW_AT_ghs_subcpu)
        case .ghs_lbrace_line: numericCast(DW_AT_ghs_lbrace_line)
        case .sf_names: numericCast(DW_AT_sf_names)
        case .src_info: numericCast(DW_AT_src_info)
        case .mac_info: numericCast(DW_AT_mac_info)
        case .src_coords: numericCast(DW_AT_src_coords)
        case .body_begin: numericCast(DW_AT_body_begin)
        case .body_end: numericCast(DW_AT_body_end)
        case .gnu_vector: numericCast(DW_AT_GNU_vector)
        case .gnu_guarded_by: numericCast(DW_AT_GNU_guarded_by)
        case .gnu_pt_guarded_by: numericCast(DW_AT_GNU_pt_guarded_by)
        case .gnu_guarded: numericCast(DW_AT_GNU_guarded)
        case .gnu_pt_guarded: numericCast(DW_AT_GNU_pt_guarded)
        case .gnu_locks_excluded: numericCast(DW_AT_GNU_locks_excluded)
        case .gnu_exclusive_locks_required: numericCast(DW_AT_GNU_exclusive_locks_required)
        case .gnu_shared_locks_required: numericCast(DW_AT_GNU_shared_locks_required)
        case .gnu_odr_signature: numericCast(DW_AT_GNU_odr_signature)
        case .gnu_template_name: numericCast(DW_AT_GNU_template_name)
        case .gnu_call_site_value: numericCast(DW_AT_GNU_call_site_value)
        case .gnu_call_site_data_value: numericCast(DW_AT_GNU_call_site_data_value)
        case .gnu_call_site_target: numericCast(DW_AT_GNU_call_site_target)
        case .gnu_call_site_target_clobbered: numericCast(DW_AT_GNU_call_site_target_clobbered)
        case .gnu_tail_call: numericCast(DW_AT_GNU_tail_call)
        case .gnu_all_tail_call_sites: numericCast(DW_AT_GNU_all_tail_call_sites)
        case .gnu_all_call_sites: numericCast(DW_AT_GNU_all_call_sites)
        case .gnu_all_source_call_sites: numericCast(DW_AT_GNU_all_source_call_sites)
        case .gnu_macros: numericCast(DW_AT_GNU_macros)
        case .gnu_deleted: numericCast(DW_AT_GNU_deleted)
        case .gnu_dwo_name: numericCast(DW_AT_GNU_dwo_name)
        case .gnu_dwo_id: numericCast(DW_AT_GNU_dwo_id)
        case .gnu_ranges_base: numericCast(DW_AT_GNU_ranges_base)
        case .gnu_addr_base: numericCast(DW_AT_GNU_addr_base)
        case .gnu_pubnames: numericCast(DW_AT_GNU_pubnames)
        case .gnu_pubtypes: numericCast(DW_AT_GNU_pubtypes)
        case .gnu_discriminator: numericCast(DW_AT_GNU_discriminator)
        case .gnu_locviews: numericCast(DW_AT_GNU_locviews)
        case .gnu_entry_view: numericCast(DW_AT_GNU_entry_view)
        case .sun_template: numericCast(DW_AT_SUN_template)
        case .vms_rtnbeg_pd_address: numericCast(DW_AT_VMS_rtnbeg_pd_address)
        case .sun_alignment: numericCast(DW_AT_SUN_alignment)
        case .sun_vtable: numericCast(DW_AT_SUN_vtable)
        case .sun_count_guarantee: numericCast(DW_AT_SUN_count_guarantee)
        case .sun_command_line: numericCast(DW_AT_SUN_command_line)
        case .sun_vbase: numericCast(DW_AT_SUN_vbase)
        case .sun_compile_options: numericCast(DW_AT_SUN_compile_options)
        case .sun_language: numericCast(DW_AT_SUN_language)
        case .sun_browser_file: numericCast(DW_AT_SUN_browser_file)
        case .sun_vtable_abi: numericCast(DW_AT_SUN_vtable_abi)
        case .sun_func_offsets: numericCast(DW_AT_SUN_func_offsets)
        case .sun_cf_kind: numericCast(DW_AT_SUN_cf_kind)
        case .sun_vtable_index: numericCast(DW_AT_SUN_vtable_index)
        case .sun_omp_tpriv_addr: numericCast(DW_AT_SUN_omp_tpriv_addr)
        case .sun_omp_child_func: numericCast(DW_AT_SUN_omp_child_func)
        case .sun_func_offset: numericCast(DW_AT_SUN_func_offset)
        case .sun_memop_type_ref: numericCast(DW_AT_SUN_memop_type_ref)
        case .sun_profile_id: numericCast(DW_AT_SUN_profile_id)
        case .sun_memop_signature: numericCast(DW_AT_SUN_memop_signature)
        case .sun_obj_dir: numericCast(DW_AT_SUN_obj_dir)
        case .sun_obj_file: numericCast(DW_AT_SUN_obj_file)
        case .sun_original_name: numericCast(DW_AT_SUN_original_name)
        case .sun_hwcprof_signature: numericCast(DW_AT_SUN_hwcprof_signature)
        case .sun_amd64_parmdump: numericCast(DW_AT_SUN_amd64_parmdump)
        case .sun_part_link_name: numericCast(DW_AT_SUN_part_link_name)
        case .sun_link_name: numericCast(DW_AT_SUN_link_name)
        case .sun_pass_with_const: numericCast(DW_AT_SUN_pass_with_const)
        case .sun_return_with_const: numericCast(DW_AT_SUN_return_with_const)
        case .sun_import_by_name: numericCast(DW_AT_SUN_import_by_name)
        case .sun_f90_pointer: numericCast(DW_AT_SUN_f90_pointer)
        case .sun_90_pointer: numericCast(DW_AT_SUN_90_pointer)
        case .sun_pass_by_ref: numericCast(DW_AT_SUN_pass_by_ref)
        case .sun_f90_allocatable: numericCast(DW_AT_SUN_f90_allocatable)
        case .sun_f90_assumed_shape_array: numericCast(DW_AT_SUN_f90_assumed_shape_array)
        case .sun_c_vla: numericCast(DW_AT_SUN_c_vla)
        case .sun_return_value_ptr: numericCast(DW_AT_SUN_return_value_ptr)
        case .sun_dtor_start: numericCast(DW_AT_SUN_dtor_start)
        case .sun_dtor_length: numericCast(DW_AT_SUN_dtor_length)
        case .sun_dtor_state_initial: numericCast(DW_AT_SUN_dtor_state_initial)
        case .sun_dtor_state_final: numericCast(DW_AT_SUN_dtor_state_final)
        case .sun_dtor_state_deltas: numericCast(DW_AT_SUN_dtor_state_deltas)
        case .sun_import_by_lname: numericCast(DW_AT_SUN_import_by_lname)
        case .sun_f90_use_only: numericCast(DW_AT_SUN_f90_use_only)
        case .sun_namelist_spec: numericCast(DW_AT_SUN_namelist_spec)
        case .sun_is_omp_child_func: numericCast(DW_AT_SUN_is_omp_child_func)
        case .sun_fortran_main_alias: numericCast(DW_AT_SUN_fortran_main_alias)
        case .sun_fortran_based: numericCast(DW_AT_SUN_fortran_based)
        case .altium_loclist: numericCast(DW_AT_ALTIUM_loclist)
        case .use_gnat_descriptive_type: numericCast(DW_AT_use_GNAT_descriptive_type)
        case .gnat_descriptive_type: numericCast(DW_AT_GNAT_descriptive_type)
        case .gnu_numerator: numericCast(DW_AT_GNU_numerator)
        case .gnu_denominator: numericCast(DW_AT_GNU_denominator)
        case .gnu_bias: numericCast(DW_AT_GNU_bias)
        case .go_kind: numericCast(DW_AT_go_kind)
        case .go_key: numericCast(DW_AT_go_key)
        case .go_elem: numericCast(DW_AT_go_elem)
        case .go_embedded_field: numericCast(DW_AT_go_embedded_field)
        case .go_runtime_type: numericCast(DW_AT_go_runtime_type)
        case .upc_threads_scaled: numericCast(DW_AT_upc_threads_scaled)
        case .ibm_wsa_addr: numericCast(DW_AT_IBM_wsa_addr)
        case .ibm_home_location: numericCast(DW_AT_IBM_home_location)
        case .ibm_alt_srcview: numericCast(DW_AT_IBM_alt_srcview)
        case .pgi_lbase: numericCast(DW_AT_PGI_lbase)
        case .pgi_soffset: numericCast(DW_AT_PGI_soffset)
        case .pgi_lstride: numericCast(DW_AT_PGI_lstride)
        case .borland_property_read: numericCast(DW_AT_BORLAND_property_read)
        case .borland_property_write: numericCast(DW_AT_BORLAND_property_write)
        case .borland_property_implements: numericCast(DW_AT_BORLAND_property_implements)
        case .borland_property_index: numericCast(DW_AT_BORLAND_property_index)
        case .borland_property_default: numericCast(DW_AT_BORLAND_property_default)
        case .borland_delphi_unit: numericCast(DW_AT_BORLAND_Delphi_unit)
        case .borland_delphi_class: numericCast(DW_AT_BORLAND_Delphi_class)
        case .borland_delphi_record: numericCast(DW_AT_BORLAND_Delphi_record)
        case .borland_delphi_metaclass: numericCast(DW_AT_BORLAND_Delphi_metaclass)
        case .borland_delphi_constructor: numericCast(DW_AT_BORLAND_Delphi_constructor)
        case .borland_delphi_destructor: numericCast(DW_AT_BORLAND_Delphi_destructor)
        case .borland_delphi_anonymous_method: numericCast(DW_AT_BORLAND_Delphi_anonymous_method)
        case .borland_delphi_interface: numericCast(DW_AT_BORLAND_Delphi_interface)
        case .borland_delphi_abi: numericCast(DW_AT_BORLAND_Delphi_ABI)
        case .borland_delphi_return: numericCast(DW_AT_BORLAND_Delphi_return)
        case .borland_delphi_frameptr: numericCast(DW_AT_BORLAND_Delphi_frameptr)
        case .borland_closure: numericCast(DW_AT_BORLAND_closure)
        case .llvm_include_path: numericCast(DW_AT_LLVM_include_path)
        case .llvm_config_macros: numericCast(DW_AT_LLVM_config_macros)
        case .llvm_sysroot: numericCast(DW_AT_LLVM_sysroot)
        case .llvm_tag_offset: numericCast(DW_AT_LLVM_tag_offset)
        case .llvm_ptrauth_key: numericCast(DW_AT_LLVM_ptrauth_key)
        case .llvm_ptrauth_address_discriminated: numericCast(DW_AT_LLVM_ptrauth_address_discriminated)
        case .llvm_ptrauth_extra_discriminator: numericCast(DW_AT_LLVM_ptrauth_extra_discriminator)
        case .llvm_apinotes: numericCast(DW_AT_LLVM_apinotes)
        case .llvm_active_lane: numericCast(DW_AT_LLVM_active_lane)
        case .llvm_ptrauth_isa_pointer: numericCast(DW_AT_LLVM_ptrauth_isa_pointer)
        case .llvm_augmentation: numericCast(DW_AT_LLVM_augmentation)
        case .llvm_ptrauth_authenticates_null_values: numericCast(DW_AT_LLVM_ptrauth_authenticates_null_values)
        case .llvm_lanes: numericCast(DW_AT_LLVM_lanes)
        case .llvm_ptrauth_authentication_mode: numericCast(DW_AT_LLVM_ptrauth_authentication_mode)
        case .llvm_lane_pc: numericCast(DW_AT_LLVM_lane_pc)
        case .llvm_num_extra_inhabitants: numericCast(DW_AT_LLVM_num_extra_inhabitants)
        case .llvm_vector_size: numericCast(DW_AT_LLVM_vector_size)
        case .llvm_stmt_sequence: numericCast(DW_AT_LLVM_stmt_sequence)
        case .apple_optimized: numericCast(DW_AT_APPLE_optimized)
        case .apple_flags: numericCast(DW_AT_APPLE_flags)
        case .apple_isa: numericCast(DW_AT_APPLE_isa)
        case .apple_block: numericCast(DW_AT_APPLE_block)
        case .apple_major_runtime_vers: numericCast(DW_AT_APPLE_major_runtime_vers)
        case .apple_runtime_class: numericCast(DW_AT_APPLE_runtime_class)
        case .apple_omit_frame_ptr: numericCast(DW_AT_APPLE_omit_frame_ptr)
        case .apple_property_name: numericCast(DW_AT_APPLE_property_name)
        case .apple_property_getter: numericCast(DW_AT_APPLE_property_getter)
        case .apple_property_setter: numericCast(DW_AT_APPLE_property_setter)
        case .apple_property_attribute: numericCast(DW_AT_APPLE_property_attribute)
        case .apple_objc_complete_type: numericCast(DW_AT_APPLE_objc_complete_type)
        case .apple_property: numericCast(DW_AT_APPLE_property)
        case .apple_objc_direct: numericCast(DW_AT_APPLE_objc_direct)
        case .apple_sdk: numericCast(DW_AT_APPLE_sdk)
        case .apple_origin: numericCast(DW_AT_APPLE_origin)
        case .apple_enum_kind: numericCast(DW_AT_APPLE_enum_kind)
        }
    }
}

extension DWARFAttribute: CustomStringConvertible {
    public var description: String {
        switch self {
        case .sibling: "DW_AT_sibling"
        case .location: "DW_AT_location"
        case .name: "DW_AT_name"
        case .ordering: "DW_AT_ordering"
        case .subscr_data: "DW_AT_subscr_data"
        case .byte_size: "DW_AT_byte_size"
        case .bit_offset: "DW_AT_bit_offset"
        case .bit_size: "DW_AT_bit_size"
        case .element_list: "DW_AT_element_list"
        case .stmt_list: "DW_AT_stmt_list"
        case .low_pc: "DW_AT_low_pc"
        case .high_pc: "DW_AT_high_pc"
        case .language: "DW_AT_language"
        case .member: "DW_AT_member"
        case .discr: "DW_AT_discr"
        case .discr_value: "DW_AT_discr_value"
        case .visibility: "DW_AT_visibility"
        case .import: "DW_AT_import"
        case .string_length: "DW_AT_string_length"
        case .common_reference: "DW_AT_common_reference"
        case .comp_dir: "DW_AT_comp_dir"
        case .const_value: "DW_AT_const_value"
        case .containing_type: "DW_AT_containing_type"
        case .default_value: "DW_AT_default_value"
        case .inline: "DW_AT_inline"
        case .is_optional: "DW_AT_is_optional"
        case .lower_bound: "DW_AT_lower_bound"
        case .producer: "DW_AT_producer"
        case .prototyped: "DW_AT_prototyped"
        case .return_addr: "DW_AT_return_addr"
        case .start_scope: "DW_AT_start_scope"
        case .bit_stride: "DW_AT_bit_stride"
        case .stride_size: "DW_AT_stride_size"
        case .upper_bound: "DW_AT_upper_bound"
        case .abstract_origin: "DW_AT_abstract_origin"
        case .accessibility: "DW_AT_accessibility"
        case .address_class: "DW_AT_address_class"
        case .artificial: "DW_AT_artificial"
        case .base_types: "DW_AT_base_types"
        case .calling_convention: "DW_AT_calling_convention"
        case .count: "DW_AT_count"
        case .data_member_location: "DW_AT_data_member_location"
        case .decl_column: "DW_AT_decl_column"
        case .decl_file: "DW_AT_decl_file"
        case .decl_line: "DW_AT_decl_line"
        case .declaration: "DW_AT_declaration"
        case .discr_list: "DW_AT_discr_list"
        case .encoding: "DW_AT_encoding"
        case .external: "DW_AT_external"
        case .frame_base: "DW_AT_frame_base"
        case .friend: "DW_AT_friend"
        case .identifier_case: "DW_AT_identifier_case"
        case .macro_info: "DW_AT_macro_info"
        case .namelist_item: "DW_AT_namelist_item"
        case .priority: "DW_AT_priority"
        case .segment: "DW_AT_segment"
        case .specification: "DW_AT_specification"
        case .static_link: "DW_AT_static_link"
        case .type: "DW_AT_type"
        case .use_location: "DW_AT_use_location"
        case .variable_parameter: "DW_AT_variable_parameter"
        case .virtuality: "DW_AT_virtuality"
        case .vtable_elem_location: "DW_AT_vtable_elem_location"
        case .allocated: "DW_AT_allocated"
        case .associated: "DW_AT_associated"
        case .data_location: "DW_AT_data_location"
        case .byte_stride: "DW_AT_byte_stride"
        case .stride: "DW_AT_stride"
        case .entry_pc: "DW_AT_entry_pc"
        case .use_utf8: "DW_AT_use_UTF8"
        case .extension: "DW_AT_extension"
        case .ranges: "DW_AT_ranges"
        case .trampoline: "DW_AT_trampoline"
        case .call_column: "DW_AT_call_column"
        case .call_file: "DW_AT_call_file"
        case .call_line: "DW_AT_call_line"
        case .description: "DW_AT_description"
        case .binary_scale: "DW_AT_binary_scale"
        case .decimal_scale: "DW_AT_decimal_scale"
        case .small: "DW_AT_small"
        case .decimal_sign: "DW_AT_decimal_sign"
        case .digit_count: "DW_AT_digit_count"
        case .picture_string: "DW_AT_picture_string"
        case .mutable: "DW_AT_mutable"
        case .threads_scaled: "DW_AT_threads_scaled"
        case .explicit: "DW_AT_explicit"
        case .object_pointer: "DW_AT_object_pointer"
        case .endianity: "DW_AT_endianity"
        case .elemental: "DW_AT_elemental"
        case .pure: "DW_AT_pure"
        case .recursive: "DW_AT_recursive"
        case .signature: "DW_AT_signature"
        case .main_subprogram: "DW_AT_main_subprogram"
        case .data_bit_offset: "DW_AT_data_bit_offset"
        case .const_expr: "DW_AT_const_expr"
        case .enum_class: "DW_AT_enum_class"
        case .linkage_name: "DW_AT_linkage_name"
        case .string_length_bit_size: "DW_AT_string_length_bit_size"
        case .string_length_byte_size: "DW_AT_string_length_byte_size"
        case .rank: "DW_AT_rank"
        case .str_offsets_base: "DW_AT_str_offsets_base"
        case .addr_base: "DW_AT_addr_base"
        case .rnglists_base: "DW_AT_rnglists_base"
        case .dwo_id: "DW_AT_dwo_id"
        case .dwo_name: "DW_AT_dwo_name"
        case .reference: "DW_AT_reference"
        case .rvalue_reference: "DW_AT_rvalue_reference"
        case .macros: "DW_AT_macros"
        case .call_all_calls: "DW_AT_call_all_calls"
        case .call_all_source_calls: "DW_AT_call_all_source_calls"
        case .call_all_tail_calls: "DW_AT_call_all_tail_calls"
        case .call_return_pc: "DW_AT_call_return_pc"
        case .call_value: "DW_AT_call_value"
        case .call_origin: "DW_AT_call_origin"
        case .call_parameter: "DW_AT_call_parameter"
        case .call_pc: "DW_AT_call_pc"
        case .call_tail_call: "DW_AT_call_tail_call"
        case .call_target: "DW_AT_call_target"
        case .call_target_clobbered: "DW_AT_call_target_clobbered"
        case .call_data_location: "DW_AT_call_data_location"
        case .call_data_value: "DW_AT_call_data_value"
        case .noreturn: "DW_AT_noreturn"
        case .alignment: "DW_AT_alignment"
        case .export_symbols: "DW_AT_export_symbols"
        case .deleted: "DW_AT_deleted"
        case .defaulted: "DW_AT_defaulted"
        case .loclists_base: "DW_AT_loclists_base"
        case .language_name: "DW_AT_language_name"
        case .language_version: "DW_AT_language_version"
        case .ghs_namespace_alias: "DW_AT_ghs_namespace_alias"
        case .ghs_using_namespace: "DW_AT_ghs_using_namespace"
        case .ghs_using_declaration: "DW_AT_ghs_using_declaration"
        case .hp_block_index: "DW_AT_HP_block_index"
//        case .lo_user: "DW_AT_lo_user"
        case .ti_veneer: "DW_AT_TI_veneer"
        case .mips_fde: "DW_AT_MIPS_fde"
        case .ti_symbol_name: "DW_AT_TI_symbol_name"
//        case .hp_unmodifiable: "DW_AT_HP_unmodifiable"
//        case .cpq_discontig_ranges: "DW_AT_CPQ_discontig_ranges"
        case .mips_loop_begin: "DW_AT_MIPS_loop_begin"
//        case .cpq_semantic_events: "DW_AT_CPQ_semantic_events"
        case .mips_tail_loop_begin: "DW_AT_MIPS_tail_loop_begin"
//        case .cpq_split_lifetimes_var: "DW_AT_CPQ_split_lifetimes_var"
        case .mips_epilog_begin: "DW_AT_MIPS_epilog_begin"
//        case .cpq_split_lifetimes_rtn: "DW_AT_CPQ_split_lifetimes_rtn"
        case .mips_loop_unroll_factor: "DW_AT_MIPS_loop_unroll_factor"
//        case .hp_prologue: "DW_AT_HP_prologue"
//        case .cpq_prologue_length: "DW_AT_CPQ_prologue_length"
        case .mips_software_pipeline_depth: "DW_AT_MIPS_software_pipeline_depth"
        case .mips_linkage_name: "DW_AT_MIPS_linkage_name"
//        case .ghs_mangled: "DW_AT_ghs_mangled"
        case .mips_stride: "DW_AT_MIPS_stride"
//        case .hp_epilogue: "DW_AT_HP_epilogue"
        case .mips_abstract_name: "DW_AT_MIPS_abstract_name"
        case .mips_clone_origin: "DW_AT_MIPS_clone_origin"
        case .mips_has_inlines: "DW_AT_MIPS_has_inlines"
        case .ti_version: "DW_AT_TI_version"
        case .mips_stride_byte: "DW_AT_MIPS_stride_byte"
        case .ti_asm: "DW_AT_TI_asm"
        case .mips_stride_elem: "DW_AT_MIPS_stride_elem"
        case .mips_ptr_dopetype: "DW_AT_MIPS_ptr_dopetype"
        case .ti_skeletal: "DW_AT_TI_skeletal"
        case .mips_allocatable_dopetype: "DW_AT_MIPS_allocatable_dopetype"
        case .mips_assumed_shape_dopetype: "DW_AT_MIPS_assumed_shape_dopetype"
//        case .hp_actuals_stmt_list: "DW_AT_HP_actuals_stmt_list"
        case .mips_assumed_size: "DW_AT_MIPS_assumed_size"
        case .ti_interrupt: "DW_AT_TI_interrupt"
//        case .hp_proc_per_section: "DW_AT_HP_proc_per_section"
        case .hp_raw_data_ptr: "DW_AT_HP_raw_data_ptr"
        case .hp_pass_by_reference: "DW_AT_HP_pass_by_reference"
        case .hp_opt_level: "DW_AT_HP_opt_level"
        case .hp_prof_version_id: "DW_AT_HP_prof_version_id"
        case .hp_opt_flags: "DW_AT_HP_opt_flags"
        case .hp_cold_region_low_pc: "DW_AT_HP_cold_region_low_pc"
        case .hp_cold_region_high_pc: "DW_AT_HP_cold_region_high_pc"
        case .hp_all_variables_modifiable: "DW_AT_HP_all_variables_modifiable"
        case .hp_linkage_name: "DW_AT_HP_linkage_name"
        case .hp_prof_flags: "DW_AT_HP_prof_flags"
        case .hp_unit_name: "DW_AT_HP_unit_name"
        case .hp_unit_size: "DW_AT_HP_unit_size"
        case .hp_widened_byte_size: "DW_AT_HP_widened_byte_size"
        case .hp_definition_points: "DW_AT_HP_definition_points"
        case .hp_default_location: "DW_AT_HP_default_location"
        case .intel_other_endian: "DW_AT_INTEL_other_endian"
        case .hp_is_result_param: "DW_AT_HP_is_result_param"
        case .ghs_rsm: "DW_AT_ghs_rsm"
        case .ghs_frsm: "DW_AT_ghs_frsm"
        case .ghs_frames: "DW_AT_ghs_frames"
        case .ghs_rso: "DW_AT_ghs_rso"
        case .ghs_subcpu: "DW_AT_ghs_subcpu"
        case .ghs_lbrace_line: "DW_AT_ghs_lbrace_line"
        case .sf_names: "DW_AT_sf_names"
        case .src_info: "DW_AT_src_info"
        case .mac_info: "DW_AT_mac_info"
        case .src_coords: "DW_AT_src_coords"
        case .body_begin: "DW_AT_body_begin"
        case .body_end: "DW_AT_body_end"
        case .gnu_vector: "DW_AT_GNU_vector"
        case .gnu_guarded_by: "DW_AT_GNU_guarded_by"
        case .gnu_pt_guarded_by: "DW_AT_GNU_pt_guarded_by"
        case .gnu_guarded: "DW_AT_GNU_guarded"
        case .gnu_pt_guarded: "DW_AT_GNU_pt_guarded"
        case .gnu_locks_excluded: "DW_AT_GNU_locks_excluded"
        case .gnu_exclusive_locks_required: "DW_AT_GNU_exclusive_locks_required"
        case .gnu_shared_locks_required: "DW_AT_GNU_shared_locks_required"
        case .gnu_odr_signature: "DW_AT_GNU_odr_signature"
        case .gnu_template_name: "DW_AT_GNU_template_name"
        case .gnu_call_site_value: "DW_AT_GNU_call_site_value"
        case .gnu_call_site_data_value: "DW_AT_GNU_call_site_data_value"
        case .gnu_call_site_target: "DW_AT_GNU_call_site_target"
        case .gnu_call_site_target_clobbered: "DW_AT_GNU_call_site_target_clobbered"
        case .gnu_tail_call: "DW_AT_GNU_tail_call"
        case .gnu_all_tail_call_sites: "DW_AT_GNU_all_tail_call_sites"
        case .gnu_all_call_sites: "DW_AT_GNU_all_call_sites"
        case .gnu_all_source_call_sites: "DW_AT_GNU_all_source_call_sites"
        case .gnu_macros: "DW_AT_GNU_macros"
        case .gnu_deleted: "DW_AT_GNU_deleted"
        case .gnu_dwo_name: "DW_AT_GNU_dwo_name"
        case .gnu_dwo_id: "DW_AT_GNU_dwo_id"
        case .gnu_ranges_base: "DW_AT_GNU_ranges_base"
        case .gnu_addr_base: "DW_AT_GNU_addr_base"
        case .gnu_pubnames: "DW_AT_GNU_pubnames"
        case .gnu_pubtypes: "DW_AT_GNU_pubtypes"
        case .gnu_discriminator: "DW_AT_GNU_discriminator"
        case .gnu_locviews: "DW_AT_GNU_locviews"
        case .gnu_entry_view: "DW_AT_GNU_entry_view"
        case .sun_template: "DW_AT_SUN_template"
        case .vms_rtnbeg_pd_address: "DW_AT_VMS_rtnbeg_pd_address"
        case .sun_alignment: "DW_AT_SUN_alignment"
        case .sun_vtable: "DW_AT_SUN_vtable"
        case .sun_count_guarantee: "DW_AT_SUN_count_guarantee"
        case .sun_command_line: "DW_AT_SUN_command_line"
        case .sun_vbase: "DW_AT_SUN_vbase"
        case .sun_compile_options: "DW_AT_SUN_compile_options"
        case .sun_language: "DW_AT_SUN_language"
        case .sun_browser_file: "DW_AT_SUN_browser_file"
        case .sun_vtable_abi: "DW_AT_SUN_vtable_abi"
        case .sun_func_offsets: "DW_AT_SUN_func_offsets"
        case .sun_cf_kind: "DW_AT_SUN_cf_kind"
        case .sun_vtable_index: "DW_AT_SUN_vtable_index"
        case .sun_omp_tpriv_addr: "DW_AT_SUN_omp_tpriv_addr"
        case .sun_omp_child_func: "DW_AT_SUN_omp_child_func"
        case .sun_func_offset: "DW_AT_SUN_func_offset"
        case .sun_memop_type_ref: "DW_AT_SUN_memop_type_ref"
        case .sun_profile_id: "DW_AT_SUN_profile_id"
        case .sun_memop_signature: "DW_AT_SUN_memop_signature"
        case .sun_obj_dir: "DW_AT_SUN_obj_dir"
        case .sun_obj_file: "DW_AT_SUN_obj_file"
        case .sun_original_name: "DW_AT_SUN_original_name"
        case .sun_hwcprof_signature: "DW_AT_SUN_hwcprof_signature"
        case .sun_amd64_parmdump: "DW_AT_SUN_amd64_parmdump"
        case .sun_part_link_name: "DW_AT_SUN_part_link_name"
        case .sun_link_name: "DW_AT_SUN_link_name"
        case .sun_pass_with_const: "DW_AT_SUN_pass_with_const"
        case .sun_return_with_const: "DW_AT_SUN_return_with_const"
        case .sun_import_by_name: "DW_AT_SUN_import_by_name"
        case .sun_f90_pointer: "DW_AT_SUN_f90_pointer"
        case .sun_90_pointer: "DW_AT_SUN_90_pointer"
        case .sun_pass_by_ref: "DW_AT_SUN_pass_by_ref"
        case .sun_f90_allocatable: "DW_AT_SUN_f90_allocatable"
        case .sun_f90_assumed_shape_array: "DW_AT_SUN_f90_assumed_shape_array"
        case .sun_c_vla: "DW_AT_SUN_c_vla"
        case .sun_return_value_ptr: "DW_AT_SUN_return_value_ptr"
        case .sun_dtor_start: "DW_AT_SUN_dtor_start"
        case .sun_dtor_length: "DW_AT_SUN_dtor_length"
        case .sun_dtor_state_initial: "DW_AT_SUN_dtor_state_initial"
        case .sun_dtor_state_final: "DW_AT_SUN_dtor_state_final"
        case .sun_dtor_state_deltas: "DW_AT_SUN_dtor_state_deltas"
        case .sun_import_by_lname: "DW_AT_SUN_import_by_lname"
        case .sun_f90_use_only: "DW_AT_SUN_f90_use_only"
        case .sun_namelist_spec: "DW_AT_SUN_namelist_spec"
        case .sun_is_omp_child_func: "DW_AT_SUN_is_omp_child_func"
        case .sun_fortran_main_alias: "DW_AT_SUN_fortran_main_alias"
        case .sun_fortran_based: "DW_AT_SUN_fortran_based"
        case .altium_loclist: "DW_AT_ALTIUM_loclist"
        case .use_gnat_descriptive_type: "DW_AT_use_GNAT_descriptive_type"
        case .gnat_descriptive_type: "DW_AT_GNAT_descriptive_type"
        case .gnu_numerator: "DW_AT_GNU_numerator"
        case .gnu_denominator: "DW_AT_GNU_denominator"
        case .gnu_bias: "DW_AT_GNU_bias"
        case .go_kind: "DW_AT_go_kind"
        case .go_key: "DW_AT_go_key"
        case .go_elem: "DW_AT_go_elem"
        case .go_embedded_field: "DW_AT_go_embedded_field"
        case .go_runtime_type: "DW_AT_go_runtime_type"
        case .upc_threads_scaled: "DW_AT_upc_threads_scaled"
        case .ibm_wsa_addr: "DW_AT_IBM_wsa_addr"
        case .ibm_home_location: "DW_AT_IBM_home_location"
        case .ibm_alt_srcview: "DW_AT_IBM_alt_srcview"
        case .pgi_lbase: "DW_AT_PGI_lbase"
        case .pgi_soffset: "DW_AT_PGI_soffset"
        case .pgi_lstride: "DW_AT_PGI_lstride"
        case .borland_property_read: "DW_AT_BORLAND_property_read"
        case .borland_property_write: "DW_AT_BORLAND_property_write"
        case .borland_property_implements: "DW_AT_BORLAND_property_implements"
        case .borland_property_index: "DW_AT_BORLAND_property_index"
        case .borland_property_default: "DW_AT_BORLAND_property_default"
        case .borland_delphi_unit: "DW_AT_BORLAND_Delphi_unit"
        case .borland_delphi_class: "DW_AT_BORLAND_Delphi_class"
        case .borland_delphi_record: "DW_AT_BORLAND_Delphi_record"
        case .borland_delphi_metaclass: "DW_AT_BORLAND_Delphi_metaclass"
        case .borland_delphi_constructor: "DW_AT_BORLAND_Delphi_constructor"
        case .borland_delphi_destructor: "DW_AT_BORLAND_Delphi_destructor"
        case .borland_delphi_anonymous_method: "DW_AT_BORLAND_Delphi_anonymous_method"
        case .borland_delphi_interface: "DW_AT_BORLAND_Delphi_interface"
        case .borland_delphi_abi: "DW_AT_BORLAND_Delphi_ABI"
        case .borland_delphi_return: "DW_AT_BORLAND_Delphi_return"
        case .borland_delphi_frameptr: "DW_AT_BORLAND_Delphi_frameptr"
        case .borland_closure: "DW_AT_BORLAND_closure"
        case .llvm_include_path: "DW_AT_LLVM_include_path"
        case .llvm_config_macros: "DW_AT_LLVM_config_macros"
        case .llvm_sysroot: "DW_AT_LLVM_sysroot"
        case .llvm_tag_offset: "DW_AT_LLVM_tag_offset"
        case .llvm_ptrauth_key: "DW_AT_LLVM_ptrauth_key"
        case .llvm_ptrauth_address_discriminated: "DW_AT_LLVM_ptrauth_address_discriminated"
        case .llvm_ptrauth_extra_discriminator: "DW_AT_LLVM_ptrauth_extra_discriminator"
        case .llvm_apinotes: "DW_AT_LLVM_apinotes"
        case .llvm_active_lane: "DW_AT_LLVM_active_lane"
        case .llvm_ptrauth_isa_pointer: "DW_AT_LLVM_ptrauth_isa_pointer"
        case .llvm_augmentation: "DW_AT_LLVM_augmentation"
        case .llvm_ptrauth_authenticates_null_values: "DW_AT_LLVM_ptrauth_authenticates_null_values"
        case .llvm_lanes: "DW_AT_LLVM_lanes"
        case .llvm_ptrauth_authentication_mode: "DW_AT_LLVM_ptrauth_authentication_mode"
        case .llvm_lane_pc: "DW_AT_LLVM_lane_pc"
        case .llvm_num_extra_inhabitants: "DW_AT_LLVM_num_extra_inhabitants"
        case .llvm_vector_size: "DW_AT_LLVM_vector_size"
        case .llvm_stmt_sequence: "DW_AT_LLVM_stmt_sequence"
        case .apple_optimized: "DW_AT_APPLE_optimized"
        case .apple_flags: "DW_AT_APPLE_flags"
        case .apple_isa: "DW_AT_APPLE_isa"
        case .apple_block: "DW_AT_APPLE_block"
        case .apple_major_runtime_vers: "DW_AT_APPLE_major_runtime_vers"
        case .apple_runtime_class: "DW_AT_APPLE_runtime_class"
        case .apple_omit_frame_ptr: "DW_AT_APPLE_omit_frame_ptr"
        case .apple_property_name: "DW_AT_APPLE_property_name"
        case .apple_property_getter: "DW_AT_APPLE_property_getter"
        case .apple_property_setter: "DW_AT_APPLE_property_setter"
        case .apple_property_attribute: "DW_AT_APPLE_property_attribute"
        case .apple_objc_complete_type: "DW_AT_APPLE_objc_complete_type"
        case .apple_property: "DW_AT_APPLE_property"
        case .apple_objc_direct: "DW_AT_APPLE_objc_direct"
        case .apple_sdk: "DW_AT_APPLE_sdk"
        case .apple_origin: "DW_AT_APPLE_origin"
        case .apple_enum_kind: "DW_AT_APPLE_enum_kind"
        }
    }
}
