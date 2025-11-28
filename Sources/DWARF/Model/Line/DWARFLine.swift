//
//  DWARFLineState.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/28
//  
//

import Foundation
@_spi(Support) import MachOKit

// DWARF4 6.2.2 State Machine Register p109
// DWARF5 6.2.2 State Machine Register p150
public struct DWARFLine: LayoutWrapper {
    public struct Layout {
        public var address: UInt64
        public var op_index: UInt64
        public var file: UInt64
        public var line: UInt64
        public var column: UInt64
        public var is_stmt: Bool
        public var basic_block: Bool
        public var end_sequence: Bool
        public var prologue_end: Bool
        public var epilogue_begin: Bool
        public var isa: UInt64
        public var discriminator: UInt64
    }

    public var layout: Layout
}

extension DWARFLine {
    public static func initial(defaultOfIsStmt: Bool = false) -> Self {
        .init(
            layout: .init(
                address: 0,
                op_index: 0,
                file: 1,
                line: 1,
                column: 0,
                is_stmt: defaultOfIsStmt,
                basic_block: false,
                end_sequence: false,
                prologue_end: false,
                epilogue_begin: false,
                isa: 0,
                discriminator: 0
            )
        )
    }
}
