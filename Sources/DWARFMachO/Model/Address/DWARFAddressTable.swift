//
//  DWARFAddressTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//  
//

import MachOKit

extension DWARFAddressTable {
    public func addresses(
        in machO: MachOFile
    ) -> DWARFAddresses {
        _addresses(in: machO)
    }
}

extension DWARFAddressTable {
    public static func load(
        at offset: Int,
        from machO: MachOFile
    ) throws -> Self? {
        try _load(at: offset, from: machO)
    }
}
