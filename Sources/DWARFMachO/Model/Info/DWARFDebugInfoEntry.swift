//
//  DWARFDebugInfoEntry.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/04
//  
//

import Foundation
@_spi(Support) import MachOKit
import DWARF

extension DWARFDebugInfoEntry {
    public static func load(
        at offset: Int,
        from machO: MachOFile,
        dwarfFormat: DWARFFormat,
        abbreviationsSet: DWARFAbbreviationsSet,
        addressSize: Int
    ) -> Self? {
        _load(
            at: offset,
            from: machO,
            dwarfFormat: dwarfFormat,
            abbreviationsSet: abbreviationsSet,
            addressSize: addressSize
        )
    }
}
