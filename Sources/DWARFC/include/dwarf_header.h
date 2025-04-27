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

#endif /* dwarf_header_h */
