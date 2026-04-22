//
//  DWARFNameIndexNameTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//
//

extension DWARFNameIndexNameTable {
    public func strings(
        in elf: ELFFile
    ) -> [String]? {
        _strings(in: elf)
    }
}
