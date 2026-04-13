//
//  MachOFile+DWARF.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/29
//  
//

import Foundation
@_spi(Support) import MachOKit

extension MachOFile: _DWARFBinary {
    public struct DWARF: DWARFRepresentable {
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
              let debug_abbrev = dwarf.debug_abbrev(in: machO) else {
            return []
        }
        var sets: [DWARFAbbreviationsSet] = []
        var pos = 0
        while pos < debug_abbrev.size {
            let abbrevSet: DWARFAbbreviationsSet? = .load(
                at: debug_abbrev.offset + pos,
                from: machO,
                abbrevSectionStartOffset: debug_abbrev.offset
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
              let debug_info = dwarf.debug_info(in: machO) else {
            return []
        }
        var units: [DWARFCompilationUnit] = []
        var pos = 0
        while pos < debug_info.size {
            let unit: DWARFCompilationUnit? = try? .load(
                at: debug_info.offset + pos,
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
              let debug_line = dwarf.debug_line(in: machO) else {
            return []
        }
        var tables: [DWARFLineTable] = []
        var pos = 0
        while pos < debug_line.size {
            let table: DWARFLineTable? = try? ._load(
                at: debug_line.offset + pos,
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
              let debug_str = dwarf.debug_str(in: machO) else {
            return nil
        }
        return .init(
            machO: machO,
            offset: debug_str.offset + machO.headerStartOffset,
            size: debug_str.size,
            isSwapped: machO.isSwapped
        )
    }

    // __debug_line_str
    public var lineStrings: MachOFile.Strings? {
        guard let dwarf = machO.dwarfSegment,
              let debug_line_str = dwarf.debug_line_str(in: machO) else {
            return nil
        }
        return .init(
            machO: machO,
            offset: debug_line_str.offset + machO.headerStartOffset,
            size: debug_line_str.size,
            isSwapped: machO.isSwapped
        )
    }
}

extension MachOFile.DWARF {
    // dwarfdump --debug-str-offsets
    public var stringOffsetsTables: [DWARFStringOffsetsTable] {
        guard let dwarf = machO.dwarfSegment,
              let debug_str_offs = dwarf.debug_str_offs(in: machO) else {
            return []
        }
        var lists: [DWARFStringOffsetsTable] = []
        var pos = 0
        while pos < debug_str_offs.size {
            let list: DWARFStringOffsetsTable? = try? ._load(
                at: debug_str_offs.offset + pos,
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
    // __debug_addr
    public var addresses: [DWARFAddressTable] {
        guard let dwarf = machO.dwarfSegment,
              let debug_addr = dwarf.debug_addr(in: machO) else {
            return []
        }
        var lists: [DWARFAddressTable] = []
        var pos = 0
        while pos < debug_addr.size {
            let list: DWARFAddressTable? = try? ._load(
                at: debug_addr.offset + pos,
                from: machO
            )
            guard let list else { break }
            lists.append(list)
            pos += list.layoutSize
        }
        return lists
    }

    // __debug_aranges
    public var addressRanges: [DWARFAddressRangeTable] {
        guard let dwarf = machO.dwarfSegment,
              let debug_aranges = dwarf.debug_aranges(in: machO) else {
            return []
        }
        var lists: [DWARFAddressRangeTable] = []
        var pos = 0
        while pos < debug_aranges.size {
            let list: DWARFAddressRangeTable? = try? ._load(
                at: debug_aranges.offset + pos,
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
              let debug_rnglists = dwarf.debug_rnglists(in: machO) else {
            return []
        }
        var lists: [DWARFRangeList] = []
        var pos = 0
        while pos < debug_rnglists.size {
            let list: DWARFRangeList? = try? ._load(
                at: debug_rnglists.offset + pos,
                in: machO
            )
            guard let list else { break }
            lists.append(list)
            pos += list.layoutSize
        }
        return lists
    }

    // __debug_loclists
    public var locationLists: [DWARFLocationList] {
        guard let dwarf = machO.dwarfSegment,
              let debug_loclists = dwarf.debug_loclists(in: machO) else {
            return []
        }
        var lists: [DWARFLocationList] = []
        var pos = 0
        while pos < debug_loclists.size {
            let list: DWARFLocationList? = try? ._load(
                at: debug_loclists.offset + pos,
                in: machO
            )
            guard let list else { break }
            lists.append(list)
            pos += list.layoutSize
        }
        return lists
    }
}

extension MachOFile.DWARF {
    // __debug_names
    public var nameIndices: [DWARFNameIndex] {
        guard let dwarf = machO.dwarfSegment,
              let debug_names = dwarf.debug_names(in: machO) else {
            return []
        }
        var lists: [DWARFNameIndex] = []
        var pos = 0
        while pos < debug_names.size {
            let list: DWARFNameIndex? = try? ._load(
                at: debug_names.offset + pos,
                from: machO
            )
            guard let list else { break }
            lists.append(list)
            pos += list.layoutSize
        }
        return lists
    }
}
