//
//  DWARFStringOffsetsTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//
//

extension DWARFStringOffsetsTable {
    public func offsets(
        in elf: ELFFile
    ) -> [UInt64] {
        _offsets(in: elf)
    }
}

extension DWARFStringOffsetsTable {
    public static func load(
        at offset: Int,
        from elf: ELFFile
    ) throws -> Self? {
        try _load(at: offset, from: elf)
    }
}
