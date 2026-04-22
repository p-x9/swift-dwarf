//
//  ELFRepresentable+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/12
//  
//

import Foundation
import ELFKit

extension ELFRepresentable {
    package var dwarfSectionPrefix: String {
        "."
    }
}

extension ELFRepresentable {
    // FIXME: ELFKit currently supports only binaries with the same endianness as the host machine
    package var endian: Endian {
        .current
    }
}
