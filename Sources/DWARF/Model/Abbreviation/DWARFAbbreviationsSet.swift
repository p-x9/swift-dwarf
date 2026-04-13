//
//  DWARFAbbreviationsSet.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/28
//  
//

import Foundation

public struct DWARFAbbreviationsSet: Sendable {
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
    package static func _load(
        at offset: Int,
        from binary: some _DWARFBinary,
        abbrevSectionStartOffset: Int
    ) -> Self? {
        var pos = 0
        var abbrevations: [DWARFAbbreviation] = []
        while true {
            var isTerminator = false
            let abbrev = DWARFAbbreviation._load(
                at: offset + pos,
                from: binary,
                isTerminator: &isTerminator
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
            offset: offset - abbrevSectionStartOffset,
            abbreviations: abbrevations
        )
    }
}
