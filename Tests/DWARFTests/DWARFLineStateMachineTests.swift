import XCTest
import DWARFC
@testable import DWARF

final class DWARFLineStateMachineTests: XCTestCase {
    func testAdvancePCAccountsForOperationIndex() {
        let operations: [DWARFLineOperation] = [
            .standard(.advance_pc(pcOffset: 2)),
            .standard(.advance_pc(pcOffset: 2)),
            .standard(.copy),
        ]

        let lines = operations.lines(header: makeVLIWHeader())

        XCTAssertEqual(lines.count, 1)
        XCTAssertEqual(lines[0].address, 4)
        XCTAssertEqual(lines[0].op_index, 1)
    }

    func testFixedAdvancePCResetsOperationIndex() {
        let operations: [DWARFLineOperation] = [
            // With opcode_base 13 and line_range 14, opcode 46 advances
            // op_index by two without advancing the address or line.
            .specal(46),
            .standard(.fixed_advance_pc(pcOffset: 5)),
            .standard(.copy),
        ]

        let lines = operations.lines(header: makeVLIWHeader())

        XCTAssertEqual(lines.count, 2)
        XCTAssertEqual(lines[1].address, 5)
        XCTAssertEqual(lines[1].op_index, 0)
    }
}

private func makeVLIWHeader() -> DWARFLineHeader {
    var layout = dwarf4_line_header32_t()
    layout.version = 4
    layout.minimum_instruction_length = 4
    layout.maximum_operations_per_instruction = 3
    layout.default_is_stmt = 1
    layout.line_base = -5
    layout.line_range = 14
    layout.opcode_base = 13

    return .upToVersion4_32(
        .init(
            layout: layout,
            standard_opcode_lengths: [],
            include_directories: [],
            file_names: [],
            addressSize: 8,
            offset: 0,
            layoutSize: MemoryLayout<dwarf4_line_header32_t>.size
        )
    )
}
