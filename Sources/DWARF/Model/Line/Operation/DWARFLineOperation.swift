//
//  DWARFLineOperation.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/28
//  
//


public enum DWARFLineOperation: Sendable {
    case specal(UInt8)
    case standard(DWARFLineStandardOperation)
    case extended(DWARFLineExtendedOperation)
}

extension DWARFLineOperation {
    internal static func readNext(
        basePointer: UnsafePointer<UInt8>,
        operaionsSize: Int,
        lineHeader: DWARFLineHeader,
        nextOffset: inout Int,
        done: inout Bool
    ) -> DWARFLineOperation? {
        guard !done, nextOffset < operaionsSize else { return nil }

        let opcodeRaw = basePointer.advanced(by: nextOffset).pointee
//        nextOffset += MemoryLayout<UInt8>.size

        switch opcodeRaw {
        case 0x00:
            guard let operation: DWARFLineExtendedOperation = .readNext(
                basePointer: basePointer,
                operaionsSize: operaionsSize,
                addressSize: numericCast(lineHeader.addressSize),
                nextOffset: &nextOffset,
                done: &done
            ) else { return nil }
            return .extended(operation)

        case 0x01..<lineHeader.opecodeBase:
            guard let operation: DWARFLineStandardOperation = .readNext(
                basePointer: basePointer,
                operaionsSize: operaionsSize,
                nextOffset: &nextOffset,
                done: &done
            ) else { return nil }
            return .standard(operation)

        case ...255:
            nextOffset += MemoryLayout<UInt8>.size
            return .specal(opcodeRaw)

        default:
            return nil
        }
    }
}
