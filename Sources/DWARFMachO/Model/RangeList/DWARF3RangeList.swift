//
//  DWARF3RangeList.swift
//  swift-dwarf
//

extension DWARF3RangeList {
    public func entries(in machO: MachOFile) -> [DWARF3RangeListEntry]? {
        _entries(in: machO)
    }
}

extension DWARF3RangeList {
    /// Loads a DWARF3/4 range list relative to `__debug_ranges`.
    public static func load(
        at sectionOffset: UInt64,
        for unit: DWARFCompilationUnit,
        in machO: MachOFile
    ) -> Self? {
        guard unit.header.version == .v3 || unit.header.version == .v4,
              let dwarfSegment = machO.dwarfSegment,
              let section = dwarfSegment.debug_ranges(in: machO),
              let sectionOffset = Int(exactly: sectionOffset),
              sectionOffset >= 0,
              sectionOffset <= section.size else {
            return nil
        }
        let (offset, overflow) = section.offset.addingReportingOverflow(
            sectionOffset
        )
        guard !overflow else { return nil }
        return _load(
            at: offset,
            addressSize: unit.header.addressSize
        )
    }
}
