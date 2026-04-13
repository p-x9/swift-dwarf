//
//  DWARFStringOffsetsTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/10
//
//

import Foundation
import DWARFC

public struct DWARFStringOffsetsTable: Sendable {
    public let header: DWARFStringOffsetsTableHeader
    public let offset: Int
}

extension DWARFStringOffsetsTable {
    public var layoutSize: Int {
        header.length + (header.format == ._64bit ? 12 : 4)
    }
}

extension DWARFStringOffsetsTable {
    package func _offsets(
        in binary: some _DWARFBinary
    ) -> [UInt64] {
        let offset = offset + header.layoutSize
        switch header.format {
        case ._32bit:
            let entrySize = MemoryLayout<UInt32>.size
            let offsets: DataSequence<UInt32> = binary.fileHandle.readDataSequence(
                offset: numericCast(offset + binary.headerStartOffset),
                entrySize: entrySize,
                numberOfElements: (layoutSize - header.layoutSize) / entrySize
            )
            return offsets.map { numericCast($0) }
        case ._64bit:
            let entrySize = MemoryLayout<UInt64>.size
            let offsets: DataSequence<UInt64> = binary.fileHandle.readDataSequence(
                offset: numericCast(offset + binary.headerStartOffset),
                entrySize: entrySize,
                numberOfElements: (layoutSize - header.layoutSize) / entrySize
            )
            return offsets.map { numericCast($0) }
        }
    }
}

extension DWARFStringOffsetsTable {
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
