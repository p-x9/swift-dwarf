//
//  DWARF3LocationList.swift
//  swift-dwarf
//

extension DWARF3LocationList {
    public func entries(in elf: ELFFile) -> [DWARF3LocationListEntry]? {
        _entries(in: elf)
    }
}

extension DWARF3LocationList {
    /// Loads a DWARF3/4 location list relative to `.debug_loc`.
    public static func load(
        at sectionOffset: UInt64,
        for unit: DWARFCompilationUnit,
        in elf: ELFFile
    ) -> Self? {
        guard unit.header.version == .v3 || unit.header.version == .v4,
              let dwarfSegment = elf.dwarfSegment,
              let section = dwarfSegment.debug_loc(in: elf),
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
            from: elf
        )
    }
}
