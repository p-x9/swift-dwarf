//
//  DWARFLocationOpcode.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/30
//  
//

import DWARFC

public enum DWARFLocationOpcode: Sendable, CaseIterable {
    /// DW_LLE_end_of_list
    case end_of_list
    /// DW_LLE_base_addressx
    case base_addressx
    /// DW_LLE_startx_endx
    case startx_endx
    /// DW_LLE_startx_length
    case startx_length
    /// DW_LLE_offset_pair
    case offset_pair
    /// DW_LLE_default_location
    case default_location
    /// DW_LLE_base_address
    case base_address
    /// DW_LLE_start_end
    case start_end
    /// DW_LLE_start_length
    case start_length
}

extension DWARFLocationOpcode: RawRepresentable {
    public typealias RawValue = UInt8

    public init?(rawValue: RawValue) {
        switch rawValue {
        case numericCast(DW_LLE_end_of_list): self = .end_of_list
        case numericCast(DW_LLE_base_addressx): self = .base_addressx
        case numericCast(DW_LLE_startx_endx): self = .startx_endx
        case numericCast(DW_LLE_startx_length): self = .startx_length
        case numericCast(DW_LLE_offset_pair): self = .offset_pair
        case numericCast(DW_LLE_default_location): self = .default_location
        case numericCast(DW_LLE_base_address): self = .base_address
        case numericCast(DW_LLE_start_end): self = .start_end
        case numericCast(DW_LLE_start_length): self = .start_length
        default: return nil
        }
    }

    public var rawValue: RawValue {
        switch self {
        case .end_of_list: numericCast(DW_LLE_end_of_list)
        case .base_addressx: numericCast(DW_LLE_base_addressx)
        case .startx_endx: numericCast(DW_LLE_startx_endx)
        case .startx_length: numericCast(DW_LLE_startx_length)
        case .offset_pair: numericCast(DW_LLE_offset_pair)
        case .default_location: numericCast(DW_LLE_default_location)
        case .base_address: numericCast(DW_LLE_base_address)
        case .start_end: numericCast(DW_LLE_start_end)
        case .start_length: numericCast(DW_LLE_start_length)
        }
    }
}

extension DWARFLocationOpcode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .end_of_list: "DW_LLE_end_of_list"
        case .base_addressx: "DW_LLE_base_addressx"
        case .startx_endx: "DW_LLE_startx_endx"
        case .startx_length: "DW_LLE_startx_length"
        case .offset_pair: "DW_LLE_offset_pair"
        case .default_location: "DW_LLE_default_location"
        case .base_address: "DW_LLE_base_address"
        case .start_end: "DW_LLE_start_end"
        case .start_length: "DW_LLE_start_length"
        }
    }
}
