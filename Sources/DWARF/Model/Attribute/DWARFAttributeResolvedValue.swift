//
//  DWARFAttributeResolvedValue.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/26
//  
//

import Foundation

public enum DWARFAttributeResolvedValue {
    case address(DWARFAddress)
    case offset(Int64)
    case signedInteger(Int64)
    case unsignedInteger(UInt64)
    case string(String)
    case bool(Bool)
    case data(Data)
    case debugInfoEntry(DWARFDebugInfoEntry)
    case locations([DWARFLocation])
    case ranges([DWARFRange])
    case expressions([DWARFOperation])
}

extension DWARFAttributeResolvedValue: CustomStringConvertible {
    public var description: String {
        switch self {
        case .address(let dWARFAddress):
            return dWARFAddress.address.description
        case .offset(let int64):
            return int64.description
        case .signedInteger(let int64):
            return int64.description
        case .unsignedInteger(let uInt64):
            return uInt64.description
        case .string(let string):
            return string.description
        case .bool(let bool):
            return bool.description
        case .data(let data):
            return data.description
        case .debugInfoEntry(let entry):
            return "debugInfoEntry (0x\(String(entry.offset, radix: 16))"
        case .locations(let array):
            return array.description
        case .ranges(let array):
            return array.description
        case .expressions(let expression):
            return expression.description
        }
    }
}
