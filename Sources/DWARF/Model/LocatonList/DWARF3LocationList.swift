//
//  DWARF3LocationList.swift
//  swift-dwarf
//

import Foundation

/// A DWARF3/4 `.debug_loc` list supporting base address selection entries.
///
/// This format is retained by DWARF4. Unlike a DWARF5 `.debug_loclists`
/// contribution, it has no header. The compilation unit supplies the address
/// size, and the list ends with a pair of zero address-sized values.
/// DWARF2 location lists are not supported by this model.
public struct DWARF3LocationList: Sendable, Equatable {
    /// File offset of the first entry, relative to the binary represented by
    /// the containing `MachOFile` or `ELFFile`.
    public let offset: Int

    public let addressSize: Int
}

extension DWARF3LocationList {
    package static func _parseEntries(
        data: Data,
        addressSize: Int,
        endian: Endian
    ) -> [DWARF3LocationListEntry]? {
        guard addressSize > 0,
              addressSize <= MemoryLayout<UInt64>.size else {
            return nil
        }

        var nextOffset = 0
        var entries: [DWARF3LocationListEntry] = []
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
                guard let expressionLength: UInt16 = buffer.readFixedWidthInteger(
                    byteCount: 2,
                    endian: endian,
                    nextOffset: &nextOffset
                ), Int(expressionLength) <= buffer.count - nextOffset else {
                    return nil
                }
                let expressionEnd = nextOffset + Int(expressionLength)
                let expression = Data(buffer[nextOffset..<expressionEnd])
                nextOffset = expressionEnd
                entries.append(
                    .location(
                        beginningOffset: beginning,
                        endOffset: end,
                        expression: expression
                    )
                )
            }
            return nil
        }
    }
}

extension DWARF3LocationList {
    package func _entries(
        in binary: some _DWARFBinary
    ) -> [DWARF3LocationListEntry]? {
        guard let dwarfSegment = binary.dwarfSegment,
              let section = dwarfSegment.debug_loc(in: binary) else {
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

extension DWARF3LocationList {
    package static func _load(
        at offset: Int,
        addressSize: Int,
        from binary: some _DWARFBinary
    ) -> Self? {
        guard offset >= 0,
              addressSize > 0,
              addressSize <= MemoryLayout<UInt64>.size,
              let dwarfSegment = binary.dwarfSegment,
              let section = dwarfSegment.debug_loc(in: binary) else {
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
