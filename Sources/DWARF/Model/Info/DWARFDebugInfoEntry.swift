//
//  DWARFDebugInfoEntry.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/07/02
//  
//

import Foundation
import MachOKit

public struct DWARFDebugInfoEntry {
    public let tag: DWARFTag
    public let abbreviationCode: UInt
    public let attributes: [(attribute: DWARFAttribute, value: DWARFAttributeValue)]

    public let offset: Int
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
            attributes: [],
            offset: offset
        )
    }
}

extension DWARFDebugInfoEntry {
    public static func load(
        at offset: Int,
        from machO: MachOFile,
        dwarfFormat: DWARFFormat,
        abbreviationsSet: DWARFAbbreviationsSet,
        addressSize: Int
    ) -> Self? {
        let (code, codeSize) = machO.fileHandle.readULEB128(
            baseOffset: numericCast(offset + machO.headerStartOffset)
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
            guard let value: DWARFAttributeValue = .load(
                at: offset + codeSize + pos,
                from: machO,
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
            attributes: values,
            offset: offset
        )
    }
}
