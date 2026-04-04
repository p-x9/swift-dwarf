//
//  DWARFAddressTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/13
//  
//

import Foundation
import DWARFC

public struct DWARFAddressTable: Sendable {
    public let header: DWARFAddressTableHeader
    public let offset: Int
}

extension DWARFAddressTable {
    public var layoutSize: Int {
        header.length + (header.format == ._64bit ? 12 : 4)
    }
}

extension DWARFAddressTable {
    package func _addresses(
        in binary: some _DWARFBinary
    ) -> DWARFAddresses {
        let data = try! binary.fileHandle.readData(
            offset: offset + header.layoutSize + binary.headerStartOffset,
            length: layoutSize - header.layoutSize
        )
        return .init(
            addressSize: header.addressSize,
            segmentSelectorSize: header.segmentSelectorSize,
            sequence: .init(
                data: data,
                chunkSize: header.addressSize + header.segmentSelectorSize
            ),
            endian: binary.endian
        )
    }
}

extension DWARFAddressTable {
    package static func _load(
        at offset: Int,
        from binary: some _DWARFBinary
    ) throws -> Self? {
        let offset = offset + binary.headerStartOffset
        let length: UInt32 = try binary.fileHandle.read(offset: offset)
        let is64Bit = length == 0xffffffff

        if is64Bit {
            return .init(
                header: .version5(try binary.fileHandle.read(offset: offset)),
                offset: offset - binary.headerStartOffset
            )
        } else {
            return .init(
                header: .version5_32(try binary.fileHandle.read(offset: offset)),
                offset: offset - binary.headerStartOffset
            )
        }
    }
}
