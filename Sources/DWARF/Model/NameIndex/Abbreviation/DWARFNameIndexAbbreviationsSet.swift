//
//  DWARFNameIndexAbbreviationsSet.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/21
//  
//

import Foundation
import MachOKit

public struct DWARFNameIndexAbbreviationsSet {
    public let offset: Int
    public let abbreviations: [DWARFNameIndexAbbreviation]
}

extension DWARFNameIndexAbbreviationsSet {
    public var layoutSize: Int {
        abbreviations.reduce(0, {
            $0 + $1.layoutSize
        }) + 1 // terminator(0)
    }
}

extension DWARFNameIndexAbbreviationsSet {
    public static func load(
        at offset: Int,
        from machO: MachOFile
    ) -> Self? {
        let offset = offset + machO.headerStartOffset
        var pos = 0
        var abbrevations: [DWARFNameIndexAbbreviation] = []
        while true {
            var isTerminator = false
            let abbrev = DWARFNameIndexAbbreviation.load(
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
            offset: offset - machO.headerStartOffset,
            abbreviations: abbrevations
        )
    }
}
