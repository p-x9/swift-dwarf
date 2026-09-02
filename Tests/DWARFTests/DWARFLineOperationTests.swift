import Foundation
import XCTest
import DWARFC
@testable import DWARF

final class DWARFLineOperationTests: XCTestCase {
    func testUnknownStandardOpcodeIsPreservedAndParsingContinues() {
        let header = makeHeader(unknownOpcodeOperandCount: 2)
        let operations = Array(
            DWARFLineTable.Operations(
                header: header,
                endian: .little,
                data: Data([
                    13,        // Unknown standard opcode.
                    0x81, 0x01, // First ULEB128 operand.
                    0x7f,      // Second ULEB128 operand.
                    1,         // DW_LNS_copy.
                ])
            )
        )

        XCTAssertEqual(operations.count, 2)
        guard case .unknownStandard(let opcode, let operands) = operations[0] else {
            return XCTFail("Expected the unknown standard opcode")
        }
        XCTAssertEqual(opcode, 13)
        XCTAssertEqual(operands, [[0x81, 0x01], [0x7f]])

        guard case .standard(.copy) = operations[1] else {
            return XCTFail("Expected DW_LNS_copy after the unknown opcode")
        }
        XCTAssertEqual(operations.lines(header: header).count, 1)
    }

    func testTruncatedUnknownStandardOpcodeOperandEndsIteration() {
        let operations = Array(
            DWARFLineTable.Operations(
                header: makeHeader(unknownOpcodeOperandCount: 1),
                endian: .little,
                data: Data([
                    13,   // Unknown standard opcode.
                    0x80, // Unterminated ULEB128 operand.
                ])
            )
        )

        XCTAssertTrue(operations.isEmpty)
    }

    func testFixedWidthOperandsUseSpecifiedEndian() {
        for endian: Endian in [.little, .big] {
            for addressSize in [4, 8] {
                let address = addressSize == 4
                    ? UInt64(0x12345678)
                    : UInt64(0x123456789abcdef0)
                var data = Data([
                    DWARFLineStandardOpcode.fixed_advance_pc.rawValue,
                ])
                appendFixedWidth(0x1234, to: &data, size: 2, endian: endian)
                data.append(0)
                data.append(UInt8(addressSize + 1))
                data.append(DWARFLineExtendedOpcode.set_address.rawValue)
                appendFixedWidth(address, to: &data, size: addressSize, endian: endian)

                let operations = Array(
                    DWARFLineTable.Operations(
                        header: makeHeader(
                            unknownOpcodeOperandCount: 0,
                            addressSize: addressSize
                        ),
                        endian: endian,
                        data: data
                    )
                )
                guard operations.count == 2 else {
                    return XCTFail("Expected two operations, got \(operations.count)")
                }

                guard case .standard(.fixed_advance_pc(let pcOffset)) = operations[0] else {
                    return XCTFail("Expected DW_LNS_fixed_advance_pc")
                }
                XCTAssertEqual(pcOffset, 0x1234, "\(endian), address size \(addressSize)")

                guard case .extended(.set_address(let decodedAddress)) = operations[1] else {
                    return XCTFail("Expected DW_LNE_set_address")
                }
                XCTAssertEqual(decodedAddress, address, "\(endian), address size \(addressSize)")
            }
        }
    }
}

private func makeHeader(
    unknownOpcodeOperandCount: UInt8,
    addressSize: Int = 8
) -> DWARFLineHeader {
    var layout = dwarf4_line_header32_t()
    layout.version = 4
    layout.minimum_instruction_length = 1
    layout.maximum_operations_per_instruction = 1
    layout.default_is_stmt = 1
    layout.line_base = -5
    layout.line_range = 14
    layout.opcode_base = 14

    return .version4_32(
        .init(
            layout: layout,
            standard_opcode_lengths: Array(repeating: 0, count: 12)
                + [unknownOpcodeOperandCount],
            include_directories: [],
            file_names: [],
            addressSize: addressSize,
            offset: 0,
            layoutSize: MemoryLayout<dwarf4_line_header32_t>.size
        )
    )
}

private func appendFixedWidth(
    _ value: UInt64,
    to data: inout Data,
    size: Int,
    endian: Endian
) {
    let bytes = (0..<size).map { index -> UInt8 in
        let shift = endian == .little ? index * 8 : (size - 1 - index) * 8
        return UInt8(truncatingIfNeeded: value >> shift)
    }
    data.append(contentsOf: bytes)
}
