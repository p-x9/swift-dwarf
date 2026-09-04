//
//  DWARFAddress.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/13
//  
//

import Foundation

public struct DWARFAddress: Sendable, Equatable {
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
        guard (1...8).contains(addressSize), (0...8).contains(segmentSelectorSize),
              data.count == addressSize + segmentSelectorSize,
              let address: UInt64 = data.dropFirst(segmentSelectorSize)
                .integerValue(endian: endian) else { return nil }

        let segmentSelector: UInt64?
        if segmentSelectorSize > 0 {
            guard let value: UInt64 = data.prefix(segmentSelectorSize)
                .integerValue(endian: endian) else { return nil }
            segmentSelector = value
        } else {
            segmentSelector = nil
        }
        self.init(segmentSelector: segmentSelector, address: address)
    }
}

extension DWARFAddress {
    package static func load(
        buffer: UnsafeBufferPointer<UInt8>,
        nextOffset: inout Int,
        addressSize: Int,
        segmentSelectorSize: Int,
        endian: Endian
    ) -> Self? {
        guard (1...8).contains(addressSize), (0...8).contains(segmentSelectorSize)
        else { return nil }
        var offset = nextOffset
        let segmentSelector: UInt64?
        if segmentSelectorSize > 0 {
            guard let value: UInt64 = buffer.readFixedWidthInteger(
                byteCount: segmentSelectorSize,
                endian: endian,
                nextOffset: &offset
            ) else { return nil }
            segmentSelector = value
        } else {
            segmentSelector = nil
        }
        guard let address: UInt64 = buffer.readFixedWidthInteger(
            byteCount: addressSize,
            endian: endian,
            nextOffset: &offset
        ) else { return nil }
        nextOffset = offset
        return .init(
            segmentSelector: segmentSelector,
            address: address
        )
    }
}
