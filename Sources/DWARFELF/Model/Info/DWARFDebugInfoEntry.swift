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
    /// Loads the DWARF3/4 range list referenced by this DIE's attribute.
    /// Returns nil for constants, unsupported forms, or other DWARF versions.
    public func rangeList(
        for unit: DWARFCompilationUnit,
        in elf: ELFFile,
        attribute: DWARFAttribute = .ranges
    ) -> DWARF3RangeList? {
        guard let offset = _rangeListSectionOffset(
            for: unit, attribute: attribute
        ) else { return nil }
        return .load(at: offset, for: unit, in: elf)
    }

    /// Loads the DWARF3/4 location list referenced by this DIE's attribute.
    /// Inline expressions and constant-valued attributes do not reference lists.
    public func locationList(
        for unit: DWARFCompilationUnit,
        in elf: ELFFile,
        attribute: DWARFAttribute = .location
    ) -> DWARF3LocationList? {
        guard let offset = _locationListSectionOffset(
            for: unit, attribute: attribute
        ) else { return nil }
        return .load(at: offset, for: unit, in: elf)
    }

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
