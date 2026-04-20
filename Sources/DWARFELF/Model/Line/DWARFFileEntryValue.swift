//
//  DWARFFileEntryValue.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//
//

extension DWARFFileEntryValue {
    public static func load(
        at offset: Int,
        for format: DWARFFileEntryFormat,
        in elf: ELFFile,
        dwarfFormat: DWARFFormat,
        addressSize: Int
    ) throws -> Self? {
        try _load(
            at: offset,
            for: format,
            in: elf,
            dwarfFormat: dwarfFormat,
            addressSize: addressSize
        )
    }
}
