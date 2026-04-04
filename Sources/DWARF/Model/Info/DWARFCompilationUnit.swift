//
//  DWARFCompilationUnit.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/14
//  
//

import Foundation

public struct DWARFCompilationUnit: Sendable {
    public let header: DWARFCompilationUnitHeader
    public let offset: Int
}

extension DWARFCompilationUnit {
    public var layoutSize: Int {
        header.length + (header.format == ._64bit ? 12 : 4)
    }
}

extension DWARFCompilationUnit {
    package func _abbreviationsSet(in binary: some _DWARFBinary) -> DWARFAbbreviationsSet? {
        guard let dwarf = binary.dwarfSegment,
              let debug_abbrev = dwarf.debug_abbrev(in: binary) else {
            return nil
        }
        return ._load(
            at: debug_abbrev.offset + header.debugAbbrevOffset,
            from: binary,
            abbrevSectionStartOffset: debug_abbrev.offset
        )
    }

    package func _debugInfoEntries(in binary: some _DWARFBinary) -> [DWARFDebugInfoEntry] {
        guard let abbreviationsSet = _abbreviationsSet(in: binary) else {
            return []
        }

        var pos = header.actualLayoutSize
        var entries: [DWARFDebugInfoEntry] = []
        while pos < layoutSize {
            guard let entry: DWARFDebugInfoEntry = ._load(
                at: offset + pos,
                from: binary,
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
    package func _addressesBase(
        in binary: some _DWARFBinary
    ) -> UInt64? {
        base(for: .addr_base, in: binary)
    }

    package func _stringOffsetsBase(
        in binary: some _DWARFBinary
    ) -> UInt64? {
        base(for: .str_offsets_base, in: binary)
    }

    package func _rangeListsBase(
        in binary: some _DWARFBinary
    ) -> UInt64? {
        base(for: .rnglists_base, in: binary)
    }

    package func _locationListsBase(
        in binary: some _DWARFBinary
    ) -> UInt64? {
        base(for: .loclists_base, in: binary)
    }
}

extension DWARFCompilationUnit {
    package func _stringOffsets(
        in binary: some _DWARFBinary
    ) -> DWARFStringOffsetsTable? {
        guard let dwarfSegment = binary.dwarfSegment,
              let debug_str_offs = dwarfSegment.debug_str_offs(in: binary),
              let base = _stringOffsetsBase(in: binary) else {
            return nil
        }
        return binary.dwarf.stringOffsetsTables.first(
            where: {
                $0.offset - debug_str_offs.offset + $0.header.layoutSize == base
            }
        )
    }

    package func _addresses(
        in binary: some _DWARFBinary
    ) -> DWARFAddressTable? {
        guard let dwarfSegment = binary.dwarfSegment,
              let debug_addr = dwarfSegment.debug_addr(in: binary),
              let base = _addressesBase(in: binary) else {
            return nil
        }
        return binary.dwarf.addresses.first(
            where: {
                $0.offset - debug_addr.offset + $0.header.layoutSize == base
            }
        )
    }

    package func _rangeList(
        in binary: some _DWARFBinary
    ) -> DWARFRangeList? {
        guard let dwarfSegment = binary.dwarfSegment,
              let debug_rnglists = dwarfSegment.debug_rnglists(in: binary),
              let base = _rangeListsBase(in: binary) else {
            return nil
        }
        return binary.dwarf.rangeLists.first(
            where: {
                $0.offset - debug_rnglists.offset + $0.header.layoutSize == base
            }
        )
    }

    package func _locationList(
        in binary: some _DWARFBinary
    ) -> DWARFLocationList? {
        guard let dwarfSegment = binary.dwarfSegment,
              let debug_loclists = dwarfSegment.debug_loclists(in: binary),
              let base = _locationListsBase(in: binary) else {
            return nil
        }
        return binary.dwarf.locationLists.first(
            where: {
                $0.offset - debug_loclists.offset + $0.header.layoutSize == base
            }
        )
    }
}

extension DWARFCompilationUnit {
    private func compileUnitDebugInfoEntry(
        in binary: some _DWARFBinary
    ) -> DWARFDebugInfoEntry? {
        guard let abbreviationsSet = _abbreviationsSet(in: binary) else {
            return nil
        }
        let pos = header.actualLayoutSize
        guard let entry: DWARFDebugInfoEntry = ._load(
            at: offset + pos,
            from: binary,
            dwarfFormat: header.format,
            abbreviationsSet: abbreviationsSet,
            addressSize: header.addressSize
        ) else { return nil }
        guard entry.tag == .compile_unit else { return nil }
        return entry
    }

    private func base(
        for attribute: DWARFAttribute,
        in binary: some _DWARFBinary
    ) -> UInt64? {
        guard let entry = compileUnitDebugInfoEntry(in: binary) else {
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
    package static func _load(
        at offset: Int,
        from binary: some _DWARFBinary
    ) throws -> Self? {
        guard let header: DWARFCompilationUnitHeader = try ._load(
            at: offset,
            from: binary
        ) else { return nil }
        return .init(
            header: header,
            offset: offset
        )
    }
}
