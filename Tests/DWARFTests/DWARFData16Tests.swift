import XCTest
@testable import DWARF
import DWARFC

final class DWARFData16Tests: XCTestCase {
    func testData16ResolvesAsUInt128() {
        let expected = UInt128.max - 0x1234
        let attribute = DWARFAttributeValue.data16(.init(value: expected))

        XCTAssertEqual(attribute.size(dwarfFormat: ._32bit, addressSize: 4), 16)
        XCTAssertEqual(attribute.constantUInt128Value, expected)
        XCTAssertNil(attribute.constantUIntValue)
        XCTAssertNil(attribute.constantInt128Value)
        XCTAssertNil(attribute.constantIntValue)

        guard case .unsignedInteger(let resolved) = attribute.__value(
            for: nil, in: nil
        ) else {
            return XCTFail("Expected a resolved 128-bit unsigned integer")
        }
        XCTAssertEqual(resolved, expected)
    }

    func testNarrowConstantAccessorsRequireExactConversion() {
        let small = DWARFAttributeValue.data16(.init(value: 42))
        XCTAssertEqual(small.constantUInt128Value, 42)
        XCTAssertEqual(small.constantUIntValue, 42)
        XCTAssertEqual(small.constantInt128Value, 42)
        XCTAssertEqual(small.constantIntValue, 42)

        let negative = DWARFAttributeValue.sdata(.init(value: -1))
        XCTAssertNil(negative.constantUInt128Value)
        XCTAssertNil(negative.constantUIntValue)
        XCTAssertEqual(negative.constantInt128Value, -1)
        XCTAssertEqual(negative.constantIntValue, -1)

        let aboveInt128 = DWARFAttributeValue.data16(
            .init(value: UInt128(Int128.max) + 1)
        )
        XCTAssertNil(aboveInt128.constantInt128Value)
        XCTAssertNil(aboveInt128.constantIntValue)
    }

    func testData16ByteOrder() throws {
        let expected: UInt128 = 0x0123456789abcdef_fedcba9876543210
        let littleEndianBytes: [UInt8] = [
            0x10, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe,
            0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01,
        ]
        let bigEndianBytes = littleEndianBytes.reversed()

        XCTAssertEqual(UInt128(bytes: littleEndianBytes, endian: .little), expected)
        XCTAssertEqual(UInt128(bytes: bigEndianBytes, endian: .big), expected)
    }

    func testData16LoadsFromMachOAndELF() throws {
        var layout = dwarf5_cu_header32_t()
        layout.version = 5
        layout.unit_type = DWARFUnitType.compile.rawValue
        layout.address_size = 8
        let header = DWARFCompilationUnitHeader.version5_32(
            .init(layout: layout, offset: 0)
        )
        let expected: UInt128 = 0x0123456789abcdef_fedcba9876543210

        try UnitTypeBinaryFixture.withData16(
            header: header,
            value: expected
        ) { machO, machOUnit, elf, elfUnit in
            let machOAttribute = try XCTUnwrap(
                machOUnit.debugInfoEntries(in: machO).first?.attributes.first?.value
            )
            let elfAttribute = try XCTUnwrap(
                elfUnit.debugInfoEntries(in: elf).first?.attributes.first?.value
            )
            XCTAssertEqual(machOAttribute.constantUInt128Value, expected)
            XCTAssertEqual(elfAttribute.constantUInt128Value, expected)
        }
    }
}
