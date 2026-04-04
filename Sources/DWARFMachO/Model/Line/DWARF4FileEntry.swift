//
//  DWARF4FileEntry.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//  
//

extension DWARF4FileEntry {
    public static func load(
        at offset: Int,
        in machO: MachOFile
    ) throws -> Self? {
        try _load(at: offset, in: machO)
    }
}
