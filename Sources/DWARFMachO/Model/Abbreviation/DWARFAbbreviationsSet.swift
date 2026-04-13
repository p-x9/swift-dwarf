//
//  DWARFAbbreviationsSet.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/23
//  
//

import Foundation
import MachOKit
import DWARF

extension DWARFAbbreviationsSet {
    public static func load(
        at offset: Int,
        from machO: MachOFile,
        abbrevSectionStartOffset: Int
    ) -> Self? {
        _load(
            at: offset,
            from: machO,
            abbrevSectionStartOffset: abbrevSectionStartOffset
        )
    }
}
