//
//  DWARFAddress.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/13
//  
//

import Foundation
import MachOKit

public struct DWARFAddress {
    public let segmentSelector: UInt64?
    public let address: UInt64
}

extension DWARFAddress {
    init?(
        data: Data,
        addressSize: Int,
        segmentSelectorSize: Int,
        endian: Endian
    ) {
        guard data.count == addressSize + segmentSelectorSize else { return nil }
        if segmentSelectorSize > 0 {
            self.init(
                segmentSelector: data[0..<segmentSelectorSize]
                    .uintValue(endian: endian),
                address: data[segmentSelectorSize ..< segmentSelectorSize + addressSize]
                    .uintValue(endian: endian)
            )
        } else {
            self.init(
                segmentSelector: nil,
                address: data.uintValue(endian: endian)
            )
        }
    }
}
