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

extension DWARFFormat: CustomStringConvertible {
    public var description: String {
        switch self {
        case ._64bit: "DWARF64"
        case ._32bit: "DWARF32"
        }
    }
}

