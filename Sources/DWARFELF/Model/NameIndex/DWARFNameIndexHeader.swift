//
//  DWARFNameIndexHeader.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//
//

extension DWARFNameIndexHeader {
    public func augmentation(in elf: ELFFile) -> String {
        _augmentation(in: elf)
    }
}

extension DWARFNameIndexHeader {
    public static func load(
        at offset: Int,
        from elf: ELFFile
    ) throws -> Self? {
        try _load(at: offset, from: elf)
    }
}
