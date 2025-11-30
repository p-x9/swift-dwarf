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
    public var segmentSelector: UInt64?
    public var address: UInt64
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

extension DWARFAddress {
    internal static func load(
        basePointer: UnsafeRawPointer,
        nextOffset: inout Int,
        addressSize: Int,
        segmentSelectorSize: Int,
        endian: Endian
    ) -> Self? {
        let data = Data(
            bytes: basePointer,
            count: addressSize + segmentSelectorSize
        )
        return .init(
            data: data,
            addressSize: addressSize,
            segmentSelectorSize: segmentSelectorSize,
            endian: endian
        )
    }
}
