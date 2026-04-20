//
//  DWARFNameIndex.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//
//

extension DWARFNameIndex {
    public func compilationUnitOffsets(
        in elf: ELFFile
    ) -> AnyRandomAccessCollection<Int> {
        _compilationUnitOffsets(in: elf)
    }

    public func localTypeUnitOffsets(
        in elf: ELFFile
    ) -> AnyRandomAccessCollection<Int> {
        _localTypeUnitOffsets(in: elf)
    }

    public func foreignTypeUnitOffsets(
        in elf: ELFFile
    ) -> AnyRandomAccessCollection<Int> {
        _foreignTypeUnitOffsets(in: elf)
    }
}

extension DWARFNameIndex {
    public func hashTable(
        in elf: ELFFile
    ) -> DWARFNameIndexHashTable {
        _hashTable(in: elf)
    }
}

extension DWARFNameIndex {
    public func nameTable(in elf: ELFFile) -> DWARFNameIndexNameTable {
        _nameTable(in: elf)
    }
}

extension DWARFNameIndex {
    public func abbreviationsSet(
        in elf: ELFFile
    ) -> DWARFNameIndexAbbreviationsSet? {
        _abbreviationsSet(in: elf)
    }
}

extension DWARFNameIndex {
    public func entries(in elf: ELFFile) -> [DWARFNameIndexEntry] {
        _entries(in: elf)
    }
}

extension DWARFNameIndex {
    public func entries(
        at offset: Int, // offset from entries list starts in .debug_names section
        in elf: ELFFile
    ) -> [DWARFNameIndexEntry] {
        _entries(at: offset, in: elf)
    }
}

extension DWARFNameIndex {
    public static func load(
        at offset: Int,
        from elf: ELFFile
    ) throws -> Self? {
       try _load(at: offset, from: elf)
    }
}
