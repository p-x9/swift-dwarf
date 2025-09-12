//
//  DWARFAddresses.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/13
//  
//

import Foundation
import MachOKit

public struct DWARFAddresses: Sequence {
    public typealias Element = DWARFAddress

    public let addressSize: Int
    public let segmentSelectorSize: Int

    private let sequence: DataChunks
    private let endian: Endian

    init(
        addressSize: Int,
        segmentSelectorSize: Int,
        sequence: DataChunks,
        endian: Endian
    ) {
        precondition(
            addressSize + segmentSelectorSize == sequence.chunkSize,
            "Invalid chunk size"
        )
        self.addressSize = addressSize
        self.segmentSelectorSize = segmentSelectorSize
        self.sequence = sequence
        self.endian = endian
    }

    public func makeIterator() -> Iterator {
        .init(
            addressSize: addressSize,
            segmentSelectorSize: segmentSelectorSize,
            sequence: sequence,
            endian: endian
        )
    }
}

extension DWARFAddresses {
    public struct Iterator: IteratorProtocol {
        public let addressSize: Int
        public let segmentSelectorSize: Int
        var sequence: DataChunks
        let endian: Endian

        public mutating func next() -> Element? {
            guard let next = sequence.next() else {
                return nil
            }
            if segmentSelectorSize > 0 {
                return .init(
                    segmentSelector: next[0..<segmentSelectorSize]
                        .uintValue(endian: endian),
                    address: next[segmentSelectorSize ..< segmentSelectorSize + addressSize]
                        .uintValue(endian: endian)
                )
            } else {
                return .init(
                    segmentSelector: nil,
                    address: next.uintValue(endian: endian)
                )
            }
        }
    }
}
