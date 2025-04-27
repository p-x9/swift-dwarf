//
//  DWARFUnitType.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/04/27
//  
//

import Foundation
import DWARFC

public enum DWARFUnitType: CaseIterable {
    /// DW_UT_compile
    case compile
    /// DW_UT_type
    case type
    /// DW_UT_partial
    case partial
    /// DW_UT_skeleton
    case skeleton
    /// DW_UT_split_compile
    case split_compile
    /// DW_UT_split_type
    case split_type
}

extension DWARFUnitType: RawRepresentable {
    public typealias RawValue = UInt64

    public init?(rawValue: RawValue) {
        switch rawValue {
        case numericCast(DW_UT_compile): self = .compile
        case numericCast(DW_UT_type): self = .type
        case numericCast(DW_UT_partial): self = .partial
        case numericCast(DW_UT_skeleton): self = .skeleton
        case numericCast(DW_UT_split_compile): self = .split_compile
        case numericCast(DW_UT_split_type): self = .split_type
        default: return nil
        }
    }
    public var rawValue: RawValue {
        switch self {
        case .compile: numericCast(DW_UT_compile)
        case .type: numericCast(DW_UT_type)
        case .partial: numericCast(DW_UT_partial)
        case .skeleton: numericCast(DW_UT_skeleton)
        case .split_compile: numericCast(DW_UT_split_compile)
        case .split_type: numericCast(DW_UT_split_type)
        }
    }
}
extension DWARFUnitType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .compile: "DW_UT_compile"
        case .type: "DW_UT_type"
        case .partial: "DW_UT_partial"
        case .skeleton: "DW_UT_skeleton"
        case .split_compile: "DW_UT_split_compile"
        case .split_type: "DW_UT_split_type"
        }
    }
}
