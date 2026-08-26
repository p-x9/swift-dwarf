//
//  DWARFCompilationUnit.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/01/05
//  
//

import Foundation
@_spi(Support) import MachOKit
import DWARF

extension DWARFCompilationUnit {
    /// Returns the unit's kind across DWARF versions.
    ///
    /// For DWARF5, returns `header.unitType` without reading or validating the
    /// root DIE. For earlier versions, reads the root DIE and returns `.compile`
    /// or `.partial`, or `nil` if a valid unit root cannot be obtained.
    /// These legacy results are normalized kinds, not serialized `DW_UT_*` fields.
    /// DWARF4 `.debug_types` units are not currently supported.
    public func unitType(in machO: MachOFile) -> DWARFUnitType? {
        _unitType(in: machO)
    }

    public func abbreviationsSet(
        in machO: MachOFile
    ) -> DWARFAbbreviationsSet? {
        _abbreviationsSet(in: machO)
    }

    public func debugInfoEntries(
        in machO: MachOFile
    ) -> [DWARFDebugInfoEntry] {
        _debugInfoEntries(in: machO)
    }
}

extension DWARFCompilationUnit {
    public func addressesBase(
        in machO: MachOFile
    ) -> UInt64? {
        _addressesBase(in: machO)
    }

    public func stringOffsetsBase(
        in machO: MachOFile
    ) -> UInt64? {
        _stringOffsetsBase(in: machO)
    }

    public func rangeListsBase(
        in machO: MachOFile
    ) -> UInt64? {
        _rangeListsBase(in: machO)
    }

    public func locationListsBase(
        in machO: MachOFile
    ) -> UInt64? {
        _locationListsBase(in: machO)
    }
}

extension DWARFCompilationUnit {
    public func stringOffsets(
        in machO: MachOFile
    ) -> DWARFStringOffsetsTable? {
        _stringOffsets(in: machO)
    }

    public func addresses(
        in machO: MachOFile
    ) -> DWARFAddressTable? {
        _addresses(in: machO)
    }

    public func rangeList(
        in machO: MachOFile
    ) -> DWARFRangeList? {
        _rangeList(in: machO)
    }

    func locationList(
        in machO: MachOFile
    ) -> DWARFLocationList? {
        _locationList(in: machO)
    }
}

extension DWARFCompilationUnit {
    static func load(
        at offset: Int,
        in machO: MachOFile
    ) throws -> Self? {
        try _load(
            at: offset,
            from: machO
        )
    }
}
