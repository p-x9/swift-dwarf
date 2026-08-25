import XCTest
@_spi(Support) @testable import MachOKit
@testable import DWARF
import DWARFC

final class DWARFLineHeaderOffsetTests: XCTestCase {
    func testMachOSliceHeaderUsesImageRelativeOffsets() throws {
        let headerStartOffset = 0x1000
        let imageOffset = 0x100

        var machHeader = mach_header_64()
        machHeader.magic = MH_MAGIC_64
        machHeader.cputype = CPU_TYPE_ARM64
        machHeader.cpusubtype = CPU_SUBTYPE_ARM64_ALL
        machHeader.filetype = numericCast(MH_OBJECT)

        var lineHeader = dwarf5_line_header32_t()
        lineHeader.unit_length.value = 16
        lineHeader.version = 5
        lineHeader.address_size = 8
        lineHeader.minimum_instruction_length = 1
        lineHeader.maximum_operations_per_instruction = 1
        lineHeader.default_is_stmt = 1
        lineHeader.line_base = -5
        lineHeader.line_range = 14
        lineHeader.opcode_base = 1

        // With opcode_base == 1 there are no standard-opcode lengths. The four
        // zero bytes are the empty directory/file format and entry counts.
        let variableHeader = Data(repeating: 0, count: 4)
        let expectedLayoutSize = MemoryLayout<dwarf5_line_header32_t>.size + variableHeader.count

        var data = Data(
            repeating: 0,
            count: headerStartOffset + imageOffset + expectedLayoutSize
        )
        data.replaceSubrange(
            headerStartOffset ..< headerStartOffset + MemoryLayout<mach_header_64>.size,
            with: bytes(of: &machHeader)
        )
        data.replaceSubrange(
            headerStartOffset + imageOffset ..<
                headerStartOffset + imageOffset + MemoryLayout<dwarf5_line_header32_t>.size,
            with: bytes(of: &lineHeader)
        )
        data.replaceSubrange(
            headerStartOffset + imageOffset + MemoryLayout<dwarf5_line_header32_t>.size ..<
                data.count,
            with: variableHeader
        )

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try data.write(to: url)
        defer { try? FileManager.default.removeItem(at: url) }

        let machO = try MachOFile(
            url: url,
            headerStartOffset: headerStartOffset
        )
        let header = try XCTUnwrap(
            DWARFLineHeader._load(at: imageOffset, in: machO)
        )

        XCTAssertEqual(header.offset, imageOffset)
        XCTAssertEqual(header.layoutSize, expectedLayoutSize)
    }
}

private func bytes<T>(of value: inout T) -> Data {
    withUnsafeBytes(of: &value) { Data($0) }
}
