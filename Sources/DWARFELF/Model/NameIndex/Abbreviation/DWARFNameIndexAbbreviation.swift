//
//  DWARFNameIndexAbbreviation.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//
//

extension DWARFNameIndexAbbreviation {
    public static func load(
        at offset: Int,
        from elf: ELFFile,
        isTerminator: inout Bool
    ) -> Self? {
        _load(at: offset, from: elf, isTerminator: &isTerminator)
    }
}
