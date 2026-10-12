import Foundation
import XCTest
@testable import DWARF
import DWARFC
import DWARFMachO
import DWARFELF

final class DWARFLegacyBlockExpressionTests: XCTestCase {
    private let commonAttributes: [DWARFAttribute] = [
        .location, .string_length, .return_addr, .data_member_location,
        .frame_base, .segment, .static_link, .use_location, .vtable_elem_location,
    ]
    private let version3Attributes: [DWARFAttribute] = [
        .byte_size, .bit_offset, .bit_size, .lower_bound, .upper_bound,
        .count, .allocated, .associated, .data_location, .byte_stride,
    ]

    private func header(_ version: DWARFVersion, _ format: DWARFFormat) -> DWARFCompilationUnitHeader {
        if version == .v5 {
            if format == ._32bit {
                var layout = dwarf5_cu_header32_t()
                layout.version = 5
                layout.unit_type = DWARFUnitType.compile.rawValue
                layout.address_size = 8
                return .version5_32(.init(layout: layout, offset: 0))
            }
            var layout = dwarf5_cu_header64_t()
            layout.unit_length._pad = .max
            layout.version = 5
            layout.unit_type = DWARFUnitType.compile.rawValue
            layout.address_size = 4
            return .version5(.init(layout: layout, offset: 0))
        }
        if format == ._32bit {
            var layout = dwarf4_cu_header32_t()
            layout.version = version.rawValue
            layout.address_size = 8 // Address width is independent of DWARF offset width.
            return .upToVersion4_32(.init(layout: layout, offset: 0))
        }
        var layout = dwarf4_cu_header64_t()
        layout.unit_length._pad = .max
        layout.version = version.rawValue
        layout.address_size = 4
        return .upToVersion4(.init(layout: layout, offset: 0))
    }

    private func bytes(_ value: UInt64, count: Int) -> Data {
        Data((0..<count).map { UInt8(truncatingIfNeeded: value >> ($0 * 8)) })
    }

    private func encoded(_ data: Data, form: DWARFAttributeFormatType) -> Data {
        let width: Int
        switch form {
        case .block2: width = 2
        case .block4: width = 4
        default: width = 1 // Small lengths have a one-byte ULEB128 encoding.
        }
        return bytes(UInt64(data.count), count: width) + data
    }

    private func value(_ data: Data, form: DWARFAttributeFormatType) -> DWARFAttributeValue {
        let block = DWARFAttributeValue.Block(length: UInt64(data.count), data: data)
        switch form {
        case .block1: return .block1(block)
        case .block2: return .block2(block)
        case .block4: return .block4(block)
        default: return .block(block)
        }
    }

    func testBlockExpressionsInMachOAndELF() throws {
        for version: DWARFVersion in [.v2, .v3] {
            let attributes = commonAttributes + (version == .v3 ? version3Attributes : [])
            for format: DWARFFormat in [._32bit, ._64bit] {
                let header = header(version, format)
                let data = Data([0x50, 0x03]) + bytes(0x12345678, count: header.addressSize)
                for form: DWARFAttributeFormatType in [.block, .block1, .block2, .block4] {
                    for attribute in attributes {
                        for indirect in [false, true] {
                            var payload = encoded(data, form: form)
                            if indirect { payload.insert(UInt8(form.rawValue), at: 0) }
                            try UnitTypeBinaryFixture.withListReference(
                                header: header, attribute: attribute,
                                form: indirect ? .indirect : form, value: payload,
                                sectionName: ".debug_ranges"
                            ) { machO, machOUnit, elf, elfUnit in
                                let first = try XCTUnwrap(machOUnit.debugInfoEntries(in: machO).first?.attributes.first?.value)
                                let second = try XCTUnwrap(elfUnit.debugInfoEntries(in: elf).first?.attributes.first?.value)
                                for resolved in [first.value(for: machOUnit, in: machO, attribute: attribute),
                                                 second.value(for: elfUnit, in: elf, attribute: attribute)] {
                                    guard case .expressions(let operations) = resolved else {
                                        return XCTFail("Expected expression: \(version) \(attribute) \(form)")
                                    }
                                    XCTAssertEqual(operations, [.reg0, .addr(0x12345678)])
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func testVersionAndAttributeSelectionPreservesRawData() {
        let rawAttributes: [DWARFAttribute] = [.const_value, .discr_list, .namelist_item,
            .bit_stride, .start_scope, .ranges, .stmt_list, .gnu_vector]
        for version: DWARFVersion in [.v2, .v3, .v4, .v5] {
            let unit = DWARFCompilationUnit(header: header(version, ._32bit), offset: 0)
            for form: DWARFAttributeFormatType in [.block, .block1, .block2, .block4] {
                let data = Data([0x50])
                let value = value(data, form: form)
                for attribute in commonAttributes + version3Attributes + rawAttributes {
                    let isExpression = (version == .v2 && commonAttributes.contains(attribute)) ||
                        (version == .v3 && (commonAttributes + version3Attributes).contains(attribute))
                    let resolved = value.__value(for: unit, in: nil, attribute: attribute)
                    if isExpression { XCTAssertNil(resolved) }
                    else {
                        guard case .data(let actual) = resolved else { return XCTFail("Expected raw data") }
                        XCTAssertEqual(actual, data)
                    }
                }
                for resolved in [value.__value(for: unit, in: nil, attribute: nil),
                                 value.__value(for: nil, in: nil, attribute: .location)] {
                    guard case .data(let actual) = resolved else { return XCTFail("Expected raw data") }
                    XCTAssertEqual(actual, data)
                }
            }
        }
    }

    func testBlockAndExprlocShareExpressionDecoder() throws {
        for version: DWARFVersion in [.v2, .v3, .v4, .v5] {
            for format: DWARFFormat in [._32bit, ._64bit] {
                try UnitTypeBinaryFixture.withUnits(
                    header: header(version, format), rootTag: .compile_unit
                ) { machO, machOUnit, elf, elfUnit in
                    let data = Data([0x9a]) + self.bytes(0x12, count: format == ._32bit ? 4 : 8)
                    for expression in [Data(), data, Data([0x50, 0xff]), Data([0x50, 0x03, 1])] {
                        let values: [DWARFAttributeValue] = version == .v2 || version == .v3
                            ? [.exprloc(.init(length: UInt64(expression.count), data: expression))] +
                                [.block, .block1, .block2, .block4].map { self.value(expression, form: $0) }
                            : [.exprloc(.init(length: UInt64(expression.count), data: expression))]
                        for value in values {
                            for resolved in [value.value(for: machOUnit, in: machO, attribute: .location),
                                             value.value(for: elfUnit, in: elf, attribute: .location)] {
                                if expression == Data() || expression == data {
                                    guard case .expressions(let operations) = resolved else {
                                        return XCTFail("Expected expression")
                                    }
                                    XCTAssertEqual(operations, expression.isEmpty ? [] : [.call_ref(0x12)])
                                } else { XCTAssertNil(resolved) }
                            }
                        }
                    }
                    for value: DWARFAttributeValue in [
                        .block(.init(length: 2, data: Data([0x50]))),
                        .exprloc(.init(length: .max, data: Data([0x50]))),
                    ] {
                        if version == .v4 || version == .v5, case .block = value { continue }
                        XCTAssertNil(value.value(for: machOUnit, in: machO, attribute: .location))
                        XCTAssertNil(value.value(for: elfUnit, in: elf, attribute: .location))
                    }
                }
            }
        }
    }
}
