//
//  DWARFRangeList.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/30
//  
//

import Foundation

public struct DWARFRangeList: Sendable {
    public let header: DWARFRangeListHeader
    public let offset: Int
}

extension DWARFRangeList {
    public var layoutSize: Int {
        header.length + (header.format == ._64bit ? 12 : 4)
    }
}

extension DWARFRangeList {
    package func _offsets(for binary: some _DWARFBinary) throws -> [Int] {
        guard header.offsetEntryCount > 0 else { return [] }
        let offset = offset + header.layoutSize + binary.headerStartOffset
        if header.format == ._32bit {
            let sequence: DataSequence<UInt32> = binary.fileHandle
                .readDataSequence(
                    offset: numericCast(offset),
                    numberOfElements: header.offsetEntryCount
                )
            return sequence.map(Int.init(_:))
        } else {
            let sequence: DataSequence<UInt64> = binary.fileHandle
                .readDataSequence(
                    offset: numericCast(offset),
                    numberOfElements: header.offsetEntryCount
                )
            return sequence.map(Int.init(_:))
        }
    }
}

extension DWARFRangeList {
    public struct Operations: Sequence {
        public let data: Data
        let addressSize: Int
        let segmentSelectorSize: Int

        init(data: Data, addressSize: Int, segmentSelectorSize: Int) {
            self.data = data
            self.addressSize = addressSize
            self.segmentSelectorSize = segmentSelectorSize
        }

        public func makeIterator() -> Iterator {
            .init(
                data: data,
                addressSize: addressSize,
                segmentSelectorSize: segmentSelectorSize
            )
        }
    }

    package func _operations(
        for binary: some _DWARFBinary,
        entryOffset: Int = 0
    ) throws -> Operations {
        var offset = binary.headerStartOffset + offset + header.layoutSize + entryOffset
        if header.offsetEntryCount > 0 {
            if header.addressSize == 4 {
                offset += MemoryLayout<UInt32>.size * header.offsetEntryCount
            } else {
                offset += MemoryLayout<UInt64>.size * header.offsetEntryCount
            }
        }

        let data = try binary.fileHandle
            .readData(
                offset: offset,
                length: layoutSize - header.layoutSize
            )
        return .init(
            data: data,
            addressSize: numericCast(header.addressSize),
            segmentSelectorSize: numericCast(header.segmentSelectorSize)
        )
    }
}

extension DWARFRangeList.Operations {
    public struct Iterator: IteratorProtocol {
        public typealias Element = DWARFRangeOperation

        private let data: Data
        private let addressSize: Int
        private let segmentSelectorSize: Int
        private var nextOffset: Int = 0

        init(data: Data, addressSize: Int, segmentSelectorSize: Int) {
            self.data = data
            self.addressSize = addressSize
            self.segmentSelectorSize = segmentSelectorSize
        }

        public mutating func next() -> Element? {
            guard nextOffset < data.count else { return nil }
            var done: Bool = false
            return data.withUnsafeBytes {
                guard let basePointer = $0.baseAddress else { return nil }

                return DWARFRangeOperation.readNext(
                    basePointer: basePointer.assumingMemoryBound(to: UInt8.self),
                    operaionsSize: data.count,
                    addressSize: addressSize,
                    segmentSelectorSize: segmentSelectorSize,
                    nextOffset: &nextOffset,
                    done: &done
                )
            }
        }
    }
}

extension DWARFRangeList {
    package static func _load(
        at offset: Int,
        in binary: some _DWARFBinary
    ) throws -> Self? {
        guard let header: DWARFRangeListHeader = try ._load(
            at: offset,
            in: binary
        ) else { return nil }
        return .init(
            header: header,
            offset: offset
        )
    }
}
