//
//  Sequence+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//
//

extension Sequence<DWARFLocationOperation> {
    public func locations(
        addressTable: DWARFAddressTable,
        in elf: ELFFile
    ) -> [[DWARFLocation]] {
        _locations(addressTable: addressTable, in: elf)
    }
}
