//
//  DWARF3RangeList.swift
//  swift-dwarf
//

import Foundation

/// A range list in the `.debug_ranges` format introduced in DWARF3.
///
/// This format is retained by DWARF4. Unlike a DWARF5 `.debug_rnglists`
/// contribution, it has no header. The compilation unit supplies the address
/// size, and the list ends with a pair of zero address-sized values.
public struct DWARF3RangeList: Sendable, Equatable {
    /// File offset of the first entry, relative to the binary represented by
    /// the containing `MachOFile` or `ELFFile`.
    public let offset: Int

    public let addressSize: Int
}

extension DWARF3RangeList {
    package static func _parseEntries(
        data: Data,
        addressSize: Int,
        endian: Endian
    ) -> [DWARF3RangeListEntry]? {
        guard addressSize > 0,
              addressSize <= MemoryLayout<UInt64>.size else {
            return nil
        }

        var nextOffset = 0
        var entries: [DWARF3RangeListEntry] = []
        let maximumAddress = addressSize == MemoryLayout<UInt64>.size
            ? UInt64.max
            : (UInt64(1) << (addressSize * 8)) - 1

        return data.withUnsafeBytes { rawBuffer in
            let buffer = rawBuffer.bindMemory(to: UInt8.self)
            while nextOffset < buffer.count {
                guard let beginning: UInt64 = buffer.readFixedWidthInteger(
                    byteCount: addressSize,
                    endian: endian,
                    nextOffset: &nextOffset
                ), let end: UInt64 = buffer.readFixedWidthInteger(
                    byteCount: addressSize,
                    endian: endian,
                    nextOffset: &nextOffset
                ) else {
                    return nil
                }

                if beginning == 0, end == 0 {
                    entries.append(.endOfList)
                    return entries
                }

                if beginning == maximumAddress {
                    entries.append(.baseAddressSelection(address: end))
                    continue
                }

                guard end >= beginning else { return nil }
                entries.append(
                    .range(
                        beginningOffset: beginning,
                        endOffset: end
                    )
                )
            }
            return nil
        }
    }
}

extension DWARF3RangeList {
    package func _entries(
        in binary: some _DWARFBinary
    ) -> [DWARF3RangeListEntry]? {
        guard let dwarfSegment = binary.dwarfSegment,
              let section = dwarfSegment.debug_ranges(in: binary) else {
            return nil
        }

        let sectionOffset = offset - section.offset
        let (fileOffset, fileOffsetOverflow) = offset
            .addingReportingOverflow(binary.headerStartOffset)
        guard !fileOffsetOverflow,
              let data = try? binary.fileHandle.readData(
                  offset: fileOffset,
                  length: section.size - sectionOffset
              ) else {
            return nil
        }
        return Self._parseEntries(
            data: data,
            addressSize: addressSize,
            endian: binary.endian
        )
    }
}

extension DWARF3RangeList {
    package static func _load(
        at offset: Int,
        addressSize: Int,
        from binary: some _DWARFBinary
    ) -> Self? {
        guard offset >= 0,
              addressSize > 0,
              addressSize <= MemoryLayout<UInt64>.size,
              let dwarfSegment = binary.dwarfSegment,
              let section = dwarfSegment.debug_ranges(in: binary) else {
            return nil
        }

        let (sectionEnd, overflow) = section.offset
            .addingReportingOverflow(section.size)
        guard !overflow,
              offset >= section.offset,
              offset <= sectionEnd,
              sectionEnd - offset >= addressSize * 2 else {
            return nil
        }
        return .init(offset: offset, addressSize: addressSize)
    }
}
