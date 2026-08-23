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
                data: Data([
                    13,   // Unknown standard opcode.
                    0x80, // Unterminated ULEB128 operand.
                ])
            )
        )

        XCTAssertTrue(operations.isEmpty)
    }
}

private func makeHeader(
    unknownOpcodeOperandCount: UInt8
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
            addressSize: 8,
            offset: 0,
            layoutSize: MemoryLayout<dwarf4_line_header32_t>.size
        )
    )
}
