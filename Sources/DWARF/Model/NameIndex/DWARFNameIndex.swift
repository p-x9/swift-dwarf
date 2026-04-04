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
    package func _compirationUnitOffsets(
        in binary: some _DWARFBinary
    ) -> AnyRandomAccessCollection<Int> {
        _loadOffsets(
            in: binary,
            offsetFromHeaderTrail: 0,
            count: header.numberOfCompirationUnits
        )
    }

    package func _localTypeUnitOffsets(
        in binary: some _DWARFBinary
    ) -> AnyRandomAccessCollection<Int> {
        let leadingCount = header.numberOfCompirationUnits
        let offsetFromHeaderTrail = header.format.addressSize * leadingCount

        return _loadOffsets(
            in: binary,
            offsetFromHeaderTrail: offsetFromHeaderTrail,
            count: header.numberOfLocalTypeUnits
        )
    }

    package func _foreignTypeUnitOffsets(
        in binary: some _DWARFBinary
    ) -> AnyRandomAccessCollection<Int> {
        let leadingCount = header.numberOfCompirationUnits + header.numberOfLocalTypeUnits
        let offsetFromHeaderTrail = header.format.addressSize * leadingCount

        return _loadOffsets(
            in: binary,
            offsetFromHeaderTrail: offsetFromHeaderTrail,
            count: header.numberOfForeignTypeUnits
        )
    }
}

extension DWARFNameIndex {
    package func _hashTable(
        in binary: some _DWARFBinary
    ) -> DWARFNameIndexHashTable {
        var offset = offset + header.layoutSize + binary.headerStartOffset
        let leadingCount = header.numberOfCompirationUnits + header.numberOfLocalTypeUnits + header.numberOfForeignTypeUnits
        offset += header.format.addressSize * leadingCount

        let buckets: DataSequence<UInt32> = binary.fileHandle.readDataSequence(
            offset: numericCast(offset),
            numberOfElements: header.numberOfBuckets
        )
        let hashes: DataSequence<UInt32> = binary.fileHandle.readDataSequence(
            offset: numericCast(offset) + numericCast(MemoryLayout<UInt32>.size * buckets.count),
            numberOfElements: header.numberOfNames
        )

        return .init(
            buckets: buckets,
            hashes: hashes
        )
    }
}

extension DWARFNameIndex {
    package func _nameTable(in binary: some _DWARFBinary) -> DWARFNameIndexNameTable {
        let leadingCount = header.numberOfCompirationUnits + header.numberOfLocalTypeUnits + header.numberOfForeignTypeUnits
        var offsetFromHeaderTrail = header.format.addressSize * leadingCount
        offsetFromHeaderTrail += MemoryLayout<UInt32>.size * (header.numberOfNames + header.numberOfBuckets)

        let entrySize = header.format.addressSize

        let stringOffsets = _loadOffsets(
            in: binary,
            offsetFromHeaderTrail: offsetFromHeaderTrail,
            count: header.numberOfNames
        )

        let entryOffsets = _loadOffsets(
            in: binary,
            offsetFromHeaderTrail: offsetFromHeaderTrail + entrySize * stringOffsets.count,
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
        var offset = offset + header.layoutSize
        let leadingCount = header.numberOfCompirationUnits + header.numberOfLocalTypeUnits + header.numberOfForeignTypeUnits + 2 * header.numberOfNames

        offset += header.format.addressSize * leadingCount

        offset += MemoryLayout<UInt32>.size * (header.numberOfNames + header.numberOfBuckets)

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

        var pos = header.layoutSize
        let leadingCount = header.numberOfCompirationUnits + header.numberOfLocalTypeUnits + header.numberOfForeignTypeUnits + 2 * header.numberOfNames

        pos += header.format.addressSize * leadingCount

        pos += MemoryLayout<UInt32>.size * (header.numberOfNames + header.numberOfBuckets)

        pos += numericCast(header.abbreviationsTableSize)

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

        var pos = header.layoutSize
        let leadingCount = header.numberOfCompirationUnits + header.numberOfLocalTypeUnits + header.numberOfForeignTypeUnits + 2 * header.numberOfNames

        pos += header.format.addressSize * leadingCount

        pos += MemoryLayout<UInt32>.size * (header.numberOfNames + header.numberOfBuckets)

        pos += numericCast(header.abbreviationsTableSize)

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
