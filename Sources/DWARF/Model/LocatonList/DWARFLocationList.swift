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
        let layout = DWARFListTableLayout(
            contributionSize: layoutSize,
            headerSize: header.layoutSize,
            offsetEntryCount: header.offsetEntryCount,
            format: header.format
        )
        let offsetTableRange = try layout.offsetTableRange
        let offset = offset + binary.headerStartOffset
            + offsetTableRange.lowerBound
        if header.format == ._32bit {
            let sequence: DataSequence<UInt32> = binary.fileHandle
                .readDataSequence(
                    offset: numericCast(offset),
                    numberOfElements: header.offsetEntryCount
                )
            return try sequence.map {
                guard let offset = Int(exactly: $0) else {
                    throw DWARFListTableLayoutError.offsetOutOfRange
                }
                return offset
            }
        } else {
            let sequence: DataSequence<UInt64> = binary.fileHandle
                .readDataSequence(
                    offset: numericCast(offset),
                    numberOfElements: header.offsetEntryCount
                )
            return try sequence.map {
                guard let offset = Int(exactly: $0) else {
                    throw DWARFListTableLayoutError.offsetOutOfRange
                }
                return offset
            }
        }
    }
}

extension DWARFLocationList {
    public struct Operations: Sequence {
        public let data: Data
        let addressSize: Int
        let format: DWARFFormat
        let segmentSelectorSize: Int
        let endian: Endian

        init(
            data: Data,
            addressSize: Int,
            format: DWARFFormat,
            segmentSelectorSize: Int,
            endian: Endian
        ) {
            self.data = data
            self.addressSize = addressSize
            self.format = format
            self.segmentSelectorSize = segmentSelectorSize
            self.endian = endian
        }

        public func makeIterator() -> Iterator {
            .init(
                data: data,
                addressSize: addressSize,
                format: format,
                segmentSelectorSize: segmentSelectorSize,
                endian: endian
            )
        }
    }

    package func _operations(
        for binary: some _DWARFBinary,
        entryOffset: Int? = nil
    ) throws -> Operations {
        let layout = DWARFListTableLayout(
            contributionSize: layoutSize,
            headerSize: header.layoutSize,
            offsetEntryCount: header.offsetEntryCount,
            format: header.format
        )
        let range = try layout.operationsRange(entryOffset: entryOffset)
        let offset = binary.headerStartOffset + offset + range.lowerBound

        let data = try binary.fileHandle
            .readData(
                offset: offset,
                length: range.count
            )
        return .init(
            data: data,
            addressSize: numericCast(header.addressSize),
            format: header.format,
            segmentSelectorSize: numericCast(header.segmentSelectorSize),
            endian: binary.endian
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
        private let endian: Endian
        private var nextOffset: Int = 0

        init(
            data: Data,
            addressSize: Int,
            format: DWARFFormat,
            segmentSelectorSize: Int,
            endian: Endian
        ) {
            self.data = data
            self.addressSize = addressSize
            self.format = format
            self.segmentSelectorSize = segmentSelectorSize
            self.endian = endian
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
                    endian: endian,
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
