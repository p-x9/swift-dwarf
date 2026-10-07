//
//  DWARFDebugInfoEntry.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/04
//
//

import Foundation
@_spi(Support) import ELFKit
import DWARF

extension DWARFDebugInfoEntry {
    public static func load(
        at offset: Int,
        from elf: ELFFile,
        dwarfFormat: DWARFFormat,
        abbreviationsSet: DWARFAbbreviationsSet,
        addressSize: Int
    ) -> Self? {
        _load(
            at: offset,
            from: elf,
            dwarfFormat: dwarfFormat,
            abbreviationsSet: abbreviationsSet,
            addressSize: addressSize
        )
    }
}
