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
}

extension DWARFCompilationUnit {
    public static func load(at offset: Int, in machO: MachOFile) throws -> Self? {
        guard let header: DWARFCompilationUnitHeader = try .load(
            at: offset,
            in: machO
        ) else { return nil }
        return .init(
            header: header,
            offset: offset
        )
    }
}
