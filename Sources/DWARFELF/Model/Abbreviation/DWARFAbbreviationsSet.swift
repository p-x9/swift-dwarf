//
//  DWARFAbbreviationsSet.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/23
//
//

import Foundation
import ELFKit
import DWARF

extension DWARFAbbreviationsSet {
    public static func load(
        at offset: Int,
        from elf: ELFFile,
        abbrevSectionStartOffset: Int
    ) -> Self? {
        _load(
            at: offset,
            from: elf,
            abbrevSectionStartOffset: abbrevSectionStartOffset
        )
    }
}
