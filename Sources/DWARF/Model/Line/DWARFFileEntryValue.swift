//
//  DWARFDirectoryEntryValue.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/26
//  
//

import Foundation
import DWARFC

public struct DWARFFileEntryValue: Sendable {
    public let type: DWARFLineContentType
    public let value: DWARFAttributeValue

    public let layoutSize: Int
}

extension DWARFFileEntryValue {
    package static func _load(
        at offset: Int,
        for format: DWARFFileEntryFormat,
        in binary: some _DWARFBinary,
        dwarfFormat: DWARFFormat,
        addressSize: Int
    ) throws -> Self? {
        let value: DWARFAttributeValue? = ._load(
            at: offset,
            from: binary,
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
