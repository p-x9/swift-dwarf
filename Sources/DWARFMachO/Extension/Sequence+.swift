//
//  Sequence+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//  
//

extension Sequence<DWARFRangeOperation> {
    public func ranges(
        addressTable: DWARFAddressTable,
        in machO: MachOFile
    ) -> [[DWARFRange]] {
        _ranges(addressTable: addressTable, in: machO)
    }
}

extension Sequence<DWARFLocationOperation> {
    public func locations(
        addressTable: DWARFAddressTable,
        in machO: MachOFile
    ) -> [[DWARFLocation]] {
        _locations(addressTable: addressTable, in: machO)
    }
}
