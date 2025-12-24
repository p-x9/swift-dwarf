//
//  DWARFLocationOperation.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/01
//  
//

public enum DWARFLocationOperation: Sendable, Equatable {
    /// DW_LLE_end_of_list
    case end_of_list
    /// DW_LLE_base_addressx
    case base_addressx(
        addressIndex: UInt64 /*uleb128*/
    )
    /// DW_LLE_startx_endx
    case startx_endx(
        startIndex: UInt64 /*uleb128*/,
        endIndex: UInt64 /*uleb128*/,
        descriptions: [DWARFOperation]
    )
    /// DW_LLE_startx_length
    case startx_length(
        startIndex: UInt64 /*uleb128*/,
        length: UInt64 /*uleb128*/,
        descriptions: [DWARFOperation]
    )
    /// DW_LLE_offset_pair
    case offset_pair(
        startOffset: UInt64 /*uleb128*/,
        endOffset: UInt64 /*uleb128*/,
        descriptions: [DWARFOperation]
    )
    /// DW_LLE_default_location
    case default_location(descriptions: [DWARFOperation])
    /// DW_LLE_base_address
    case base_address(
        address: DWARFAddress
    )
    /// DW_LLE_start_end
    case start_end(
        start: DWARFAddress,
        end: DWARFAddress,
        descriptions: [DWARFOperation]
    )
    /// DW_LLE_start_length
    case start_length(
        start: DWARFAddress,
        length: UInt64 /*uleb128*/,
        descriptions: [DWARFOperation]
    )
}

extension DWARFLocationOperation {
    public var opcode: DWARFLocationOpcode {
        switch self {
        case .end_of_list: .end_of_list
        case .base_addressx: .base_addressx
        case .startx_endx: .startx_endx
        case .startx_length: .startx_length
        case .offset_pair: .offset_pair
        case .default_location: .default_location
        case .base_address: .base_address
        case .start_end: .start_end
        case .start_length: .start_length
        }
    }
}

extension DWARFLocationOperation {
    internal static func readNext(
        basePointer: UnsafePointer<UInt8>,
        operaionsSize: Int,
        addressSize: Int,
        format: DWARFFormat,
        segmentSelectorSize: Int,
        nextOffset: inout Int,
        done: inout Bool
    ) -> DWARFLocationOperation? {
        guard !done, nextOffset < operaionsSize else { return nil }

        let opcodeRaw = basePointer.advanced(by: nextOffset).pointee
        nextOffset += MemoryLayout<UInt8>.size

        guard let opcode = DWARFLocationOpcode(rawValue: opcodeRaw) else {
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
                endIndex: numericCast(endIndex),
                descriptions: readDescriptions(
                    basePointer: basePointer,
                    operaionsSize: operaionsSize,
                    addressSize: addressSize,
                    format: format,
                    nextOffset: &nextOffset
                )
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
                length: numericCast(length),
                descriptions: readDescriptions(
                    basePointer: basePointer,
                    operaionsSize: operaionsSize,
                    addressSize: addressSize,
                    format: format,
                    nextOffset: &nextOffset
                )
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
                endOffset: numericCast(endOffset),
                descriptions: readDescriptions(
                    basePointer: basePointer,
                    operaionsSize: operaionsSize,
                    addressSize: addressSize,
                    format: format,
                    nextOffset: &nextOffset
                )
            )

        case .default_location:
            return .default_location(
                descriptions: readDescriptions(
                    basePointer: basePointer,
                    operaionsSize: operaionsSize,
                    addressSize: addressSize,
                    format: format,
                    nextOffset: &nextOffset
                )
            )

        case .base_address:
            guard let address: DWARFAddress = .load(
                basePointer: basePointer,
                nextOffset: &nextOffset,
                addressSize: addressSize,
                segmentSelectorSize: segmentSelectorSize,
                endian: .little // FIXME: endian
            ) else { return nil }
            return .base_address(
                address: address
            )

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
            return .start_end(
                start: start,
                end: end,
                descriptions: readDescriptions(
                    basePointer: basePointer,
                    operaionsSize: operaionsSize,
                    addressSize: addressSize,
                    format: format,
                    nextOffset: &nextOffset
                )
            )

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
            return .start_length(
                start: start,
                length: numericCast(length),
                descriptions: readDescriptions(
                    basePointer: basePointer,
                    operaionsSize: operaionsSize,
                    addressSize: addressSize,
                    format: format,
                    nextOffset: &nextOffset
                )
            )
        }
    }
}

extension DWARFLocationOperation {
    internal static func readDescriptions(
        basePointer: UnsafePointer<UInt8>,
        operaionsSize: Int,
        addressSize: Int,
        format: DWARFFormat,
        nextOffset: inout Int
    ) -> [DWARFOperation] {
        let (numberOfDescriptions, size) = basePointer
            .advanced(by: nextOffset)
            .readULEB128()
        nextOffset += size

        var operations: [DWARFOperation] = []
        for _ in 0 ..< numberOfDescriptions {
            var done: Bool = false
            guard let operation: DWARFOperation = .readNext(
                basePointer: basePointer,
                operaionsSize: operaionsSize,
                addressSize: addressSize,
                format: format,
                nextOffset: &nextOffset,
                done: &done
            ) else { break }
            operations.append(operation)
        }

        return operations
    }
}
