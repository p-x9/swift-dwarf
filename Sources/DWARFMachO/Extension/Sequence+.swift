//
//  Sequence+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//  
//

extension Sequence<DWARFRangeOperation> {
    /// Resolves completed lists in order using the supplied unit's address context.
    /// Stops before the first invalid or unterminated list.
    public func ranges(
        for unit: DWARFCompilationUnit,
        in machO: MachOFile
    ) -> [[DWARFRange]] {
        _ranges(for: unit, in: machO)
    }
}

extension Sequence<DWARFLocationOperation> {
    /// Resolves completed lists in order using the supplied unit's address context.
    /// Stops before the first invalid or unterminated list.
    public func locations(
        for unit: DWARFCompilationUnit,
        in machO: MachOFile
    ) -> [[DWARFLocation]] {
        _locations(for: unit, in: machO)
    }
}
