//
//  DWARFFileEntry.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//  
//

extension DWARFFileEntry {
    public static func load(
        at offset: Int,
        for formats: [DWARFFileEntryFormat],
        in machO: MachOFile,
        dwarfFormat: DWARFFormat,
        addressSize: Int
    ) throws -> Self? {
        try _load(
            at: offset,
            for: formats,
            in: machO,
            dwarfFormat: dwarfFormat,
            addressSize: addressSize
        )
    }
}
