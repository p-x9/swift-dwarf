//
//  DWARFRangeListTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//
//

extension DWARFRangeListTable {
    /// Resolves one DWARF5 list. The offset is relative to the offset array,
    /// matching the coordinate system used by `operations(for:entryOffset:)`.
    public func ranges(
        for unit: DWARFCompilationUnit,
        in elf: ELFFile,
        entryOffset: Int
    ) -> [DWARFRange]? {
        _ranges(at: entryOffset, for: unit, in: elf)
    }

    public func offsets(for elf: ELFFile) throws -> [Int] {
        try _offsets(for: elf)
    }
}

extension DWARFRangeListTable {
    public func operations(
        for elf: ELFFile,
        entryOffset: Int? = nil
    ) throws -> Operations {
        try _operations(for: elf, entryOffset: entryOffset)
    }
}

extension DWARFRangeListTable {
    public static func load(
        at offset: Int,
        in elf: ELFFile
    ) throws -> Self? {
        try _load(at: offset, in: elf)
    }
}
