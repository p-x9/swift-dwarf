//
//  DWARFCompilationUnit.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/14
//
//

import Foundation

/// A unit contribution in DWARF debugging information.
///
/// This model represents full, partial, skeleton, and type units, including
/// split full and split type units. It is not limited to units whose root DIE
/// has the `DW_TAG_compile_unit` tag.
///
/// See DWARF5 Section 3.1 (pp. 59-60) for the unit kinds represented here.
/// https://dwarfstd.org/doc/DWARF5.pdf#page=77
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
    package func _containsDebugInfoEntry(at entryOffset: Int) -> Bool {
        let (entriesStart, startOverflow) = offset.addingReportingOverflow(
            header.actualLayoutSize
        )
        let (unitEnd, endOverflow) = offset.addingReportingOverflow(layoutSize)
        guard !startOverflow, !endOverflow else { return false }
        return entriesStart <= entryOffset && entryOffset < unitEnd
    }

    package static func _containingDebugInfoEntry(
        at entryOffset: Int,
        in units: [Self]
    ) -> Self? {
        units.first { $0._containsDebugInfoEntry(at: entryOffset) }
    }
}

extension DWARFCompilationUnit {
    package func _unitType(in binary: some _DWARFBinary) -> DWARFUnitType? {
        // DWARF5 Section 7.5.1: the header distinguishes split units, whose
        // root tags are shared with conventional units (Sections 3.1.3-3.1.4).
        if let unitType = header.unitType {
            return unitType
        }

        // DWARF3/4 Section 3.1.1: legacy .debug_info units are distinguished
        // by their root DIE, not by a unit_type field in the header.
        guard let entry = unitRootDebugInfoEntry(in: binary) else { return nil }
        switch entry.tag {
        case .compile_unit: return .compile
        case .partial_unit: return .partial
        default: return nil
        }
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
              let debug_str_offsets = dwarfSegment.debug_str_offsets(in: binary),
              let base = _stringOffsetsBase(in: binary) else {
            return nil
        }
        return binary.dwarf.stringOffsetsTables.first(
            where: {
                $0.offset - debug_str_offsets.offset + $0.header.layoutSize == base
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
    private func unitRootDebugInfoEntry(
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
        guard header._acceptsRootTag(entry.tag) else { return nil }
        return entry
    }

    private func base(
        for attribute: DWARFAttribute,
        in binary: some _DWARFBinary
    ) -> UInt64? {
        guard let entry = unitRootDebugInfoEntry(in: binary) else {
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
