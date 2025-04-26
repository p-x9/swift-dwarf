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
    dwarf_uhalf64 version;
    dwarf_uword64 padding;
    dwarf_uword64 comp_unit_count;
    dwarf_uword64 local_type_unit_count;
    dwarf_uword64 foreign_type_unit_count;
    dwarf_uword64 bucket_count;
    dwarf_uword64 name_count;
    dwarf_uword64 abbrev_table_size;
    dwarf_uword64 augmentation_string_size;
    dwarf_uword64 augmentation_string;
};

struct dwarf_name_index_header32_t {
    struct dwarf_init_len32 unit_length;
    dwarf_uhalf32 version;
    dwarf_uword32 padding;
    dwarf_uword32 comp_unit_count;
    dwarf_uword32 local_type_unit_count;
    dwarf_uword32 foreign_type_unit_count;
    dwarf_uword32 bucket_count;
    dwarf_uword32 name_count;
    dwarf_uword32 abbrev_table_size;
    dwarf_uword32 augmentation_string_size;
    dwarf_uword32 augmentation_string;
};

#endif /* dwarf_header_h */
