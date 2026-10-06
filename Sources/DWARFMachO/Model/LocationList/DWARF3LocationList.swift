//
//  DWARF3LocationList.swift
//  swift-dwarf
//

extension DWARF3LocationList {
    /// Resolves this list's ranges and decodes its location expressions.
    /// Overlapping locations are retained; zero-length ranges are ignored.
    public func locations(
        for unit: DWARFCompilationUnit,
        in machO: MachOFile
    ) -> [DWARFLocation]? {
        _locations(for: unit, in: machO)
    }

    public func entries(in machO: MachOFile) -> [DWARF3LocationListEntry]? {
        _entries(in: machO)
    }
}

extension DWARF3LocationList {
    /// Loads a DWARF3/4 location list relative to `__debug_loc`.
    public static func load(
        at sectionOffset: UInt64,
        for unit: DWARFCompilationUnit,
        in machO: MachOFile
    ) -> Self? {
        guard unit.header.version == .v3 || unit.header.version == .v4,
              let dwarfSegment = machO.dwarfSegment,
              let section = dwarfSegment.debug_loc(in: machO),
              let sectionOffset = Int(exactly: sectionOffset) else {
            return nil
        }
        let (offset, overflow) = section.offset.addingReportingOverflow(
            sectionOffset
        )
        guard !overflow else { return nil }
        return _load(
            at: offset,
            addressSize: unit.header.addressSize,
            from: machO
        )
    }
}
