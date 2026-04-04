//
//  DWARFAddressRangeTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//  
//

extension DWARFAddressRangeTable {
    public func addressRanges(
        in machO: MachOFile
    ) -> DWARFAddressRanges {
        _addressRanges(in: machO)
    }
}

extension DWARFAddressRangeTable {
    public static func load(
        at offset: Int,
        from machO: MachOFile
    ) throws -> Self? {
        try _load(at: offset, from: machO)
    }
}
