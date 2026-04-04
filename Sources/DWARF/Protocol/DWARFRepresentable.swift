//
//  DWARFRepresentable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/01/05
//  
//

import BinaryParseSupport

public protocol DWARFRepresentable {
    var abbreviationsSets: [DWARFAbbreviationsSet] { get }
    var compilationUnits: [DWARFCompilationUnit] { get }
    var lineTables: [DWARFLineTable] { get }
    var strings: UnicodeStrings<UTF8>? { get }
    var lineStrings: UnicodeStrings<UTF8>? { get }
    var stringOffsetsTables: [DWARFStringOffsetsTable] { get }
    var addresses: [DWARFAddressTable] { get }
    var addressRanges: [DWARFAddressRangeTable] { get }
    var rangeLists: [DWARFRangeList] { get }
    var locationLists: [DWARFLocationList] { get }
    var nameIndices: [DWARFNameIndex] { get }
}
