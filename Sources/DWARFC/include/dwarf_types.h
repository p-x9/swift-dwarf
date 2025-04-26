//
//  dwarf_types.h
//  swift-dwarf
//
//  Created by p-x9 on 2025/04/26
//  
//

#ifndef dwarf_types_h
#define dwarf_types_h

#include <stdint.h>

struct dwarf_init_len64 {
    uint32_t _pad;
    uint64_t value;
};

struct dwarf_init_len32 {
    uint32_t value;
};

typedef int8_t dwarf_sbyte;
typedef uint8_t dwarf_ubyte;

typedef uint32_t dwarf_uhalf64;
typedef uint16_t dwarf_uhalf32;

typedef uint64_t dwarf_uword64;
typedef uint32_t dwarf_uword32;

#endif /* dwarf_types_h */
