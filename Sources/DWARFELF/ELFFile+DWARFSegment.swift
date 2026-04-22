//
//  ELFFile+DWARFSegment.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/12
//  
//

import Foundation
import ELFKit

extension ELFFile {
    package struct DWARFDummySegment32: DWARFSegment {
        package typealias DWARFBinary = ELFFile

        package typealias DWARFSectionType = ELF32SectionHeader

        init() {}
    }
}

extension ELFFile {
    package struct DWARFDummySegment64: DWARFSegment {
        package typealias DWARFBinary = ELFFile

        package typealias DWARFSectionType = ELF64SectionHeader

        init() {}
    }
}

extension ELFFile.DWARFDummySegment32 {
    package func sections(in binary: DWARFBinary) -> DataSequence<ELF32SectionHeader> {
        binary.sections32 ?? .init(data: .init(), numberOfElements: 0)
    }
}


extension ELFFile.DWARFDummySegment64 {
    package func sections(in binary: DWARFBinary) -> DataSequence<ELF64SectionHeader> {
        binary.sections64 ?? .init(data: .init(), numberOfElements: 0)
    }
}
