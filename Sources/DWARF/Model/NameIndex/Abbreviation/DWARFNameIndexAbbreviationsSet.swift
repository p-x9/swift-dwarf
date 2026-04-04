//
//  DWARFNameIndexAbbreviationsSet.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/21
//  
//

import Foundation

public struct DWARFNameIndexAbbreviationsSet: Sendable {
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
    package static func _load(
        at offset: Int,
        from binary: some _DWARFBinary
    ) -> Self? {
        var pos = 0
        var abbrevations: [DWARFNameIndexAbbreviation] = []
        while true {
            var isTerminator = false
            let abbrev: DWARFNameIndexAbbreviation? = ._load(
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
            offset: offset,
            abbreviations: abbrevations
        )
    }
}
