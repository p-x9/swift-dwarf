//
//  DWARFCompilationUnit.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/14
//  
//

import Foundation
@_spi(Support) import MachOKit

public struct DWARFCompilationUnit {
    public let header: DWARFCompilationUnitHeader
    public let offset: Int
}

extension DWARFCompilationUnit {
    public var layoutSize: Int {
        header.length + (header.format == ._64bit ? 12 : 4)
    }
}

extension DWARFCompilationUnit {
    public func abbreviationsSet(in machO: MachOFile) -> DWARFAbbreviationsSet? {
        guard let dwarf = machO.dwarfSegment,
              let __debug_abbrev = dwarf.__debug_abbrev(in: machO) else {
            return nil
        }
        return .load(
            at: __debug_abbrev.offset + header.debugAbbrevOffset,
            from: machO,
            abbrevSectionStartOffset: __debug_abbrev.offset
        )
    }

    public func debugInfoEntries(in machO: MachOFile) -> [DWARFDebugInfoEntry] {
        guard let abbreviationsSet = abbreviationsSet(in: machO) else {
            return []
        }

        var pos = header.actualLayoutSize
        var entries: [DWARFDebugInfoEntry] = []
        while pos < layoutSize {
            guard let entry: DWARFDebugInfoEntry = .load(
                at: offset + machO.headerStartOffset + pos,
                from: machO,
                dwarfFormat: header.format,
                abbreviationsSet: abbreviationsSet,
                addressSize: header.addressSize
            ) else { fatalError() }
            entries.append(entry)
            pos += entry.layoutSize(
                dwarfFoarmat: header.format,
                addressSize: header.addressSize
            )
        }

        return entries
    }
}

extension DWARFCompilationUnit {
    public func addressesBase(
        in machO: MachOFile
    ) -> UInt64? {
        base(for: .address_class, in: machO)
    }

    public func stringOffsetsBase(
        in machO: MachOFile
    ) -> UInt64? {
        base(for: .str_offsets_base, in: machO)
    }

    public func rangeListsBase(
        in machO: MachOFile
    ) -> UInt64? {
        base(for: .rnglists_base, in: machO)
    }

    public func locationListsBase(
        in machO: MachOFile
    ) -> UInt64? {
        base(for: .loclists_base, in: machO)
    }
}

extension DWARFCompilationUnit {
    public func stringOffsets(
        in machO: MachOFile
    ) -> DWARFStringOffsetsTable? {
        guard let dwarfSegment = machO.dwarfSegment,
              let __debug_str_offs = dwarfSegment.__debug_str_offs(in: machO),
              let base = stringOffsetsBase(in: machO) else {
            return nil
        }
        return machO.dwarf.stringOffsetsTables.first(
            where: {
                $0.offset - __debug_str_offs.offset + $0.header.layoutSize == base
            }
        )
    }

    public func addresses(
        in machO: MachOFile
    ) -> DWARFAddressTable? {
        guard let dwarfSegment = machO.dwarfSegment,
              let __debug_addr = dwarfSegment.__debug_addr(in: machO),
              let base = addressesBase(in: machO) else {
            return nil
        }
        return machO.dwarf.addresses.first(
            where: {
                $0.offset - __debug_addr.offset + $0.header.layoutSize == base
            }
        )
    }

    public func rangeList(
        in machO: MachOFile
    ) -> DWARFRangeList? {
        guard let dwarfSegment = machO.dwarfSegment,
              let __debug_rnglists = dwarfSegment.__debug_rnglists(in: machO),
              let base = rangeListsBase(in: machO) else {
            return nil
        }
        return machO.dwarf.rangeLists.first(
            where: {
                $0.offset - __debug_rnglists.offset + $0.header.layoutSize == base
            }
        )
    }

    public func locationList(
        in machO: MachOFile
    ) -> DWARFLocationList? {
        guard let dwarfSegment = machO.dwarfSegment,
              let __debug_loclists = dwarfSegment.__debug_loclists(in: machO),
              let base = locationListsBase(in: machO) else {
            return nil
        }
        return machO.dwarf.locationLists.first(
            where: {
                $0.offset - __debug_loclists.offset + $0.header.layoutSize == base
            }
        )
    }
}

extension DWARFCompilationUnit {
    private func compileUnitDebugInfoEntry(
        in machO: MachOFile
    ) -> DWARFDebugInfoEntry? {
        guard let abbreviationsSet = abbreviationsSet(in: machO) else {
            return nil
        }
        let pos = header.actualLayoutSize
        guard let entry: DWARFDebugInfoEntry = .load(
            at: offset + machO.headerStartOffset + pos,
            from: machO,
            dwarfFormat: header.format,
            abbreviationsSet: abbreviationsSet,
            addressSize: header.addressSize
        ) else { return nil }
        guard entry.tag == .compile_unit else { return nil }
        return entry
    }

    private func base(
        for attribute: DWARFAttribute,
        in machO: MachOFile
    ) -> UInt64? {
        guard let entry = compileUnitDebugInfoEntry(in: machO) else {
            return nil
        }
        guard let attribute = entry.attributes.first(
            where: {
                $0.attribute == attribute
            }
        ) else { return nil }

        return attribute.value.constantUIntValue
    }
}

extension DWARFCompilationUnit {
    public static func load(at offset: Int, in machO: MachOFile) throws -> Self? {
        guard let header: DWARFCompilationUnitHeader = try .load(
            at: offset + machO.headerStartOffset,
            in: machO
        ) else { return nil }
        return .init(
            header: header,
            offset: offset
        )
    }
}
