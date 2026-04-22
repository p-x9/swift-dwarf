//
//  DWARFNameIndexEntry.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//
//

extension DWARFNameIndexEntry {
    public static func load(
        at offset: Int,
        from elf: ELFFile,
        dwarfFormat: DWARFFormat,
        abbreviationsSet: DWARFNameIndexAbbreviationsSet,
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
