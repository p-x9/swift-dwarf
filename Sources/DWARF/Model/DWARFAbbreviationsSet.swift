//
//  DWARFAbbreviationsSet.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/28
//  
//

import Foundation
@testable import MachOKit // FIXME: FileIO

public struct DWARFAbbreviationsSet {
    /// offset from the start of `debug_abbrev` secton
    public let offset: Int
    public let abbreviations: [DWARFAbbreviation]
}

extension DWARFAbbreviationsSet {
    public var layoutSize: Int {
        abbreviations.reduce(0, {
            $0 + $1.layoutSize
        }) + 1 // terminator(0)
    }
}

extension DWARFAbbreviationsSet {
    public static func load(
        at offset: Int,
        from machO: MachOFile,
        abbrevSectionStartOffset: Int
    ) -> Self? {
        let offset = offset + machO.headerStartOffset
        var pos = 0
        var abbrevations: [DWARFAbbreviation] = []
        while true {
            var isTerminator = false
            let abbrev = DWARFAbbreviation.load(
                at: offset + pos,
                from: machO,
                isTerminater: &isTerminator
            )
            guard let abbrev else {
                if !isTerminator {
                    fatalError(
                        "Failed to load abbreviation at offset \(offset + pos)"
                    )
                }
                break
            }
            pos += abbrev.layoutSize
            abbrevations.append(abbrev)
        }
        return .init(
            offset: offset - abbrevSectionStartOffset - machO.headerStartOffset,
            abbreviations: abbrevations
        )
    }
}
