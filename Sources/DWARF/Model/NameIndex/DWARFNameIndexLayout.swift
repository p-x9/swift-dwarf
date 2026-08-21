//
//  DWARFNameIndexLayout.swift
//  swift-dwarf
//

internal struct DWARFNameIndexLayout {
    let format: DWARFFormat
    let compilationUnitCount: Int
    let localTypeUnitCount: Int
    let foreignTypeUnitCount: Int
    let bucketCount: Int
    let nameCount: Int
    let abbreviationsTableSize: Int

    init(header: DWARFNameIndexHeader) {
        self.init(
            format: header.format,
            compilationUnitCount: header.numberOfCompilationUnits,
            localTypeUnitCount: header.numberOfLocalTypeUnits,
            foreignTypeUnitCount: header.numberOfForeignTypeUnits,
            bucketCount: header.numberOfBuckets,
            nameCount: header.numberOfNames,
            abbreviationsTableSize: header.abbreviationsTableSize
        )
    }

    init(
        format: DWARFFormat,
        compilationUnitCount: Int,
        localTypeUnitCount: Int,
        foreignTypeUnitCount: Int,
        bucketCount: Int,
        nameCount: Int,
        abbreviationsTableSize: Int
    ) {
        self.format = format
        self.compilationUnitCount = compilationUnitCount
        self.localTypeUnitCount = localTypeUnitCount
        self.foreignTypeUnitCount = foreignTypeUnitCount
        self.bucketCount = bucketCount
        self.nameCount = nameCount
        self.abbreviationsTableSize = abbreviationsTableSize
    }

    private var offsetSize: Int {
        switch format {
        case ._32bit: MemoryLayout<UInt32>.size
        case ._64bit: MemoryLayout<UInt64>.size
        }
    }

    private var signatureSize: Int {
        MemoryLayout<UInt64>.size
    }

    private var hashEntrySize: Int {
        MemoryLayout<UInt32>.size
    }

    var compilationUnitOffsetsOffset: Int { 0 }

    var localTypeUnitOffsetsOffset: Int {
        compilationUnitOffsetsOffset + compilationUnitCount * offsetSize
    }

    var foreignTypeUnitSignaturesOffset: Int {
        localTypeUnitOffsetsOffset + localTypeUnitCount * offsetSize
    }

    var bucketsOffset: Int {
        foreignTypeUnitSignaturesOffset + foreignTypeUnitCount * signatureSize
    }

    var hashesOffset: Int {
        bucketsOffset + bucketCount * hashEntrySize
    }

    var hashCount: Int {
        bucketCount == 0 ? 0 : nameCount
    }

    var stringOffsetsOffset: Int {
        hashesOffset + hashCount * hashEntrySize
    }

    var entryOffsetsOffset: Int {
        stringOffsetsOffset + nameCount * offsetSize
    }

    var abbreviationsOffset: Int {
        entryOffsetsOffset + nameCount * offsetSize
    }

    var entriesOffset: Int {
        abbreviationsOffset + abbreviationsTableSize
    }
}
