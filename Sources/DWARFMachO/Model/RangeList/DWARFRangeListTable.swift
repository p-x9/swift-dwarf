//
//  DWARFRangeListTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//  
//

extension DWARFRangeListTable {
    /// Resolves all completed lists using the supplied unit's address context.
    /// Stops before the first invalid or unterminated list.
    /// Returns nil for an incompatible unit or an unreadable table.
    public func ranges(
        for unit: DWARFCompilationUnit,
        in machO: MachOFile
    ) -> [[DWARFRange]]? {
        _ranges(for: unit, in: machO)
    }

    /// Resolves one DWARF5 list. The offset is relative to the offset array,
    /// matching the coordinate system used by `operations(for:entryOffset:)`.
    public func ranges(
        for unit: DWARFCompilationUnit,
        in machO: MachOFile,
        entryOffset: Int
    ) -> [DWARFRange]? {
        _ranges(at: entryOffset, for: unit, in: machO)
    }

    public func offsets(for machO: MachOFile) throws -> [Int] {
        try _offsets(for: machO)
    }
}

extension DWARFRangeListTable {
    public func operations(
        for machO: MachOFile,
        entryOffset: Int? = nil
    ) throws -> Operations {
        try _operations(for: machO, entryOffset: entryOffset)
    }
}

extension DWARFRangeListTable {
    public static func load(
        at offset: Int,
        in machO: MachOFile
    ) throws -> Self? {
        try _load(at: offset, in: machO)
    }
}
