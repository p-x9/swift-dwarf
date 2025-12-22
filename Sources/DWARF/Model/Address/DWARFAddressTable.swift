//
//  DWARFAddressTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/13
//  
//

import Foundation
@_spi(Support) import MachOKit
import DWARFC

public struct DWARFAddressTable {
    public let header: DWARFAddressTableHeader
    public let offset: Int
}

extension DWARFAddressTable {
    public var layoutSize: Int {
        header.length + (header.format == ._64bit ? 12 : 4)
    }
}

extension DWARFAddressTable {
    public func addresses(
        in machO: MachOFile
    ) -> DWARFAddresses {
        let data = try! machO.fileHandle.readData(
            offset: offset + header.layoutSize + machO.headerStartOffset,
            length: layoutSize - header.layoutSize
        )
        return .init(
            addressSize: header.addressSize,
            segmentSelectorSize: header.segmentSelectorSize,
            sequence: .init(
                data: data,
                chunkSize: header.addressSize + header.segmentSelectorSize
            ),
            endian: machO.endian
        )
    }
}

extension DWARFAddressTable {
    public static func load(
        at offset: Int,
        from machO: MachOFile
    ) throws -> Self? {
        let offset = offset + machO.headerStartOffset
        let length: UInt32 = try machO.fileHandle.read(offset: offset)
        let is64Bit = length == 0xffffffff

        if is64Bit {
            return .init(
                header: .version5(try machO.fileHandle.read(offset: offset)),
                offset: offset - machO.headerStartOffset
            )
        } else {
            return .init(
                header: .version5_32(try machO.fileHandle.read(offset: offset)),
                offset: offset - machO.headerStartOffset
            )
        }
    }
}
