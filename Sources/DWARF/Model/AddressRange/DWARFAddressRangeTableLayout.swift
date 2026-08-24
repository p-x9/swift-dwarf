//
//  DWARFAddressRangeTableLayout.swift
//  swift-dwarf
//

internal enum DWARFAddressRangeTableLayoutError: Error {
    case invalidContribution
}

internal struct DWARFAddressRangeTableLayout {
    let contributionSize: Int
    let headerSize: Int
    let tupleSize: Int

    var tuplesRange: Range<Int> {
        get throws {
            guard contributionSize >= 0,
                  headerSize >= 0,
                  tupleSize > 0,
                  headerSize <= contributionSize else {
                throw DWARFAddressRangeTableLayoutError.invalidContribution
            }

            // DWARF Version 4, Section 7.20 and Version 5, Section 7.21: the
            // first tuple starts at an offset that is a multiple of the tuple
            // size, with padding inserted after the fixed header when needed.
            let remainder = headerSize % tupleSize
            let padding = remainder == 0 ? 0 : tupleSize - remainder
            let (start, overflow) = headerSize.addingReportingOverflow(padding)
            guard !overflow, start <= contributionSize else {
                throw DWARFAddressRangeTableLayoutError.invalidContribution
            }
            return start ..< contributionSize
        }
    }
}
