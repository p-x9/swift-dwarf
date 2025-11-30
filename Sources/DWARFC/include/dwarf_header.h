//
//  dwarf_header.h
//  swift-dwarf
//
//  Created by p-x9 on 2025/04/06
//  
//

#ifndef dwarf_header_h
#define dwarf_header_h

#include <stdint.h>
#include <dwarf_types.h>

#pragma pack(push, 1)

// .debug_names section
// DWARF5 p143
struct dwarf_name_index_header64_t {
    struct dwarf_init_len64 unit_length;
    dwarf_uhalf version;
    dwarf_uhalf padding;
    dwarf_uword comp_unit_count;
    dwarf_uword local_type_unit_count;
    dwarf_uword foreign_type_unit_count;
    dwarf_uword bucket_count;
    dwarf_uword name_count;
    dwarf_uword abbrev_table_size;
    dwarf_uword augmentation_string_size;
    uint64_t augmentation_string;
};

struct dwarf_name_index_header32_t {
    struct dwarf_init_len32 unit_length;
    dwarf_uhalf version;
    dwarf_uhalf padding;
    dwarf_uword comp_unit_count;
    dwarf_uword local_type_unit_count;
    dwarf_uword foreign_type_unit_count;
    dwarf_uword bucket_count;
    dwarf_uword name_count;
    dwarf_uword abbrev_table_size;
    dwarf_uword augmentation_string_size;
    uint32_t augmentation_string;
};

// .debug_aranges section
// DWARF5 p147, p235
struct dwarf_aranges_header64_t {
    struct dwarf_init_len64 unit_length;
    dwarf_uhalf version;
    uint64_t debug_info_offset;
    dwarf_ubyte address_size;
    dwarf_ubyte segment_selector_size;
};

struct dwarf_aranges_header32_t {
    struct dwarf_init_len32 unit_length;
    dwarf_uhalf version;
    uint32_t debug_info_offset;
    dwarf_ubyte address_size;
    dwarf_ubyte segment_selector_size;
};

// .debug_line section
// DWARF4 p112
struct dwarf4_line_header64_t {
    struct dwarf_init_len64 unit_length;
    dwarf_uhalf version;
    uint64_t header_length; // 64/32
    dwarf_ubyte minimum_instruction_length;
    dwarf_ubyte maximum_operations_per_instruction;
    dwarf_ubyte default_is_stmt;
    dwarf_sbyte line_base;
    dwarf_ubyte line_range;
    dwarf_ubyte opcode_base;
    // uint8_t[] standard_opcode_lengths; // array of ubyte (size: opcode_base - 1)
    // uint64_t include_directories; // sequence of path names
    // uint64_t file_names; // sequence of file names
};

struct dwarf4_line_header32_t {
    struct dwarf_init_len32 unit_length;
    dwarf_uhalf version;
    uint32_t header_length; // 64/32
    dwarf_ubyte minimum_instruction_length;
    dwarf_ubyte maximum_operations_per_instruction;
    dwarf_ubyte default_is_stmt;
    dwarf_sbyte line_base;
    dwarf_ubyte line_range;
    dwarf_ubyte opcode_base;
    // uint8_t[] standard_opcode_lengths; // array of ubyte (size: opcode_base - 1)
    // uint32_t include_directories; // sequence of path names
    // uint32_t file_names; // sequence of file names
};

// .debug_line section
// DWARF5 p154
struct dwarf5_line_header64_t {
    struct dwarf_init_len64 unit_length;
    dwarf_uhalf version;
    dwarf_ubyte address_size;
    dwarf_ubyte segment_selector_size;
    uint64_t header_length; // 64/32
    dwarf_ubyte minimum_instruction_length;
    dwarf_ubyte maximum_operations_per_instruction;
    dwarf_ubyte default_is_stmt;
    dwarf_sbyte line_base;
    dwarf_ubyte line_range;
    dwarf_ubyte opcode_base;
//    uint8_t[] standard_opcode_lengths; // array of ubyte (size: opcode_base - 1)
//    dwarf_ubyte directory_entry_format_count;
//    uint64_t[] directory_entry_format; // sequence of ULEB128 pairs
//    uint64_t directories_count; // ULEB128
//    uint64_t directories; // sequence of directory names
//    dwarf_ubyte file_name_entry_format_count;
//    uint64_t file_name_entry_format; // sequence of ULEB128 pairs
//    uint64_t file_names_count; // ULEB128
//    uint64_t file_names; // sequence of file names
};

struct dwarf5_line_header32_t {
    struct dwarf_init_len32 unit_length;
    dwarf_uhalf version;
    dwarf_ubyte address_size;
    dwarf_ubyte segment_selector_size;
    uint32_t header_length;
    dwarf_ubyte minimum_instruction_length;
    dwarf_ubyte maximum_operations_per_instruction;
    dwarf_ubyte default_is_stmt;
    dwarf_sbyte line_base;
    dwarf_ubyte line_range;
    dwarf_ubyte opcode_base;
//    uint8_t[] standard_opcode_lengths; // array of ubyte (size: opcode_base - 1)
//    dwarf_ubyte directory_entry_format_count;
//    uint32_t directory_entry_format; // sequence of ULEB128 pairs
//    uint32_t directories_count; // ULEB128
//    uint32_t directories; // sequence of directory names
//    dwarf_ubyte file_name_entry_format_count;
//    uint32_t file_name_entry_format; // sequence of ULEB128 pairs
//    uint32_t file_names_count; // ULEB128
//    uint32_t file_names; // sequence of file names
};

// .debug_macro .debug_macinfo section
// DWARF5 p165
struct dwarf_macro_header64_t {
    dwarf_uhalf version;
    dwarf_ubyte flags;
    uint64_t debug_line_offset;
    uint64_t opcode_operands_table; // leb128
};

/* ------- .debug_info section ------- */

struct dwarf4_cu_header64_t {
    struct dwarf_init_len64 unit_length;
    dwarf_uhalf version; // 3-4
    uint64_t debug_abbrev_offset;
    dwarf_ubyte address_size;
};

struct dwarf4_cu_header32_t {
    struct dwarf_init_len32 unit_length;
    dwarf_uhalf version; // 3-4
    uint32_t debug_abbrev_offset;
    dwarf_ubyte address_size;
};

struct dwarf4_tu_header64_t {
    struct dwarf_init_len64 unit_length;
    dwarf_uhalf version; // 4
    uint64_t debug_abbrev_offset;
    dwarf_ubyte address_size;
    uint64_t type_signature;
    uint64_t type_offset;
};

struct dwarf4_tu_header32_t {
    struct dwarf_init_len32 unit_length;
    dwarf_uhalf version; // 4
    uint32_t debug_abbrev_offset;
    dwarf_ubyte address_size;
    uint64_t type_signature;
    uint32_t type_offset;
};

// DWARF Version 5 Compilation Unit Header (Full, Partial, Skeleton Unit)
// (ref: DWARF5.pdf Sections 7.5.1.1, 7.5.1.2)
struct dwarf5_cu_header64_t {
    struct dwarf_init_len64 unit_length;
    dwarf_uhalf version; // 5
    dwarf_ubyte unit_type;
    dwarf_ubyte address_size;
    uint64_t debug_abbrev_offset;
    uint8_t dwo_id ; // skelton only
};

struct dwarf5_cu_header32_t {
    struct dwarf_init_len32 unit_length;
    dwarf_uhalf version; // 5
    dwarf_ubyte unit_type;
    dwarf_ubyte address_size;
    uint32_t debug_abbrev_offset;
    uint8_t dwo_id ; // skelton only
};

// DWARF Version 5 Type Unit Header
// (ref: DWARF5.pdf Section 7.5.1.3)
struct dwarf5_tu_header64_t {
    struct dwarf_init_len64 unit_length;
    dwarf_uhalf version; // 5
    dwarf_ubyte unit_type;
    dwarf_ubyte address_size;
    uint64_t debug_abbrev_offset;
    uint64_t type_signature;
    uint64_t type_offset;
};

struct dwarf5_tu_header32_t {
    struct dwarf_init_len32 unit_length;
    dwarf_uhalf version; // 5
    dwarf_ubyte unit_type;
    dwarf_ubyte address_size;
    uint32_t debug_abbrev_offset;
    uint64_t type_signature;
    uint32_t type_offset;
};

// DWARF Version 5 String Offsets Table Header
// (ref: DWARF5.pdf Section 7.26, p240)
struct dwarf5_str_offsets_header64_t {
    struct dwarf_init_len64 unit_length;
    dwarf_uhalf version; // 5
    dwarf_uhalf padding;
};

struct dwarf5_str_offsets_header32_t {
    struct dwarf_init_len32 unit_length;
    dwarf_uhalf version; // 5
    dwarf_uhalf padding;
};

// DWARF Version 5 Address Table Header
// (ref: DWARF5.pdf Section 7.27, p241)
struct dwarf5_addrs_header64_t {
    struct dwarf_init_len64 unit_length;
    dwarf_uhalf version; // 5
    dwarf_ubyte address_size;
    dwarf_ubyte segment_selector_size;
};

struct dwarf5_addrs_header32_t {
    struct dwarf_init_len32 unit_length;
    dwarf_uhalf version; // 5
    dwarf_ubyte address_size;
    dwarf_ubyte segment_selector_size;
};

// DWARF Version 5 Range List Header
// (ref: DWARF5.pdf Section 7.28, p242)
struct dwarf5_rnglist_header64_t {
    struct dwarf_init_len64 unit_length;
    dwarf_uhalf version; // 5
    dwarf_ubyte address_size;
    dwarf_ubyte segment_selector_size;
    dwarf_uword offset_entry_count;
};

struct dwarf5_rnglist_header32_t {
    struct dwarf_init_len32 unit_length;
    dwarf_uhalf version; // 5
    dwarf_ubyte address_size;
    dwarf_ubyte segment_selector_size;
    dwarf_uword offset_entry_count;
};

struct dwarf5_loclist_header64_t {
    struct dwarf_init_len64 unit_length;
    dwarf_uhalf version; // 5
    dwarf_ubyte address_size;
    dwarf_ubyte segment_selector_size;
    dwarf_uword offset_entry_count;
};

struct dwarf5_loclist_header32_t {
    struct dwarf_init_len32 unit_length;
    dwarf_uhalf version; // 5
    dwarf_ubyte address_size;
    dwarf_ubyte segment_selector_size;
    dwarf_uword offset_entry_count;
};

#pragma pack(pop)

#endif /* dwarf_header_h */
