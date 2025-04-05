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
//    case stride_size /* DWARF2 name */
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
//    case stride /* DWARF3 (do not use) */
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
    /// DW_AT_HP_block_index
    case hp_block_index
    /// DW_AT_lo_user
//    case lo_user
    /// DW_AT_MIPS_fde
    case mips_fde
    /// DW_AT_MIPS_loop_begin
    case mips_loop_begin
    /// DW_AT_MIPS_tail_loop_begin
    case mips_tail_loop_begin
    /// DW_AT_MIPS_epilog_begin
    case mips_epilog_begin
    /// DW_AT_MIPS_loop_unroll_factor
    case mips_loop_unroll_factor
    /// DW_AT_MIPS_software_pipeline_depth
    case mips_software_pipeline_depth
    /// DW_AT_MIPS_linkage_name
    case mips_linkage_name
    /// DW_AT_MIPS_stride
    case mips_stride
    /// DW_AT_MIPS_abstract_name
    case mips_abstract_name
    /// DW_AT_MIPS_clone_origin
    case mips_clone_origin
    /// DW_AT_MIPS_has_inlines
    case mips_has_inlines
    /// DW_AT_MIPS_stride_byte
    case mips_stride_byte
    /// DW_AT_MIPS_stride_elem
    case mips_stride_elem
    /// DW_AT_MIPS_ptr_dopetype
    case mips_ptr_dopetype
    /// DW_AT_MIPS_allocatable_dopetype
    case mips_allocatable_dopetype
    /// DW_AT_MIPS_assumed_shape_dopetype
    case mips_assumed_shape_dopetype
    /// DW_AT_MIPS_assumed_size
    case mips_assumed_size
    /// DW_AT_HP_unmodifiable
//    case hp_unmodifiable // TODO: conflict: MIPS
    /// DW_AT_HP_actuals_stmt_list
//    case hp_actuals_stmt_list // TODO: conflict: MIPS
    /// DW_AT_HP_proc_per_section
//    case hp_proc_per_section // TODO: conflict: MIPS
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
    /// DW_AT_VMS_rtnbeg_pd_address
    case vms_rtnbeg_pd_address
    /// DW_AT_ALTIUM_loclist
    case altium_loclist
    /// DW_AT_PGI_lbase
    case pgi_lbase
    /// DW_AT_PGI_soffset
    case pgi_soffset
    /// DW_AT_PGI_lstride
    case pgi_lstride
    /// DW_AT_upc_threads_scaled
    case upc_threads_scaled
    /// DW_AT_APPLE_ptrauth_key
    case apple_ptrauth_key
    /// DW_AT_APPLE_ptrauth_address_discriminated
    case apple_ptrauth_address_discriminated
    /// DW_AT_APPLE_ptrauth_extra_discriminator
    case apple_ptrauth_extra_discriminator
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
//        case numericCast(DW_AT_stride_size): self = .stride_size
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
//        case numericCast(DW_AT_stride): self = .stride
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
        case numericCast(DW_AT_HP_block_index): self = .hp_block_index
//        case numericCast(DW_AT_lo_user): self = .lo_user
        case numericCast(DW_AT_MIPS_fde): self = .mips_fde
        case numericCast(DW_AT_MIPS_loop_begin): self = .mips_loop_begin
        case numericCast(DW_AT_MIPS_tail_loop_begin): self = .mips_tail_loop_begin
        case numericCast(DW_AT_MIPS_epilog_begin): self = .mips_epilog_begin
        case numericCast(DW_AT_MIPS_loop_unroll_factor): self = .mips_loop_unroll_factor
        case numericCast(DW_AT_MIPS_software_pipeline_depth): self = .mips_software_pipeline_depth
        case numericCast(DW_AT_MIPS_linkage_name): self = .mips_linkage_name
        case numericCast(DW_AT_MIPS_stride): self = .mips_stride
        case numericCast(DW_AT_MIPS_abstract_name): self = .mips_abstract_name
        case numericCast(DW_AT_MIPS_clone_origin): self = .mips_clone_origin
        case numericCast(DW_AT_MIPS_has_inlines): self = .mips_has_inlines
        case numericCast(DW_AT_MIPS_stride_byte): self = .mips_stride_byte
        case numericCast(DW_AT_MIPS_stride_elem): self = .mips_stride_elem
        case numericCast(DW_AT_MIPS_ptr_dopetype): self = .mips_ptr_dopetype
        case numericCast(DW_AT_MIPS_allocatable_dopetype): self = .mips_allocatable_dopetype
        case numericCast(DW_AT_MIPS_assumed_shape_dopetype): self = .mips_assumed_shape_dopetype
        case numericCast(DW_AT_MIPS_assumed_size): self = .mips_assumed_size
//        case numericCast(DW_AT_HP_unmodifiable): self = .hp_unmodifiable
//        case numericCast(DW_AT_HP_actuals_stmt_list): self = .hp_actuals_stmt_list
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
        case numericCast(DW_AT_sf_names): self = .sf_names
        case numericCast(DW_AT_src_info): self = .src_info
        case numericCast(DW_AT_mac_info): self = .mac_info
        case numericCast(DW_AT_src_coords): self = .src_coords
        case numericCast(DW_AT_body_begin): self = .body_begin
        case numericCast(DW_AT_body_end): self = .body_end
        case numericCast(DW_AT_GNU_vector): self = .gnu_vector
        case numericCast(DW_AT_VMS_rtnbeg_pd_address): self = .vms_rtnbeg_pd_address
        case numericCast(DW_AT_ALTIUM_loclist): self = .altium_loclist
        case numericCast(DW_AT_PGI_lbase): self = .pgi_lbase
        case numericCast(DW_AT_PGI_soffset): self = .pgi_soffset
        case numericCast(DW_AT_PGI_lstride): self = .pgi_lstride
        case numericCast(DW_AT_upc_threads_scaled): self = .upc_threads_scaled
        case numericCast(DW_AT_APPLE_ptrauth_key): self = .apple_ptrauth_key
        case numericCast(DW_AT_APPLE_ptrauth_address_discriminated): self = .apple_ptrauth_address_discriminated
        case numericCast(DW_AT_APPLE_ptrauth_extra_discriminator): self = .apple_ptrauth_extra_discriminator
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
//        case .stride_size: numericCast(DW_AT_stride_size)
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
//        case .stride: numericCast(DW_AT_stride)
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
        case .hp_block_index: numericCast(DW_AT_HP_block_index)
//        case .lo_user: numericCast(DW_AT_lo_user)
        case .mips_fde: numericCast(DW_AT_MIPS_fde)
        case .mips_loop_begin: numericCast(DW_AT_MIPS_loop_begin)
        case .mips_tail_loop_begin: numericCast(DW_AT_MIPS_tail_loop_begin)
        case .mips_epilog_begin: numericCast(DW_AT_MIPS_epilog_begin)
        case .mips_loop_unroll_factor: numericCast(DW_AT_MIPS_loop_unroll_factor)
        case .mips_software_pipeline_depth: numericCast(DW_AT_MIPS_software_pipeline_depth)
        case .mips_linkage_name: numericCast(DW_AT_MIPS_linkage_name)
        case .mips_stride: numericCast(DW_AT_MIPS_stride)
        case .mips_abstract_name: numericCast(DW_AT_MIPS_abstract_name)
        case .mips_clone_origin: numericCast(DW_AT_MIPS_clone_origin)
        case .mips_has_inlines: numericCast(DW_AT_MIPS_has_inlines)
        case .mips_stride_byte: numericCast(DW_AT_MIPS_stride_byte)
        case .mips_stride_elem: numericCast(DW_AT_MIPS_stride_elem)
        case .mips_ptr_dopetype: numericCast(DW_AT_MIPS_ptr_dopetype)
        case .mips_allocatable_dopetype: numericCast(DW_AT_MIPS_allocatable_dopetype)
        case .mips_assumed_shape_dopetype: numericCast(DW_AT_MIPS_assumed_shape_dopetype)
        case .mips_assumed_size: numericCast(DW_AT_MIPS_assumed_size)
//        case .hp_unmodifiable: numericCast(DW_AT_HP_unmodifiable)
//        case .hp_actuals_stmt_list: numericCast(DW_AT_HP_actuals_stmt_list)
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
        case .sf_names: numericCast(DW_AT_sf_names)
        case .src_info: numericCast(DW_AT_src_info)
        case .mac_info: numericCast(DW_AT_mac_info)
        case .src_coords: numericCast(DW_AT_src_coords)
        case .body_begin: numericCast(DW_AT_body_begin)
        case .body_end: numericCast(DW_AT_body_end)
        case .gnu_vector: numericCast(DW_AT_GNU_vector)
        case .vms_rtnbeg_pd_address: numericCast(DW_AT_VMS_rtnbeg_pd_address)
        case .altium_loclist: numericCast(DW_AT_ALTIUM_loclist)
        case .pgi_lbase: numericCast(DW_AT_PGI_lbase)
        case .pgi_soffset: numericCast(DW_AT_PGI_soffset)
        case .pgi_lstride: numericCast(DW_AT_PGI_lstride)
        case .upc_threads_scaled: numericCast(DW_AT_upc_threads_scaled)
        case .apple_ptrauth_key: numericCast(DW_AT_APPLE_ptrauth_key)
        case .apple_ptrauth_address_discriminated: numericCast(DW_AT_APPLE_ptrauth_address_discriminated)
        case .apple_ptrauth_extra_discriminator: numericCast(DW_AT_APPLE_ptrauth_extra_discriminator)
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
//        case .stride_size: "DW_AT_stride_size"
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
//        case .stride: "DW_AT_stride"
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
        case .hp_block_index: "DW_AT_HP_block_index"
//        case .lo_user: "DW_AT_lo_user"
        case .mips_fde: "DW_AT_MIPS_fde"
        case .mips_loop_begin: "DW_AT_MIPS_loop_begin"
        case .mips_tail_loop_begin: "DW_AT_MIPS_tail_loop_begin"
        case .mips_epilog_begin: "DW_AT_MIPS_epilog_begin"
        case .mips_loop_unroll_factor: "DW_AT_MIPS_loop_unroll_factor"
        case .mips_software_pipeline_depth: "DW_AT_MIPS_software_pipeline_depth"
        case .mips_linkage_name: "DW_AT_MIPS_linkage_name"
        case .mips_stride: "DW_AT_MIPS_stride"
        case .mips_abstract_name: "DW_AT_MIPS_abstract_name"
        case .mips_clone_origin: "DW_AT_MIPS_clone_origin"
        case .mips_has_inlines: "DW_AT_MIPS_has_inlines"
        case .mips_stride_byte: "DW_AT_MIPS_stride_byte"
        case .mips_stride_elem: "DW_AT_MIPS_stride_elem"
        case .mips_ptr_dopetype: "DW_AT_MIPS_ptr_dopetype"
        case .mips_allocatable_dopetype: "DW_AT_MIPS_allocatable_dopetype"
        case .mips_assumed_shape_dopetype: "DW_AT_MIPS_assumed_shape_dopetype"
        case .mips_assumed_size: "DW_AT_MIPS_assumed_size"
//        case .hp_unmodifiable: "DW_AT_HP_unmodifiable"
//        case .hp_actuals_stmt_list: "DW_AT_HP_actuals_stmt_list"
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
        case .sf_names: "DW_AT_sf_names"
        case .src_info: "DW_AT_src_info"
        case .mac_info: "DW_AT_mac_info"
        case .src_coords: "DW_AT_src_coords"
        case .body_begin: "DW_AT_body_begin"
        case .body_end: "DW_AT_body_end"
        case .gnu_vector: "DW_AT_GNU_vector"
        case .vms_rtnbeg_pd_address: "DW_AT_VMS_rtnbeg_pd_address"
        case .altium_loclist: "DW_AT_ALTIUM_loclist"
        case .pgi_lbase: "DW_AT_PGI_lbase"
        case .pgi_soffset: "DW_AT_PGI_soffset"
        case .pgi_lstride: "DW_AT_PGI_lstride"
        case .upc_threads_scaled: "DW_AT_upc_threads_scaled"
        case .apple_ptrauth_key: "DW_AT_APPLE_ptrauth_key"
        case .apple_ptrauth_address_discriminated: "DW_AT_APPLE_ptrauth_address_discriminated"
        case .apple_ptrauth_extra_discriminator: "DW_AT_APPLE_ptrauth_extra_discriminator"
        }
    }
}
