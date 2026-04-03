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

    var fileHandle: File { get }

    var dwarfSegment: (any DWARFSegment)? { get }
}
