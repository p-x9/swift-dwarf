//
//  DWARFAddresses.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/13
//  
//

import Foundation

public struct DWARFAddresses: Sequence, Sendable {
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
            return .init(
                data: next,
                addressSize: addressSize,
                segmentSelectorSize: segmentSelectorSize,
                endian: endian
            )
        }
    }
}
