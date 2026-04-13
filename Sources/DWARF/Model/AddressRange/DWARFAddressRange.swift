//
//  DWARFAddressRange.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/01
//  
//

import Foundation

public struct DWARFAddressRange: Sendable {
    public var address: DWARFAddress
    public var length: UInt64
}

extension DWARFAddressRange {
    init?(
        data: Data,
        addressSize: Int,
        segmentSelectorSize: Int,
        endian: Endian
    ) {
        guard data.count == addressSize * 2 + segmentSelectorSize else { return nil }
        if segmentSelectorSize > 0 {
            self.init(
                address: .init(
                    segmentSelector: data[0..<segmentSelectorSize]
                        .uintValue(endian: endian),
                    address: data[segmentSelectorSize ..< segmentSelectorSize + addressSize]
                        .uintValue(endian: endian)
                ),
                length: data[(segmentSelectorSize + addressSize)...]
                    .uintValue(endian: endian)
            )
        } else {
            self.init(
                address: .init(
                    segmentSelector: nil,
                    address: data[0..<addressSize]
                        .uintValue(endian: endian)
                ),
                length: data[addressSize...]
                    .uintValue(endian: endian)
            )
        }
    }
}
