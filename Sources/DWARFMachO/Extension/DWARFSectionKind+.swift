//
//  DWARFSectionKind+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/04
//  
//

import DWARF

extension DWARFSectionKind {
    var machOName: String {
        switch self {
        case .debug_str_offsets:
            // Mach-O section names are limited to 16 bytes by the `sectname`
            // field in `section` and `section_64`, so LLVM uses the shortened
            // `__debug_str_offs` spelling. See `<mach-o/loader.h>` and
            // `MCObjectFileInfo::initMachOMCObjectFileInfo` in LLVM.
            "__debug_str_offs"
        default:
            "__" + rawValue
        }
    }
}
