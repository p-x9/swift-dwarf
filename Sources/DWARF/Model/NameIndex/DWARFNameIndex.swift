//
//  DWARFNameIndex.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/02
//  
//

import Foundation

public struct DWARFNameIndex: Sendable {
    public let header: DWARFNameIndexHeader
    public let offset: Int
}

extension DWARFNameIndex {
    public var layoutSize: Int {
        header.length + (header.format == ._64bit ? 12 : 4)
    }
}

extension DWARFNameIndex {
    package func _compilationUnitOffsets(
        in binary: some _DWARFBinary
    ) -> AnyRandomAccessCollection<Int> {
        let layout = DWARFNameIndexLayout(header: header)
        return _loadOffsets(
            in: binary,
            offsetFromHeaderTrail: layout.compilationUnitOffsetsOffset,
            count: header.numberOfCompilationUnits
        )
    }

    package func _localTypeUnitOffsets(
        in binary: some _DWARFBinary
    ) -> AnyRandomAccessCollection<Int> {
        let layout = DWARFNameIndexLayout(header: header)

        return _loadOffsets(
            in: binary,
            offsetFromHeaderTrail: layout.localTypeUnitOffsetsOffset,
            count: header.numberOfLocalTypeUnits
        )
    }

    package func _foreignTypeUnitSignatures(
        in binary: some _DWARFBinary
    ) -> AnyRandomAccessCollection<UInt64> {
        let layout = DWARFNameIndexLayout(header: header)

        let offset = offset + header.layoutSize + binary.headerStartOffset
            + layout.foreignTypeUnitSignaturesOffset
        let sequence: DataSequence<UInt64> = binary.fileHandle.readDataSequence(
            offset: numericCast(offset),
            numberOfElements: header.numberOfForeignTypeUnits
        )
        return AnyRandomAccessCollection(sequence)
    }
}

extension DWARFNameIndex {
    package func _hashTable(
        in binary: some _DWARFBinary
    ) -> DWARFNameIndexHashTable {
        let layout = DWARFNameIndexLayout(header: header)
        let dataOffset = offset + header.layoutSize + binary.headerStartOffset

        let buckets: DataSequence<UInt32> = binary.fileHandle.readDataSequence(
            offset: numericCast(dataOffset + layout.bucketsOffset),
            numberOfElements: header.numberOfBuckets
        )
        let hashes: DataSequence<UInt32> = binary.fileHandle.readDataSequence(
            offset: numericCast(dataOffset + layout.hashesOffset),
            numberOfElements: layout.hashCount
        )

        return .init(
            buckets: buckets,
            hashes: hashes
        )
    }
}

extension DWARFNameIndex {
    package func _nameTable(in binary: some _DWARFBinary) -> DWARFNameIndexNameTable {
        let layout = DWARFNameIndexLayout(header: header)

        let stringOffsets = _loadOffsets(
            in: binary,
            offsetFromHeaderTrail: layout.stringOffsetsOffset,
            count: header.numberOfNames
        )

        let entryOffsets = _loadOffsets(
            in: binary,
            offsetFromHeaderTrail: layout.entryOffsetsOffset,
            count: header.numberOfNames
        )

        return .init(
            stringOffsets: stringOffsets,
            entryOffsets: entryOffsets
        )
    }
}

extension DWARFNameIndex {
    package func _abbreviationsSet(
        in binary: some _DWARFBinary
    ) -> DWARFNameIndexAbbreviationsSet? {
        let layout = DWARFNameIndexLayout(header: header)
        let offset = offset + header.layoutSize + layout.abbreviationsOffset

        return ._load(
            at: offset,
            from: binary
        )
    }
}

extension DWARFNameIndex {
    package func _entries(in binary: some _DWARFBinary) -> [DWARFNameIndexEntry] {
        guard let abbreviationsSet = _abbreviationsSet(in: binary) else {
            return []
        }

        let layout = DWARFNameIndexLayout(header: header)
        var pos = header.layoutSize + layout.entriesOffset

        var entries: [DWARFNameIndexEntry] = []
        while pos < layoutSize {
            guard let entry: DWARFNameIndexEntry = ._load(
                at: offset + pos,
                from: binary,
                dwarfFormat: header.format,
                abbreviationsSet: abbreviationsSet,
                addressSize: header.format.addressSize
            ) else { fatalError() }
            entries.append(entry)
            pos += entry.layoutSize(
                dwarfFoarmat: header.format,
                addressSize: header.format.addressSize
            )
        }

        return entries
    }
}

extension DWARFNameIndex {
    package func _entries(
        at offset: Int, // offset from entries list starts in .debug_names section
        in binary: some _DWARFBinary
    ) -> [DWARFNameIndexEntry] {
        guard let abbreviationsSet = _abbreviationsSet(in: binary) else {
            return []
        }

        let layout = DWARFNameIndexLayout(header: header)
        var pos = header.layoutSize + layout.entriesOffset

        var result: [DWARFNameIndexEntry] = []
        while pos + offset < layoutSize {
            let entry: DWARFNameIndexEntry? = ._load(
                at: self.offset + pos + offset,
                from: binary,
                dwarfFormat: header.format,
                abbreviationsSet: abbreviationsSet,
                addressSize: header.format.addressSize
            )
            guard let entry else { break }
            if entry.tag == .null { break }
            result.append(entry)
            pos += entry.layoutSize(
                dwarfFoarmat: header.format,
                addressSize: header.format.addressSize
            )
        }

        return result
    }
}

extension DWARFNameIndex {
    // ref: DWARF5 p268 (Page 250) 7.33 Name Table Hash Function
    public func hash(for name: String) -> UInt32 {
        let name = name
            .replacingOccurrences(of: "\u{0130}", with: "i")
            .replacingOccurrences(of: "\u{0131}", with: "i")
            .folding(
                options: [.caseInsensitive],
                locale: nil
            )
        var h: UInt32 = 5381
        for c in name.utf8 {
            h = h &* 33 &+ UInt32(c)
        }
        return h
    }
}

extension DWARFNameIndex {
    private func _loadOffsets(
        in binary: some _DWARFBinary,
        offsetFromHeaderTrail: Int,
        count: Int
    ) -> AnyRandomAccessCollection<Int> {
        let offset = offset + header.layoutSize + binary.headerStartOffset + offsetFromHeaderTrail
        switch header.format {
        case ._32bit:
            let sequence: DataSequence<UInt32> = binary.fileHandle.readDataSequence(
                offset: numericCast(offset),
                numberOfElements: count
            )
            return AnyRandomAccessCollection(
                sequence.map { numericCast($0) }
            )
        case ._64bit:
            let sequence: DataSequence<UInt64> = binary.fileHandle.readDataSequence(
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
    package static func _load(
        at offset: Int,
        from binary: some _DWARFBinary
    ) throws -> Self? {
        guard let header: DWARFNameIndexHeader = try ._load(
            at: offset,
            from: binary
        ) else { return nil }
        return .init(
            header: header,
            offset: offset
        )
    }
}
