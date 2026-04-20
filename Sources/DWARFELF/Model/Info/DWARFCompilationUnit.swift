//
//  DWARFCompilationUnit.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/01/05
//
//

import Foundation
@_spi(Support) import ELFKit
import DWARF

extension DWARFCompilationUnit {
    public func abbreviationsSet(
        in elf: ELFFile
    ) -> DWARFAbbreviationsSet? {
        _abbreviationsSet(in: elf)
    }

    public func debugInfoEntries(
        in elf: ELFFile
    ) -> [DWARFDebugInfoEntry] {
        _debugInfoEntries(in: elf)
    }
}

extension DWARFCompilationUnit {
    public func addressesBase(
        in elf: ELFFile
    ) -> UInt64? {
        _addressesBase(in: elf)
    }

    public func stringOffsetsBase(
        in elf: ELFFile
    ) -> UInt64? {
        _stringOffsetsBase(in: elf)
    }

    public func rangeListsBase(
        in elf: ELFFile
    ) -> UInt64? {
        _rangeListsBase(in: elf)
    }

    public func locationListsBase(
        in elf: ELFFile
    ) -> UInt64? {
        _locationListsBase(in: elf)
    }
}

extension DWARFCompilationUnit {
    public func stringOffsets(
        in elf: ELFFile
    ) -> DWARFStringOffsetsTable? {
        _stringOffsets(in: elf)
    }

    public func addresses(
        in elf: ELFFile
    ) -> DWARFAddressTable? {
        _addresses(in: elf)
    }

    public func rangeList(
        in elf: ELFFile
    ) -> DWARFRangeList? {
        _rangeList(in: elf)
    }

    func locationList(
        in elf: ELFFile
    ) -> DWARFLocationList? {
        _locationList(in: elf)
    }
}

extension DWARFCompilationUnit {
    static func load(
        at offset: Int,
        in elf: ELFFile
    ) throws -> Self? {
        try _load(
            at: offset,
            from: elf
        )
    }
}
