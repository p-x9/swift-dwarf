//
//  MachOFile+DWARF.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/29
//  
//

import Foundation
@_spi(Support) import MachOKit

extension MachOFile {
    public struct DWARF {
        private let machO: MachOFile

        init(machO: MachOFile) {
            self.machO = machO
        }
    }

    public var dwarf: DWARF {
        .init(machO: self)
    }
}

extension MachOFile.DWARF {
    // dwarfdump --debug-abbrev a.out
    public var abbreviationsSets: [DWARFAbbreviationsSet] {
        guard let dwarf = machO.dwarfSegment,
              let __debug_abbrev = dwarf.__debug_abbrev(in: machO) else {
            return []
        }
        var sets: [DWARFAbbreviationsSet] = []
        var pos = 0
        while pos < __debug_abbrev.size {
            let abbrevSet: DWARFAbbreviationsSet? = .load(
                at: __debug_abbrev.offset + pos,
                from: machO,
                abbrevSectionStartOffset: __debug_abbrev.offset
            )
            guard let abbrevSet else { break }
            sets.append(abbrevSet)
            pos += abbrevSet.layoutSize
        }
        return sets
    }
}

extension MachOFile.DWARF {
    // dwarfdump --debug-str-offsets
    public var stringOffsetsTable: DWARFStringOffsetsTable? {
        guard let dwarf = machO.dwarfSegment,
              let __debug_str_offs = dwarf.__debug_str_offs(in: machO) else {
            return nil
        }
        return try? .load(
            at: __debug_str_offs.offset,
            size: __debug_str_offs.size,
            from: machO
        )
    }
}
