//
//  ELFSection+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/12
//  
//

import DWARF
import ELFKit

extension ELF32SectionHeader: DWARFSection {
    package typealias DWARFBinary = ELFFile

    package func sectionName(in binary: DWARFBinary) -> String {
        name(in: binary) ?? ""
    }

    package var align: Int {
        numericCast(layout.sh_addralign)
    }
}
extension ELF64SectionHeader: DWARFSection {
    package typealias DWARFBinary = ELFFile

    package func sectionName(in binary: DWARFBinary) -> String {
        name(in: binary) ?? ""
    }

    package var align: Int {
        numericCast(layout.sh_addralign)
    }
}
