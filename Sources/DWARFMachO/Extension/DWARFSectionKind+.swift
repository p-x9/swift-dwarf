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
        "__" + rawValue
    }
}
