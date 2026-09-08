//
//  DWARFLocationListTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//  
//

extension DWARFLocationListTable {
    public func offsets(for machO: MachOFile) throws -> [Int] {
        try _offsets(for: machO)
    }
}

extension DWARFLocationListTable {
    public func operations(
        for machO: MachOFile,
        entryOffset: Int? = nil
    ) throws -> Operations {
        try _operations(
            for: machO,
            entryOffset: entryOffset
        )
    }
}

extension DWARFLocationListTable {
    public static func load(
        at offset: Int,
        in machO: MachOFile
    ) throws -> Self? {
        try _load(at: offset, in: machO)
    }
}
