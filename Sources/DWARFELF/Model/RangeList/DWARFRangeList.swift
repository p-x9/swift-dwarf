//
//  DWARFRangeList.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//
//

extension DWARFRangeList {
    public func offsets(for elf: ELFFile) throws -> [Int] {
        try _offsets(for: elf)
    }
}

extension DWARFRangeList {
    public func operations(
        for elf: ELFFile,
        entryOffset: Int = 0
    ) throws -> Operations {
        try _operations(for: elf, entryOffset: entryOffset)
    }
}

extension DWARFRangeList {
    public static func load(
        at offset: Int,
        in elf: ELFFile
    ) throws -> Self? {
        try _load(at: offset, in: elf)
    }
}
