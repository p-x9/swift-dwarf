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
    case unknownStandard(opcode: UInt8, operands: [[UInt8]])
    case extended(DWARFLineExtendedOperation)
}

extension DWARFLineOperation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .specal(let v): v.description
        case .standard(let v): v.description
        case .unknownStandard(let opcode, let operands):
            "Unknown standard opcode \(opcode)(operands: \(operands))"
        case .extended(let v): v.description
        }
    }
}

extension DWARFLineOperation {
    internal static func readNext(
        basePointer: UnsafePointer<UInt8>,
        operaionsSize: Int,
        lineHeader: DWARFLineHeader,
        endian: Endian,
        nextOffset: inout Int,
        done: inout Bool
    ) -> DWARFLineOperation? {
        guard !done, nextOffset < operaionsSize else { return nil }

        let opcodeRaw = basePointer.advanced(by: nextOffset).pointee

        switch opcodeRaw {
        case 0x00:
            guard let operation: DWARFLineExtendedOperation = .readNext(
                basePointer: basePointer,
                operaionsSize: operaionsSize,
                addressSize: numericCast(lineHeader.addressSize),
                endian: endian,
                nextOffset: &nextOffset,
                done: &done
            ) else { return nil }
            return .extended(operation)

        case 0x01..<lineHeader.opcodeBase:
            if DWARFLineStandardOpcode(rawValue: opcodeRaw) != nil {
                guard let operation: DWARFLineStandardOperation = .readNext(
                    basePointer: basePointer,
                    operaionsSize: operaionsSize,
                    endian: endian,
                    nextOffset: &nextOffset,
                    done: &done
                ) else { return nil }
                return .standard(operation)
            }

            // DWARF4 6.2.4 p.114; DWARF5 6.2.4 p.156:
            // standard_opcode_lengths[opcode - 1] gives the number of
            // LEB128 operands, allowing unknown standard opcodes to be
            // skipped when opcode_base is extended.
            let lengthsIndex = Int(opcodeRaw) - 1
            guard lineHeader.standardOpcodeLengths.indices.contains(lengthsIndex) else {
                done = true
                return nil
            }

            nextOffset += MemoryLayout<UInt8>.size
            var operands: [[UInt8]] = []
            for _ in 0..<lineHeader.standardOpcodeLengths[lengthsIndex] {
                guard let operand = readLEB128OperandBytes(
                    basePointer: basePointer,
                    operaionsSize: operaionsSize,
                    nextOffset: &nextOffset
                ) else {
                    done = true
                    return nil
                }
                operands.append(operand)
            }
            return .unknownStandard(opcode: opcodeRaw, operands: operands)

        case ...255:
            nextOffset += MemoryLayout<UInt8>.size
            return .specal(opcodeRaw)

        default:
            return nil
        }
    }

    /// Reads one LEB128 operand as raw bytes without assuming signedness.
    private static func readLEB128OperandBytes(
        basePointer: UnsafePointer<UInt8>,
        operaionsSize: Int,
        nextOffset: inout Int
    ) -> [UInt8]? {
        var bytes: [UInt8] = []
        while nextOffset < operaionsSize {
            let byte = basePointer.advanced(by: nextOffset).pointee
            nextOffset += MemoryLayout<UInt8>.size
            bytes.append(byte)

            if byte & 0x80 == 0 {
                return bytes
            }
        }

        return nil
    }
}
