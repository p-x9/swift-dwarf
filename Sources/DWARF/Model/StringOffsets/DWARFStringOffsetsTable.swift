//
//  DWARFStringOffsetsTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/10
//
//

import Foundation
@_spi(Support) import MachOKit
import DWARFC

public struct DWARFStringOffsetsTable {
    public let header: DWARFStringOffsetsTableHeader
    public let offset: Int
}

extension DWARFStringOffsetsTable {
    public var layoutSize: Int {
        header.length + (header.format == ._64bit ? 12 : 4)
    }
}

extension DWARFStringOffsetsTable {
    public func offsets(
        in machO: MachOFile
    ) -> [UInt64] {
        let offset = offset + header.layoutSize
        switch header.format {
        case ._32bit:
            let entrySize = MemoryLayout<UInt32>.size
            let offsets: DataSequence<UInt32> = machO.fileHandle.readDataSequence(
                offset: numericCast(offset + machO.headerStartOffset),
                entrySize: entrySize,
                numberOfElements: (layoutSize - header.layoutSize) / entrySize
            )
            return offsets.map { numericCast($0) }
        case ._64bit:
            let entrySize = MemoryLayout<UInt64>.size
            let offsets: DataSequence<UInt64> = machO.fileHandle.readDataSequence(
                offset: numericCast(offset + machO.headerStartOffset),
                entrySize: entrySize,
                numberOfElements: (layoutSize - header.layoutSize) / entrySize
            )
            return offsets.map { numericCast($0) }
        }
    }
}

extension DWARFStringOffsetsTable {
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
