//
//  DWARFAddressRanges.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/01
//  
//

import Foundation

public struct DWARFAddressRanges: Sequence, Sendable {
    public typealias Element = DWARFAddressRange

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
            addressSize * 2 + segmentSelectorSize == sequence.chunkSize,
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

extension DWARFAddressRanges {
    public struct Iterator: IteratorProtocol {
        public let addressSize: Int
        public let segmentSelectorSize: Int
        var sequence: DataChunks
        let endian: Endian
        private var isFinished = false

        init(
            addressSize: Int,
            segmentSelectorSize: Int,
            sequence: DataChunks,
            endian: Endian
        ) {
            self.addressSize = addressSize
            self.segmentSelectorSize = segmentSelectorSize
            self.sequence = sequence
            self.endian = endian
        }

        public mutating func next() -> Element? {
            guard !isFinished else { return nil }
            guard let next = sequence.next() else {
                isFinished = true
                return nil
            }
            guard let range = Element(
                data: next,
                addressSize: addressSize,
                segmentSelectorSize: segmentSelectorSize,
                endian: endian
            ) else {
                isFinished = true
                return nil
            }
            guard range.address.segmentSelector.map({ $0 == 0 }) ?? true,
                  range.address.address == 0,
                  range.length == 0 else {
                return range
            }
            // DWARF Version 4, Section 7.20 and Version 5, Section 7.21 define
            // an all-zero tuple as the terminator; it is not an address range.
            isFinished = true
            return nil
        }
    }
}
