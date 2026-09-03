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
    package static func load(
        basePointer: UnsafePointer<UInt8>,
        endOffset: Int,
        nextOffset: inout Int,
        addressSize: Int,
        segmentSelectorSize: Int,
        endian: Endian
    ) -> Self? {
        let segmentSelector: UInt64?
        if segmentSelectorSize > 0 {
            guard let value: UInt64 = basePointer.readFixedWidthInteger(
                byteCount: segmentSelectorSize,
                endian: endian,
                nextOffset: &nextOffset,
                endOffset: endOffset
            ) else { return nil }
            segmentSelector = value
        } else {
            segmentSelector = nil
        }
        guard let address: UInt64 = basePointer.readFixedWidthInteger(
            byteCount: addressSize,
            endian: endian,
            nextOffset: &nextOffset,
            endOffset: endOffset
        ) else { return nil }
        return .init(
            segmentSelector: segmentSelector,
            address: address
        )
    }
}
