//
//  DWARFDebugInfoEntry.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/07/02
//  
//

import Foundation

public struct DWARFDebugInfoEntry: Sendable {
    public let tag: DWARFTag
    public let abbreviationCode: UInt
    public let hasChildren: Bool
    public let attributes: [(attribute: DWARFAttribute, value: DWARFAttributeValue)]

    public let offset: Int
}

extension DWARFDebugInfoEntry {
    package func _rangeListSectionOffset(
        for unit: DWARFCompilationUnit,
        attribute: DWARFAttribute
    ) -> UInt64? {
        // DWARF3/4 Figure 20: start_scope gains rangelistptr in DWARF4.
        guard attribute == .ranges ||
                (attribute == .start_scope && unit.header.version == .v4) else {
            return nil
        }
        return _listSectionOffset(for: unit, attribute: attribute)
    }

    package func _locationListSectionOffset(
        for unit: DWARFCompilationUnit,
        attribute: DWARFAttribute
    ) -> UInt64? {
        // Only attributes whose class includes loclistptr (Figure 20).
        switch attribute {
        case .location, .string_length, .return_addr, .data_member_location,
             .frame_base, .segment, .static_link, .use_location,
             .vtable_elem_location:
            return _listSectionOffset(for: unit, attribute: attribute)
        default:
            return nil
        }
    }

    private func _listSectionOffset(
        for unit: DWARFCompilationUnit,
        attribute: DWARFAttribute
    ) -> UInt64? {
        guard unit._containsDebugInfoEntry(at: offset),
              let value = attributes.first(where: { $0.attribute == attribute })?.value else {
            return nil
        }
        return value._listSectionOffset(for: unit)
    }
}

extension DWARFAttributeValue {
    fileprivate func _listSectionOffset(for unit: DWARFCompilationUnit) -> UInt64? {
        // DWARF3/4 Section 7.5.4: pointer width follows DWARF format,
        // not the compilation unit's address size.
        switch (unit.header.version, unit.header.format, self) {
        case (_, _, .indirect(let value)):
            return value._listSectionOffset(for: unit)
        case (.v3, ._32bit, .data4(let value)):
            return UInt64(value.value)
        case (.v3, ._64bit, .data8(let value)):
            return value.value
        case (.v4, _, .sec_offset(let value)):
            return value.offset
        default:
            return nil
        }
    }
}

extension DWARFDebugInfoEntry {
    public func layoutSize(
        dwarfFoarmat: DWARFFormat,
        addressSize: Int
    ) -> Int {
        abbreviationCode.uleb128Size +
        attributes.reduce(into: 0, {
            $0 += $1.value.size(dwarfFormat: dwarfFoarmat, addressSize: addressSize)
        })
    }
}

extension DWARFDebugInfoEntry {
    static func null(offset: Int) -> Self {
        .init(
            tag: .null,
            abbreviationCode: 0,
            hasChildren: false,
            attributes: [],
            offset: offset
        )
    }
}

extension DWARFDebugInfoEntry {
    package static func _load(
        at offset: Int,
        from binary: some _DWARFBinary,
        dwarfFormat: DWARFFormat,
        abbreviationsSet: DWARFAbbreviationsSet,
        addressSize: Int
    ) -> Self? {
        let (code, codeSize) = binary.fileHandle.readULEB128(
            baseOffset: numericCast(offset + binary.headerStartOffset)
        )

        if code == 0 { // null
            return .null(offset: offset)
        }

        let abbreviation = abbreviationsSet.abbreviations.first(
            where: {
                $0.code == code
            }
        )
        guard let abbreviation else { return nil }

        var pos = 0
        var values: [(DWARFAttribute, DWARFAttributeValue)] = []
        for (attribute, format) in abbreviation.attributes {
            guard let value: DWARFAttributeValue = ._load(
                at: offset + codeSize + pos,
                from: binary,
                as: format,
                dwarfFormat: dwarfFormat,
                addressSize: addressSize
            ) else { fatalError("") }
            pos += value.size(
                dwarfFormat: dwarfFormat,
                addressSize: addressSize
            )
            values.append((attribute, value))
        }

        return .init(
            tag: abbreviation.tag,
            abbreviationCode: code,
            hasChildren: abbreviation.hasChildren,
            attributes: values,
            offset: offset
        )
    }
}
