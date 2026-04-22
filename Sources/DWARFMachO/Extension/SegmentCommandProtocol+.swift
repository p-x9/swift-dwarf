//
//  SegmentCommandProtocol+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/04
//
//

import DWARF
import MachOKit

extension Section: DWARFSection {
    package typealias DWARFBinary = MachOFile

    package func sectionName(in binary: DWARFBinary) -> String {
        sectionName
    }
}
extension Section64: DWARFSection {
    package typealias DWARFBinary = MachOFile

    package func sectionName(in binary: DWARFBinary) -> String {
        sectionName
    }
}

extension SegmentCommand: DWARFSegment {
    package typealias DWARFBinary = MachOFile
    package typealias DWARFSectionType = SectionType
}

extension SegmentCommand64: DWARFSegment {
    package typealias DWARFBinary = MachOFile
    package typealias DWARFSectionType = SectionType
}
