//
//  DWARFRangeEntry.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/30
//  
//

import DWARFC

public enum DWARFRangeOperation: Sendable, Equatable {
    /// DW_RLE_end_of_list
    case end_of_list
    /// DW_RLE_base_addressx
    case base_addressx(addressIndex: UInt64 /*uleb128*/)
    /// DW_RLE_startx_endx
    case startx_endx(startIndex: UInt64 /*uleb128*/, endIndex: UInt64 /*uleb128*/)
    /// DW_RLE_startx_length
    case startx_length(startIndex: UInt64 /*uleb128*/, length: UInt64 /*uleb128*/)
    /// DW_RLE_offset_pair
    case offset_pair(startOffset: UInt64 /*uleb128*/, endOffset: UInt64 /*uleb128*/)
    /// DW_RLE_base_address
    case base_address(address: DWARFAddress)
    /// DW_RLE_start_end
    case start_end(start: DWARFAddress, end: DWARFAddress)
    /// DW_RLE_start_length
    case start_length(start: DWARFAddress, length: UInt64 /*uleb128*/)
}

extension DWARFRangeOperation {
    public var opcode: DWARFRangeOpcode {
        switch self {
        case .end_of_list: return .end_of_list
        case .base_addressx: return .base_addressx
        case .startx_endx: return .startx_endx
        case .startx_length: return .startx_length
        case .offset_pair: return .offset_pair
        case .base_address: return .base_address
        case .start_end: return .start_end
        case .start_length: return .start_length
        }
    }
}

extension DWARFRangeOperation {
    internal static func readNext(
        basePointer: UnsafePointer<UInt8>,
        operaionsSize: Int,
        addressSize: Int,
        segmentSelectorSize: Int,
        nextOffset: inout Int,
        done: inout Bool
    ) -> DWARFRangeOperation? {
        guard !done, nextOffset < operaionsSize else { return nil }

        let opcodeRaw = basePointer.advanced(by: nextOffset).pointee
        nextOffset += MemoryLayout<UInt8>.size

        guard let opcode = DWARFRangeOpcode(rawValue: opcodeRaw) else {
            return nil
        }

        switch opcode {
        case .end_of_list:
            return .end_of_list

        case .base_addressx:
            let (operand, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            return .base_addressx(addressIndex: numericCast(operand))

        case .startx_endx:
            let (startIndex, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size

            let (endIndex, size2) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size2

            return .startx_endx(
                startIndex: numericCast(startIndex),
                endIndex: numericCast(endIndex)
            )

        case .startx_length:
            let (startIndex, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size

            let (length, size2) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size2

            return .startx_length(
                startIndex: numericCast(startIndex),
                length: numericCast(length)
            )

        case .offset_pair:
            let (startOffset, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size

            let (endOffset, size2) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size2

            return .offset_pair(
                startOffset: numericCast(startOffset),
                endOffset: numericCast(endOffset)
            )

        case .base_address:
            guard let address: DWARFAddress = .load(
                basePointer: basePointer,
                nextOffset: &nextOffset,
                addressSize: addressSize,
                segmentSelectorSize: segmentSelectorSize,
                endian: .little // FIXME: endian
            ) else { return nil }
            return .base_address(address: address)

        case .start_end:
            guard let start: DWARFAddress = .load(
                basePointer: basePointer,
                nextOffset: &nextOffset,
                addressSize: addressSize,
                segmentSelectorSize: segmentSelectorSize,
                endian: .little // FIXME: endian
            ) else { return nil }
            guard let end: DWARFAddress = .load(
                basePointer: basePointer,
                nextOffset: &nextOffset,
                addressSize: addressSize,
                segmentSelectorSize: segmentSelectorSize,
                endian: .little // FIXME: endian
            ) else { return nil }
            return .start_end(start: start, end: end)

        case .start_length:
            guard let start: DWARFAddress = .load(
                basePointer: basePointer,
                nextOffset: &nextOffset,
                addressSize: addressSize,
                segmentSelectorSize: segmentSelectorSize,
                endian: .little // FIXME: endian
            ) else { return nil }
            let (length, size) = basePointer
                .advanced(by: nextOffset)
                .readULEB128()
            nextOffset += size
            return .start_length(start: start, length: numericCast(length))
        }
    }
}
