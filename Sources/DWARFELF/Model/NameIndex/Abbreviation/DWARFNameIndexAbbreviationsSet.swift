//
//  DWARFNameIndexAbbreviationsSet.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//
//

extension DWARFNameIndexAbbreviationsSet {
    public static func load(
        at offset: Int,
        from elf: ELFFile
    ) -> Self? {
        _load(at: offset, from: elf)
    }
}
