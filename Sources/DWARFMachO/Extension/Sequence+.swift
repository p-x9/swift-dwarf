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
        in machO: MachOFile
    ) -> [[DWARFLocation]] {
        _locations(addressTable: addressTable, in: machO)
    }
}
