//
//  DWARFCompilationUnitHeader.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/04
//  
//

import Foundation
import MachOKit
import DWARF

extension DWARFCompilationUnitHeader {
    public static func load(
        at offset: Int,
        in machO: MachOFile
    ) throws -> Self? {
        try _load(
            at: offset,
            from: machO
        )
    }
}
