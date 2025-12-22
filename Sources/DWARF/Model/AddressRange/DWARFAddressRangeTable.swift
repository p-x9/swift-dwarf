//
//  DWARFAddressRangeTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/01
//  
//

import Foundation
@_spi(Support) import MachOKit

public struct DWARFAddressRangeTable {
    public let header: DWARFAddressRangeTableHeader
    public let offset: Int
}

extension DWARFAddressRangeTable {
    public var layoutSize: Int {
        header.length + (header.format == ._64bit ? 12 : 4)
    }
}

extension DWARFAddressRangeTable {
    public func addressRanges(
        in machO: MachOFile
    ) -> DWARFAddressRanges {
        let chunkSize = header.addressSize * 2 + header.segmentSelectorSize
        let offset = offset + header.layoutSize.alignedUp(to: chunkSize) + machO.headerStartOffset

        let data = try! machO.fileHandle.readData(
            offset: offset,
            length: layoutSize - header.layoutSize
        )
        return .init(
            addressSize: header.addressSize,
            segmentSelectorSize: header.segmentSelectorSize,
            sequence: .init(
                data: data,
                chunkSize: chunkSize
            ),
            endian: machO.endian
        )
    }
}

extension DWARFAddressRangeTable {
    public static func load(at offset: Int, from machO: MachOFile) throws -> Self? {
        guard let header: DWARFAddressRangeTableHeader = try .load(
            at: offset + machO.headerStartOffset,
            from: machO
        ) else { return nil }
        return .init(
            header: header,
            offset: offset
        )
    }
}
