//
//  DWARFListTableLayout.swift
//  swift-dwarf
//

internal enum DWARFListTableLayoutError: Error {
    case invalidContribution
    case invalidEntryOffset
    case offsetOutOfRange
}

internal struct DWARFListTableLayout {
    let contributionSize: Int
    let headerSize: Int
    let offsetEntryCount: Int
    let format: DWARFFormat

    private var offsetEntrySize: Int {
        switch format {
        case ._32bit: MemoryLayout<UInt32>.size
        case ._64bit: MemoryLayout<UInt64>.size
        }
    }

    private var offsetTableSize: Int {
        get throws {
            guard offsetEntryCount >= 0 else {
                throw DWARFListTableLayoutError.invalidContribution
            }
            let (size, overflow) = offsetEntryCount.multipliedReportingOverflow(
                by: offsetEntrySize
            )
            guard !overflow else {
                throw DWARFListTableLayoutError.invalidContribution
            }
            return size
        }
    }

    var offsetTableRange: Range<Int> {
        get throws {
            guard headerSize >= 0, contributionSize >= headerSize else {
                throw DWARFListTableLayoutError.invalidContribution
            }
            let (end, overflow) = headerSize.addingReportingOverflow(
                try offsetTableSize
            )
            guard !overflow,
                  end >= headerSize,
                  end <= contributionSize else {
                throw DWARFListTableLayoutError.invalidContribution
            }
            return headerSize ..< end
        }
    }

    func operationsRange(entryOffset: Int?) throws -> Range<Int> {
        let offsetTableRange = try offsetTableRange
        let offsetTableSize = offsetTableRange.count
        let entryOffset = entryOffset ?? offsetTableSize

        guard entryOffset >= offsetTableSize else {
            throw DWARFListTableLayoutError.invalidEntryOffset
        }
        let (start, overflow) = offsetTableRange.lowerBound
            .addingReportingOverflow(entryOffset)
        guard !overflow, start <= contributionSize else {
            throw DWARFListTableLayoutError.invalidEntryOffset
        }
        return start ..< contributionSize
    }
}
