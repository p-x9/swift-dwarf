//
//  DWARFAddressTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/13
//  
//

import Foundation
@testable @_spi(Support) import MachOKit
import DWARFC

public struct DWARFAddressTable {
    public let header: DWARFAddressTableHeader
    public let offset: Int
    public let size: Int
}

extension DWARFAddressTable {
    public func addresses(
        in machO: MachOFile
    ) -> DWARFAddresses {
        let data = try! machO.fileHandle.readData(
            offset: offset + machO.headerStartOffset,
            length: size - header.layoutSize
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

    public func address(
        at index: Int,
        in machO: MachOFile
    ) -> DWARFAddress? {
        let chunkSize = header.addressSize + header.segmentSelectorSize
        guard offset + chunkSize * (index + 1) <= size else { return nil }
        let data = try! machO.fileHandle.readData(
            offset: offset + chunkSize * index + machO.headerStartOffset,
            length: chunkSize
        )
        return .init(
            data: data,
            addressSize: header.addressSize,
            segmentSelectorSize: header.segmentSelectorSize,
            endian: machO.endian
        )
    }
}

extension DWARFAddressTable {
    public static func load(
        at offset: Int,
        size: Int,
        from machO: MachOFile
    ) throws -> Self? {
        let offset = offset + machO.headerStartOffset
        let length: UInt32 = try machO.fileHandle.read(offset: offset)
        let is64Bit = length == 0xffffffff

        if is64Bit {
            return .init(
                header: .version5(try machO.fileHandle.read(offset: offset)),
                offset: offset - machO.headerStartOffset,
                size: size
            )
        } else {
            return .init(
                header: .version5_32(try machO.fileHandle.read(offset: offset)),
                offset: offset - machO.headerStartOffset,
                size: size
            )
        }
    }
}
