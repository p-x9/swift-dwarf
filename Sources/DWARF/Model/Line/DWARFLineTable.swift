//
//  DWARFLineTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/27
//  
//

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
