//
//  DWARFRangeOpcode.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/30
//  
//

import DWARFC

public enum DWARFRangeOpcode: Sendable, CaseIterable {
    /// DW_RLE_end_of_list
    case end_of_list
    /// DW_RLE_base_addressx
    case base_addressx
    /// DW_RLE_startx_endx
    case startx_endx
    /// DW_RLE_startx_length
    case startx_length
    /// DW_RLE_offset_pair
    case offset_pair
    /// DW_RLE_base_address
    case base_address
    /// DW_RLE_start_end
    case start_end
    /// DW_RLE_start_length
    case start_length
}

extension DWARFRangeOpcode: RawRepresentable {
    public typealias RawValue = UInt8

    public init?(rawValue: RawValue) {
        switch rawValue {
        case numericCast(DW_RLE_end_of_list): self = .end_of_list
        case numericCast(DW_RLE_base_addressx): self = .base_addressx
        case numericCast(DW_RLE_startx_endx): self = .startx_endx
        case numericCast(DW_RLE_startx_length): self = .startx_length
        case numericCast(DW_RLE_offset_pair): self = .offset_pair
        case numericCast(DW_RLE_base_address): self = .base_address
        case numericCast(DW_RLE_start_end): self = .start_end
        case numericCast(DW_RLE_start_length): self = .start_length
        default: return nil
        }
    }

    public var rawValue: RawValue {
        switch self {
        case .end_of_list: numericCast(DW_RLE_end_of_list)
        case .base_addressx: numericCast(DW_RLE_base_addressx)
        case .startx_endx: numericCast(DW_RLE_startx_endx)
        case .startx_length: numericCast(DW_RLE_startx_length)
        case .offset_pair: numericCast(DW_RLE_offset_pair)
        case .base_address: numericCast(DW_RLE_base_address)
        case .start_end: numericCast(DW_RLE_start_end)
        case .start_length: numericCast(DW_RLE_start_length)
        }
    }
}

extension DWARFRangeOpcode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .end_of_list: "DW_RLE_end_of_list"
        case .base_addressx: "DW_RLE_base_addressx"
        case .startx_endx: "DW_RLE_startx_endx"
        case .startx_length: "DW_RLE_startx_length"
        case .offset_pair: "DW_RLE_offset_pair"
        case .base_address: "DW_RLE_base_address"
        case .start_end: "DW_RLE_start_end"
        case .start_length: "DW_RLE_start_length"
        }
    }
}
