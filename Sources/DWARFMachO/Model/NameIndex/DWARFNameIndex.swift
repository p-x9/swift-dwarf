//
//  DWARFNameIndex.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//
//

extension DWARFNameIndex {
    public func compilationUnitOffsets(
        in machO: MachOFile
    ) -> AnyRandomAccessCollection<Int> {
        _compilationUnitOffsets(in: machO)
    }

    public func localTypeUnitOffsets(
        in machO: MachOFile
    ) -> AnyRandomAccessCollection<Int> {
        _localTypeUnitOffsets(in: machO)
    }

    public func foreignTypeUnitOffsets(
        in machO: MachOFile
    ) -> AnyRandomAccessCollection<Int> {
        _foreignTypeUnitOffsets(in: machO)
    }
}

extension DWARFNameIndex {
    public func hashTable(
        in machO: MachOFile
    ) -> DWARFNameIndexHashTable {
        _hashTable(in: machO)
    }
}

extension DWARFNameIndex {
    public func nameTable(in machO: MachOFile) -> DWARFNameIndexNameTable {
        _nameTable(in: machO)
    }
}

extension DWARFNameIndex {
    public func abbreviationsSet(
        in machO: MachOFile
    ) -> DWARFNameIndexAbbreviationsSet? {
        _abbreviationsSet(in: machO)
    }
}

extension DWARFNameIndex {
    public func entries(in machO: MachOFile) -> [DWARFNameIndexEntry] {
        _entries(in: machO)
    }
}

extension DWARFNameIndex {
    public func entries(
        at offset: Int, // offset from entries list starts in .debug_names section
        in machO: MachOFile
    ) -> [DWARFNameIndexEntry] {
        _entries(at: offset, in: machO)
    }
}

extension DWARFNameIndex {
    public static func load(
        at offset: Int,
        from machO: MachOFile
    ) throws -> Self? {
       try _load(at: offset, from: machO)
    }
}
