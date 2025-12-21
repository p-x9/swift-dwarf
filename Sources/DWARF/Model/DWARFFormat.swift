//
//  DWARFFormat.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/04/27
//  
//

import Foundation

public enum DWARFFormat {
    case _64bit
    case _32bit
}

extension DWARFFormat {
    public var addressSize: Int {
        switch self {
        case ._64bit: 8
        case ._32bit: 4
        }
    }

    public var unitLengthSize: Int {
        switch self {
        case ._64bit:
            MemoryLayout<dwarf_init_len64>.size
        case ._32bit:
            MemoryLayout<dwarf_init_len32>.size
        }
    }
}

extension DWARFFormat: CustomStringConvertible {
    public var description: String {
        switch self {
        case ._64bit: "DWARF64"
        case ._32bit: "DWARF32"
        }
    }
}

