//
//  DWARFAbbreviation.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/23
//  
//

import Foundation
import MachOKit
import DWARF

extension DWARFAbbreviation {
    public static func load(
        at offset: Int,
        from machO: MachOFile,
        isTerminater: inout Bool
    ) -> Self? {
        _load(
            at: offset,
            from: machO,
            isTerminater: &isTerminater
        )
    }
}
