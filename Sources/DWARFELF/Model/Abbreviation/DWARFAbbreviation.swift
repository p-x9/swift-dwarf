//
//  DWARFAbbreviation.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/23
//
//

import Foundation
import ELFKit
import DWARF

extension DWARFAbbreviation {
    public static func load(
        at offset: Int,
        from elf: ELFFile,
        isTerminator: inout Bool
    ) -> Self? {
        _load(
            at: offset,
            from: elf,
            isTerminator: &isTerminator
        )
    }
}
