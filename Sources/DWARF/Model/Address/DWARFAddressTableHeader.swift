//
//  DWARFAddressTableHeader.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/13
//  
//

import Foundation
@_spi(Support) import MachOKit

public enum DWARFAddressTableHeader {
    case version5(DWARF5AddressTableHeader64)
    case version5_32(DWARF5AddressTableHeader32)
}

extension DWARFAddressTableHeader {
    public var layoutSize: Int {
        switch self {
        case .version5(let header):
            numericCast(header.layoutSize)
        case .version5_32(let header):
            numericCast(header.layoutSize)
        }
    }

    public var format: DWARFFormat {
        switch self {
        case .version5:
                ._64bit
        case .version5_32:
                ._32bit
        }
    }

    // size of `unit_length` field is not contained in `length`
    public var length: Int {
        switch self {
        case .version5(let header):
            numericCast(header.unit_length.value)
        case .version5_32(let header):
            numericCast(header.unit_length.value)
        }
    }

    public var version: DWARFVersion {
        switch self {
        case .version5(let header):
                .init(rawValue: numericCast(header.version))!
        case .version5_32(let header):
                .init(rawValue: numericCast(header.version))!
        }
    }

    public var addressSize: Int {
        switch self {
        case .version5(let header):
            numericCast(header.address_size)
        case .version5_32(let header):
            numericCast(header.address_size)
        }
    }

    public var segmentSelectorSize: Int {
        switch self {
        case .version5(let header):
            numericCast(header.segment_selector_size)
        case .version5_32(let header):
            numericCast(header.segment_selector_size)
        }
    }
}

public struct DWARF5AddressTableHeader64: LayoutWrapper {
    public typealias Layout = dwarf5_addrs_header64_t

    public var layout: Layout
}

public struct DWARF5AddressTableHeader32: LayoutWrapper {
    public typealias Layout = dwarf5_addrs_header32_t

    public var layout: Layout
}
