//
//  DWARFNameIndexHeader.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//  
//

extension DWARFNameIndexHeader {
    public func augmentation(in machO: MachOFile) -> String {
        _augmentation(in: machO)
    }
}

extension DWARFNameIndexHeader {
    public static func load(
        at offset: Int,
        from machO: MachOFile
    ) throws -> Self? {
        try _load(at: offset, from: machO)
    }
}
