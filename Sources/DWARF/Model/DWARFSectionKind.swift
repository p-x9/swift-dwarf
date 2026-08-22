//
//  DWARFSectionKind.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/29
//  
//

import Foundation

public enum DWARFSectionKind: String, Sendable {
    case debug_abbrev
    case debug_info
    case debug_line
    case debug_str
    case debug_line_str
    /// DWARF v5 string offsets section.
    case debug_str_offsets
    case debug_addr
    case debug_rnglists
    case debug_loclists
    case debug_aranges
    case debug_names
}
