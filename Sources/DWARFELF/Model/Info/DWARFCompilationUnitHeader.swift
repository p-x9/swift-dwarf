//
//  DWARFCompilationUnitHeader.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/04
//
//

import Foundation
import ELFKit
import DWARF

extension DWARFCompilationUnitHeader {
    public static func load(
        at offset: Int,
        in elf: ELFFile
    ) throws -> Self? {
        try _load(
            at: offset,
            from: elf
        )
    }
}
