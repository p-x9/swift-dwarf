//
//  _DWARFBinary.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/04
//  
//

package import FileIO

package protocol _DWARFBinary {
    associatedtype File: MemoryMappedFileIOProtocol
    associatedtype DWARF: DWARFRepresentable

    var fileHandle: File { get }
    var headerStartOffset: Int { get }

    var is64Bit: Bool { get }
    var endian: Endian { get }

    var dwarfSegment: (any DWARFSegment<Self>)? { get }
    var dwarfSectionPrefix: String { get }

    var dwarf: DWARF { get }
}
