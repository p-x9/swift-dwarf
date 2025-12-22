//
//  DWARFLineTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/27
//  
//

import Foundation
@_spi(Support) import MachOKit

public struct DWARFLineTable {
    public let header: DWARFLineHeader
    public let offset: Int
}

extension DWARFLineTable {
    public var layoutSize: Int {
        header.length + (header.format == ._64bit ? 12 : 4)
    }
}

extension DWARFLineTable {
    public struct Operations: Sequence {
        private let header: DWARFLineHeader
        public let data: Data

        init(
            header: DWARFLineHeader,
            data: Data
        ) {
            self.header = header
            self.data = data
        }

        public func makeIterator() -> Iterator {
            .init(header: header, data: data)
        }
    }

    public func oprations(for machO: MachOFile) throws -> Operations {
        let data = try machO.fileHandle
            .readData(
                offset: machO.headerStartOffset + offset + header.layoutSize,
                length: layoutSize - header.layoutSize
            )
        return .init(
            header: header,
            data: data
        )
    }
}

extension DWARFLineTable.Operations {
    public struct Iterator: IteratorProtocol {
        public typealias Element = DWARFLineOperation

        private let header: DWARFLineHeader
        private let data: Data
        private var nextOffset: Int = 0

        init(header: DWARFLineHeader, data: Data) {
            self.header = header
            self.data = data
        }

        public mutating func next() -> Element? {
            guard nextOffset < data.count else { return nil }
            var done: Bool = false
            return data.withUnsafeBytes {
                guard let basePointer = $0.baseAddress else { return nil }

                return DWARFLineOperation.readNext(
                    basePointer: basePointer.assumingMemoryBound(to: UInt8.self),
                    operaionsSize: data.count,
                    lineHeader: header,
                    nextOffset: &nextOffset,
                    done: &done
                )
            }
        }
    }
}

extension DWARFLineTable {
    public static func load(at offset: Int, in machO: MachOFile) throws -> Self? {
        guard let header: DWARFLineHeader = try .load(
            at: offset + machO.headerStartOffset,
            in: machO
        ) else { return nil }
        return .init(
            header: header,
            offset: offset
        )
    }
}
