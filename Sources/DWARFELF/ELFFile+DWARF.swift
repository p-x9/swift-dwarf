//
//  ELFFile+DWARF.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/12
//  
//

import Foundation
@_spi(Support) import ELFKit

extension ELFFile: _DWARFBinary {
    public struct DWARF: DWARFRepresentable {
        private let elf: ELFFile

        init(elf: ELFFile) {
            self.elf = elf
        }
    }

    public var dwarf: DWARF {
        .init(elf: self)
    }
}

extension ELFFile.DWARF {
    // dwarfdump --debug-abbrev a.out
    public var abbreviationsSets: [DWARFAbbreviationsSet] {
        guard let dwarf = elf.dwarfSegment,
              let debug_abbrev = dwarf.debug_abbrev(in: elf) else {
            return []
        }
        var sets: [DWARFAbbreviationsSet] = []
        var pos = 0
        while pos < debug_abbrev.size {
            let abbrevSet: DWARFAbbreviationsSet? = ._load(
                at: debug_abbrev.offset + pos,
                from: elf,
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
        guard let dwarf = elf.dwarfSegment,
              let debug_info = dwarf.debug_info(in: elf) else {
            return []
        }
        var units: [DWARFCompilationUnit] = []
        var pos = 0
        while pos < debug_info.size {
            let unit: DWARFCompilationUnit? = try? .load(
                at: debug_info.offset + pos,
                in: elf
            )
            guard let unit else { break }
            units.append(unit)
            pos += unit.layoutSize
        }
        return units
    }
}

extension ELFFile.DWARF {
    // dwarfdump --debug-info a.out
    public var lineTables: [DWARFLineTable] {
        guard let dwarf = elf.dwarfSegment,
              let debug_line = dwarf.debug_line(in: elf) else {
            return []
        }
        var tables: [DWARFLineTable] = []
        var pos = 0
        while pos < debug_line.size {
            let table: DWARFLineTable? = try? ._load(
                at: debug_line.offset + pos,
                in: elf
            )
            guard let table else { break }
            tables.append(table)
            pos += table.layoutSize
        }
        return tables
    }
}

extension ELFFile.DWARF {
    // __debug_str
    public var strings: ELFFile.Strings? {
        guard let dwarf = elf.dwarfSegment,
              let debug_str = dwarf.debug_str(in: elf) else {
            return nil
        }
        let offset = debug_str.offset + elf.headerStartOffset
        let size = debug_str.size
        let fileSlice = try! elf.fileHandle.fileSlice(
            offset: offset,
            length: size
        )
        return .init(
            source: fileSlice,
            offset: offset,
            size: size,
            isSwapped: false // FIXME: isSwapped
        )
    }

    // __debug_line_str
    public var lineStrings: ELFFile.Strings? {
        guard let dwarf = elf.dwarfSegment,
              let debug_line_str = dwarf.debug_line_str(in: elf) else {
            return nil
        }
        let offset = debug_line_str.offset + elf.headerStartOffset
        let size = debug_line_str.size
        let fileSlice = try! elf.fileHandle.fileSlice(
            offset: offset,
            length: size
        )
        return .init(
            source: fileSlice,
            offset: offset,
            size: size,
            isSwapped: false // FIXME: isSwapped
        )
    }
}

extension ELFFile.DWARF {
    // dwarfdump --debug-str-offsets
    public var stringOffsetsTables: [DWARFStringOffsetsTable] {
        guard let dwarf = elf.dwarfSegment,
              let debug_str_offs = dwarf.debug_str_offs(in: elf) else {
            return []
        }
        var lists: [DWARFStringOffsetsTable] = []
        var pos = 0
        while pos < debug_str_offs.size {
            let list: DWARFStringOffsetsTable? = try? ._load(
                at: debug_str_offs.offset + pos,
                from: elf
            )
            guard let list else { break }
            lists.append(list)
            pos += list.layoutSize
        }
        return lists
    }
}

extension ELFFile.DWARF {
    // __debug_addr
    public var addresses: [DWARFAddressTable] {
        guard let dwarf = elf.dwarfSegment,
              let debug_addr = dwarf.debug_addr(in: elf) else {
            return []
        }
        var lists: [DWARFAddressTable] = []
        var pos = 0
        while pos < debug_addr.size {
            let list: DWARFAddressTable? = try? ._load(
                at: debug_addr.offset + pos,
                from: elf
            )
            guard let list else { break }
            lists.append(list)
            pos += list.layoutSize
        }
        return lists
    }

    // __debug_aranges
    public var addressRanges: [DWARFAddressRangeTable] {
        guard let dwarf = elf.dwarfSegment,
              let debug_aranges = dwarf.debug_aranges(in: elf) else {
            return []
        }
        var lists: [DWARFAddressRangeTable] = []
        var pos = 0
        while pos < debug_aranges.size {
            let list: DWARFAddressRangeTable? = try? ._load(
                at: debug_aranges.offset + pos,
                from: elf
            )
            guard let list else { break }
            lists.append(list)
            pos += list.layoutSize
        }
        return lists
    }
}

extension ELFFile.DWARF {
    // __debug_rnglists
    public var rangeLists: [DWARFRangeList] {
        guard let dwarf = elf.dwarfSegment,
              let debug_rnglists = dwarf.debug_rnglists(in: elf) else {
            return []
        }
        var lists: [DWARFRangeList] = []
        var pos = 0
        while pos < debug_rnglists.size {
            let list: DWARFRangeList? = try? ._load(
                at: debug_rnglists.offset + pos,
                in: elf
            )
            guard let list else { break }
            lists.append(list)
            pos += list.layoutSize
        }
        return lists
    }

    // __debug_loclists
    public var locationLists: [DWARFLocationList] {
        guard let dwarf = elf.dwarfSegment,
              let debug_loclists = dwarf.debug_loclists(in: elf) else {
            return []
        }
        var lists: [DWARFLocationList] = []
        var pos = 0
        while pos < debug_loclists.size {
            let list: DWARFLocationList? = try? ._load(
                at: debug_loclists.offset + pos,
                in: elf
            )
            guard let list else { break }
            lists.append(list)
            pos += list.layoutSize
        }
        return lists
    }
}

extension ELFFile.DWARF {
    // __debug_names
    public var nameIndices: [DWARFNameIndex] {
        guard let dwarf = elf.dwarfSegment,
              let debug_names = dwarf.debug_names(in: elf) else {
            return []
        }
        var lists: [DWARFNameIndex] = []
        var pos = 0
        while pos < debug_names.size {
            let list: DWARFNameIndex? = try? ._load(
                at: debug_names.offset + pos,
                from: elf
            )
            guard let list else { break }
            lists.append(list)
            pos += list.layoutSize
        }
        return lists
    }
}
