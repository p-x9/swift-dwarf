//
//  DWARFDirectoryEntryValue.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/26
//  
//

import Foundation
@_spi(Support) import MachOKit
import DWARFC

public struct DWARFFileEntryValue: Sendable {
    public let type: DWARFLineContentType
    public let value: DWARFAttributeValue

    public let layoutSize: Int
}

extension DWARFFileEntryValue {
    public static func load(
        at offset: Int,
        for format: DWARFFileEntryFormat,
        in machO: MachOFile,
        dwarfFormat: DWARFFormat,
        addressSize: Int
    ) throws -> Self? {
        let offset = offset + machO.headerStartOffset

        let value: DWARFAttributeValue? = .load(
            at: offset,
            from: machO,
            as: format.format,
            dwarfFormat: dwarfFormat,
            addressSize: addressSize
        )

        guard let value else { return nil }

        return .init(
            type: format.type,
            value: value,
            layoutSize: value.size(
                dwarfFormat: dwarfFormat,
                addressSize: addressSize
            )
        )
    }
}
