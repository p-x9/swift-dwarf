//
//  DWARFAddressRangeTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//
//

extension DWARFAddressRangeTable {
    public func addressRanges(
        in elf: ELFFile
    ) -> DWARFAddressRanges {
        _addressRanges(in: elf)
    }
}

extension DWARFAddressRangeTable {
    public static func load(
        at offset: Int,
        from elf: ELFFile
    ) throws -> Self? {
        try _load(at: offset, from: elf)
    }
}
