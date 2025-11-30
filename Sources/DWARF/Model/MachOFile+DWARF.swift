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

    // dwarfdump --debug-info a.out
    public var compilationUnits: [DWARFCompilationUnit] {
        guard let dwarf = machO.dwarfSegment,
              let __debug_info = dwarf.__debug_info(in: machO) else {
            return []
        }
        var units: [DWARFCompilationUnit] = []
        var pos = 0
        while pos < __debug_info.size {
            let unit: DWARFCompilationUnit? = try? .load(
                at: __debug_info.offset + pos,
                in: machO
            )
            guard let unit else { break }
            units.append(unit)
            pos += unit.layoutSize
        }
        return units
    }
}

extension MachOFile.DWARF {
    // dwarfdump --debug-info a.out
    public var lineTables: [DWARFLineTable] {
        guard let dwarf = machO.dwarfSegment,
              let __debug_line = dwarf.__debug_line(in: machO) else {
            return []
        }
        var tables: [DWARFLineTable] = []
        var pos = 0
        while pos < __debug_line.size {
            let table: DWARFLineTable? = try? .load(
                at: __debug_line.offset + pos,
                in: machO
            )
            guard let table else { break }
            tables.append(table)
            pos += table.layoutSize
        }
        return tables
    }
}

extension MachOFile.DWARF {
    // __debug_str
    public var strings: MachOFile.Strings? {
        guard let dwarf = machO.dwarfSegment,
              let __debug_str = dwarf.__debug_str(in: machO) else {
            return nil
        }
        return .init(
            machO: machO,
            offset: __debug_str.offset + machO.headerStartOffset,
            size: __debug_str.size,
            isSwapped: machO.isSwapped
        )
    }

    // __debug_line_str
    public var lineStrings: MachOFile.Strings? {
        guard let dwarf = machO.dwarfSegment,
              let __debug_line_str = dwarf.__debug_line_str(in: machO) else {
            return nil
        }
        return .init(
            machO: machO,
            offset: __debug_line_str.offset + machO.headerStartOffset,
            size: __debug_line_str.size,
            isSwapped: machO.isSwapped
        )
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

extension MachOFile.DWARF {
    // __debug_addr
    public var addresses: [DWARFAddressTable] {
        guard let dwarf = machO.dwarfSegment,
              let __debug_addr = dwarf.__debug_addr(in: machO) else {
            return []
        }
        var lists: [DWARFAddressTable] = []
        var pos = 0
        while pos < __debug_addr.size {
            let list: DWARFAddressTable? = try? .load(
                at: __debug_addr.offset + pos,
                from: machO
            )
            guard let list else { break }
            lists.append(list)
            pos += list.layoutSize
        }
        return lists
    }
}

extension MachOFile.DWARF {
    // __debug_rnglists
    public var rangeLists: [DWARFRangeList] {
        guard let dwarf = machO.dwarfSegment,
              let __debug_rnglists = dwarf.__debug_rnglists(in: machO) else {
            return []
        }
        var lists: [DWARFRangeList] = []
        var pos = 0
        while pos < __debug_rnglists.size {
            let list: DWARFRangeList? = try? .load(
                at: __debug_rnglists.offset + pos,
                in: machO
            )
            guard let list else { break }
            lists.append(list)
            pos += list.layoutSize
        }
        return lists
    }
}
