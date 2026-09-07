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
    public let entries: [DWARF3RangeListEntry]
    public let layoutSize: Int
}

extension DWARF3RangeList {
    package static func _parse(
        data: Data,
        offset: Int = 0,
        addressSize: Int,
        endian: Endian
    ) -> Self? {
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
                    return .init(
                        offset: offset,
                        addressSize: addressSize,
                        entries: entries,
                        layoutSize: nextOffset
                    )
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
    package static func _load(
        at offset: Int,
        maximumLength: Int,
        addressSize: Int,
        in binary: some _DWARFBinary
    ) -> Self? {
        guard offset >= 0, maximumLength >= 0 else { return nil }
        let (fileOffset, overflow) = offset.addingReportingOverflow(
            binary.headerStartOffset
        )
        guard !overflow,
              let data = try? binary.fileHandle.readData(
                  offset: fileOffset,
                  length: maximumLength
              ) else {
            return nil
        }
        return _parse(
            data: data,
            offset: offset,
            addressSize: addressSize,
            endian: binary.endian
        )
    }
}
