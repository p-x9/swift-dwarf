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
    package func _locations(
        for unit: DWARFCompilationUnit,
        in binary: some _DWARFBinary
    ) -> [DWARFLocation]? {
        guard unit.header.version == .v3 || unit.header.version == .v4,
              addressSize == unit.header.addressSize,
              let entries = _entries(in: binary) else { return nil }
        return entries._locations(
            addressSize: addressSize,
            initialBaseAddress: unit._lowPC(in: binary),
            descriptions: {
                Self._parseDescriptions(
                    data: $0, addressSize: addressSize,
                    format: unit.header.format, endian: binary.endian
                )
            }
        )
    }

    package static func _parseDescriptions(
        data: Data,
        addressSize: Int,
        format: DWARFFormat,
        endian: Endian
    ) -> [DWARFOperation]? {
        if data.isEmpty { return [] }
        return data.withUnsafeBytes { buffer in
            guard let pointer = buffer.baseAddress else { return nil }
            var offset = 0
            var operations: [DWARFOperation] = []
            while offset < buffer.count {
                let previousOffset = offset
                var done = false
                guard let operation = DWARFOperation.readNext(
                    basePointer: pointer.assumingMemoryBound(to: UInt8.self),
                    operaionsSize: buffer.count,
                    addressSize: addressSize,
                    format: format,
                    endian: endian,
                    nextOffset: &offset,
                    done: &done
                ), offset > previousOffset, offset <= buffer.count else {
                    return nil
                }
                operations.append(operation)
            }
            return operations
        }
    }

    package static func _parseEntries(
        data: Data,
        addressSize: Int,
        endian: Endian
    ) -> [DWARF3LocationListEntry]? {
        guard let maximumAddress = DWARFAddress.maximumValue(
            addressSize: addressSize
        ) else { return nil }

        var nextOffset = 0
        var entries: [DWARF3LocationListEntry] = []

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
