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
