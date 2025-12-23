//
//  DWARFRangeList.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/30
//  
//

import Foundation
@_spi(Support) import MachOKit

public struct DWARFRangeList {
    public let header: DWARFRangeListHeader
    public let offset: Int
}

extension DWARFRangeList {
    public var layoutSize: Int {
        header.length + (header.format == ._64bit ? 12 : 4)
    }
}

extension DWARFRangeList {
    public func offsets(for machO: MachOFile) throws -> [Int] {
        guard header.offsetEntryCount > 0 else { return [] }
        let offset = offset + header.layoutSize + machO.headerStartOffset
        if header.addressSize == 4 {
            let sequence: DataSequence<UInt32> = machO.fileHandle
                .readDataSequence(
                    offset: numericCast(offset),
                    numberOfElements: header.offsetEntryCount
                )
            return sequence.map(Int.init(_:))
        } else {
            let sequence: DataSequence<UInt64> = machO.fileHandle
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

    public func operations(
        for machO: MachOFile,
        entryOffset: Int = 0
    ) throws -> Operations {
        var offset = machO.headerStartOffset + offset + header.layoutSize + entryOffset
        if header.offsetEntryCount > 0 {
            if header.addressSize == 4 {
                offset += MemoryLayout<UInt32>.size * header.offsetEntryCount
            } else {
                offset += MemoryLayout<UInt64>.size * header.offsetEntryCount
            }
        }

        let data = try machO.fileHandle
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
    public static func load(at offset: Int, in machO: MachOFile) throws -> Self? {
        guard let header: DWARFRangeListHeader = try .load(
            at: offset + machO.headerStartOffset,
            in: machO
        ) else { return nil }
        return .init(
            header: header,
            offset: offset
        )
    }
}
