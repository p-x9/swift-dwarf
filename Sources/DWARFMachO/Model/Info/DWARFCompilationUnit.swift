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
