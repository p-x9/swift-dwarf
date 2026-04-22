//
//  DWARFAddressTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//
//

import ELFKit

extension DWARFAddressTable {
    public func addresses(
        in elf: ELFFile
    ) -> DWARFAddresses {
        _addresses(in: elf)
    }
}

extension DWARFAddressTable {
    public static func load(
        at offset: Int,
        from elf: ELFFile
    ) throws -> Self? {
        try _load(at: offset, from: elf)
    }
}
