//
//  DWARFAddressRangeTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/01
//  
//

import Foundation

public struct DWARFAddressRangeTable: Sendable {
    public let header: DWARFAddressRangeTableHeader
    public let offset: Int
}

extension DWARFAddressRangeTable {
    public var layoutSize: Int {
        header.length + (header.format == ._64bit ? 12 : 4)
    }
}

extension DWARFAddressRangeTable {
    package func _addressRanges(
        in binary: some _DWARFBinary
    ) -> DWARFAddressRanges {
        let chunkSize = header.addressSize * 2 + header.segmentSelectorSize
        let layout = DWARFAddressRangeTableLayout(
            contributionSize: layoutSize,
            headerSize: header.layoutSize,
            tupleSize: chunkSize
        )
        let range = try? layout.tuplesRange
        let data = range.flatMap {
            try? binary.fileHandle.readData(
                offset: offset + $0.lowerBound + binary.headerStartOffset,
                length: $0.count
            )
        } ?? Data()
        return .init(
            addressSize: header.addressSize,
            segmentSelectorSize: header.segmentSelectorSize,
            sequence: .init(
                data: data,
                chunkSize: chunkSize
            ),
            endian: binary.endian
        )
    }
}

extension DWARFAddressRangeTable {
    package static func _load(
        at offset: Int,
        from binary: some _DWARFBinary
    ) throws -> Self? {
        guard let header: DWARFAddressRangeTableHeader = try ._load(
            at: offset,
            from: binary
        ) else { return nil }
        return .init(
            header: header,
            offset: offset
        )
    }
}
