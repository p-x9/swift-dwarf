//
//  DWARFMachOSection.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/29
//  
//

import Foundation

public enum DWARFMachOSection: String {
    case __debug_abbrev
    case __debug_info
    case __debug_line
    case __debug_str
    case __debug_line_str
    case __debug_str_offs
    case __debug_addr
    case __debug_rnglists
    case __debug_loclists
    case __debug_aranges
    case __debug_names
}
