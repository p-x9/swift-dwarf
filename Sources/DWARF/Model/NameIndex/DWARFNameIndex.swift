//
//  DWARFNameIndex.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/02
//  
//

import Foundation
@testable @_spi(Support) import MachOKit

public struct DWARFNameIndex {
    public let header: DWARFNameIndexHeader
    public let offset: Int
}

extension DWARFNameIndex {
    public var layoutSize: Int {
        header.length + (header.format == ._64bit ? 12 : 4)
    }
}

extension DWARFNameIndex {
    public func compirationUnitOffsets(
        in machO: MachOFile
    ) -> AnyRandomAccessCollection<Int> {
        _loadOffsets(
            in: machO,
            offsetFromHeaderTrail: 0,
            count: header.numberOfCompirationUnits
        )
    }

    public func localTypeUnitOffsets(
        in machO: MachOFile
    ) -> AnyRandomAccessCollection<Int> {
        let offsetFromHeaderTrail = switch header.format {
        case ._32bit:
            MemoryLayout<UInt32>.size * header.numberOfCompirationUnits
        case ._64bit:
            MemoryLayout<UInt64>.size * header.numberOfCompirationUnits
        }
        return _loadOffsets(
            in: machO,
            offsetFromHeaderTrail: offsetFromHeaderTrail,
            count: header.numberOfLocalTypeUnits
        )
    }

    public func foreignTypeUnitOffsets(
        in machO: MachOFile
    ) -> AnyRandomAccessCollection<Int> {
        let offsetFromHeaderTrail = switch header.format {
        case ._32bit:
            MemoryLayout<UInt32>.size * (header.numberOfCompirationUnits + header.numberOfLocalTypeUnits)
        case ._64bit:
            MemoryLayout<UInt64>.size * (header.numberOfCompirationUnits + header.numberOfLocalTypeUnits)
        }
        return _loadOffsets(
            in: machO,
            offsetFromHeaderTrail: offsetFromHeaderTrail,
            count: header.numberOfLocalTypeUnits
        )
    }
}

extension DWARFNameIndex {
    private func _loadOffsets(
        in machO: MachOFile,
        offsetFromHeaderTrail: Int,
        count: Int
    ) -> AnyRandomAccessCollection<Int> {
        let offset = offset + header.layoutSize + machO.headerStartOffset + offsetFromHeaderTrail
        switch header.format {
        case ._32bit:
            let sequence: DataSequence<UInt32> = machO.fileHandle.readDataSequence(
                offset: numericCast(offset),
                numberOfElements: count
            )
            return AnyRandomAccessCollection(
                sequence.map { numericCast($0) }
            )
        case ._64bit:
            let sequence: DataSequence<UInt64> = machO.fileHandle.readDataSequence(
                offset: numericCast(offset),
                numberOfElements: count
            )
            return AnyRandomAccessCollection(
                sequence.map { numericCast($0) }
            )
        }
    }
}

extension DWARFNameIndex {
    public static func load(at offset: Int, from machO: MachOFile) throws -> Self? {
        guard let header: DWARFNameIndexHeader = try .load(
            at: offset,
            from: machO
        ) else { return nil }
        return .init(
            header: header,
            offset: offset
        )
    }
}
