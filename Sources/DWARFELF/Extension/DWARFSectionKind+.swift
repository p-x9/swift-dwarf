//
//  DWARFSectionKind+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/12
//  
//

import DWARF

extension DWARFSectionKind {
    var elfName: String {
        "." + rawValue
    }
}
