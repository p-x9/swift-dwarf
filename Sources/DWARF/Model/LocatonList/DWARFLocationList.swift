//
//  DWARFLocationList.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/30
//
//

import Foundation

public struct DWARFLocationList: Sendable {
    public let header: DWARFLocationListHeader
    public let offset: Int
}

extension DWARFLocationList {
    public var layoutSize: Int {
        header.length + (header.format == ._64bit ? 12 : 4)
    }
}

extension DWARFLocationList {
    package func _offsets(for binary: some _DWARFBinary) throws -> [Int] {
        guard header.offsetEntryCount > 0 else { return [] }
        let offset = offset + header.layoutSize + binary.headerStartOffset
        if header.addressSize == 4 {
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

extension DWARFLocationList {
    public struct Operations: Sequence {
        public let data: Data
        let addressSize: Int
        let format: DWARFFormat
        let segmentSelectorSize: Int

        init(
            data: Data,
            addressSize: Int,
            format: DWARFFormat,
            segmentSelectorSize: Int
        ) {
            self.data = data
            self.addressSize = addressSize
            self.format = format
            self.segmentSelectorSize = segmentSelectorSize
        }

        public func makeIterator() -> Iterator {
            .init(
                data: data,
                addressSize: addressSize,
                format: format,
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
            format: header.format,
            segmentSelectorSize: numericCast(header.segmentSelectorSize)
        )
    }
}

extension DWARFLocationList.Operations {
    public struct Iterator: IteratorProtocol {
        public typealias Element = DWARFLocationOperation

        private let data: Data
        private let addressSize: Int
        private let format: DWARFFormat
        private let segmentSelectorSize: Int
        private var nextOffset: Int = 0

        init(
            data: Data,
            addressSize: Int,
            format: DWARFFormat,
            segmentSelectorSize: Int
        ) {
            self.data = data
            self.addressSize = addressSize
            self.format = format
            self.segmentSelectorSize = segmentSelectorSize
        }

        public mutating func next() -> Element? {
            guard nextOffset < data.count else { return nil }
            var done: Bool = false
            return data.withUnsafeBytes {
                guard let basePointer = $0.baseAddress else { return nil }

                return Element.readNext(
                    basePointer: basePointer.assumingMemoryBound(to: UInt8.self),
                    operaionsSize: data.count,
                    addressSize: addressSize,
                    format: format,
                    segmentSelectorSize: segmentSelectorSize,
                    nextOffset: &nextOffset,
                    done: &done
                )
            }
        }
    }
}

extension DWARFLocationList {
    package static func _load(
        at offset: Int,
        in binary: some _DWARFBinary
    ) throws -> Self? {
        guard let header: DWARFLocationListHeader = try ._load(
            at: offset,
            in: binary
        ) else { return nil }
        return .init(
            header: header,
            offset: offset
        )
    }
}
