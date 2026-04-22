//
//  DWARFFileEntryFormat.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//
//

extension DWARFFileEntryFormat {
    public static func load(
        at offset: Int,
        in elf: ELFFile
    ) throws -> Self? {
        try _load(at: offset, in: elf)
    }
}
