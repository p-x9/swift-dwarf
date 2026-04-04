//
//  DWARFLineTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//  
//

extension DWARFLineTable {
    public func operations(for machO: MachOFile) throws -> Operations {
        try _operations(for: machO)
    }
}

extension DWARFLineTable {
    public static func load(
        at offset: Int,
        in machO: MachOFile
    ) throws -> Self? {
        try _load(at: offset, in: machO)
    }
}
