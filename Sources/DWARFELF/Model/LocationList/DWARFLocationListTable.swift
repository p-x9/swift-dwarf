//
//  DWARFLocationListTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//
//

extension DWARFLocationListTable {
    /// Resolves all completed lists using the supplied unit's address context.
    /// Stops before the first invalid or unterminated list.
    /// Returns nil for an incompatible unit or an unreadable table.
    public func locations(
        for unit: DWARFCompilationUnit,
        in elf: ELFFile
    ) -> [[DWARFLocation]]? {
        _locations(for: unit, in: elf)
    }

    /// Resolves one DWARF5 list. The offset is relative to the offset array,
    /// matching the coordinate system used by operations(for:entryOffset:).
    public func locations(
        for unit: DWARFCompilationUnit,
        in elf: ELFFile,
        entryOffset: Int
    ) -> [DWARFLocation]? {
        _locations(at: entryOffset, for: unit, in: elf)
    }

    public func offsets(for elf: ELFFile) throws -> [Int] {
        try _offsets(for: elf)
    }
}

extension DWARFLocationListTable {
    public func operations(
        for elf: ELFFile,
        entryOffset: Int? = nil
    ) throws -> Operations {
        try _operations(
            for: elf,
            entryOffset: entryOffset
        )
    }
}

extension DWARFLocationListTable {
    public static func load(
        at offset: Int,
        in elf: ELFFile
    ) throws -> Self? {
        try _load(at: offset, in: elf)
    }
}
