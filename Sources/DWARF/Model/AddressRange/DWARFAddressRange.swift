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
        guard (1...8).contains(addressSize), (0...8).contains(segmentSelectorSize),
              data.count == addressSize * 2 + segmentSelectorSize else { return nil }
        let addressByteCount = addressSize + segmentSelectorSize
        guard let address = DWARFAddress(
            data: data.prefix(addressByteCount),
            addressSize: addressSize,
            segmentSelectorSize: segmentSelectorSize,
            endian: endian
        ), let length: UInt64 = data.dropFirst(addressByteCount)
            .integerValue(endian: endian) else { return nil }
        self.init(address: address, length: length)
    }
}
