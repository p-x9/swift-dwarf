import Foundation
import XCTest
@testable import DWARF
import DWARFC
import DWARFMachO
import DWARFELF

final class DWARF3ListReferenceTests: XCTestCase {
    private func header(_ version: DWARFVersion, _ format: DWARFFormat) -> DWARFCompilationUnitHeader {
        if format == ._32bit {
            var layout = dwarf4_cu_header32_t()
            layout.unit_length.value = 100
            layout.version = version.rawValue
            layout.address_size = 8 // Offset width must not follow address size.
            return .upToVersion4_32(.init(layout: layout, offset: 0))
        }
        var layout = dwarf4_cu_header64_t()
        layout.unit_length._pad = .max
        layout.unit_length.value = 100
        layout.version = version.rawValue
        layout.address_size = 4
        return .upToVersion4(.init(layout: layout, offset: 0))
    }

    private func bytes(_ value: UInt64, count: Int) -> Data {
        Data((0..<count).map { UInt8(truncatingIfNeeded: value >> ($0 * 8)) })
    }

    func testListReferencesInMachOAndELF() throws {
        for version: DWARFVersion in [.v3, .v4] {
            for format: DWARFFormat in [._32bit, ._64bit] {
                let form: DWARFAttributeFormatType = version == .v4
                    ? .sec_offset : (format == ._32bit ? .data4 : .data8)
                for indirect in [false, true] {
                    var value = bytes(8, count: format == ._32bit ? 4 : 8)
                    if indirect { value.insert(UInt8(form.rawValue), at: 0) }
                    for attribute: DWARFAttribute in [.ranges, .location, .frame_base, .data_member_location] {
                        let isRange = attribute == .ranges
                        try UnitTypeBinaryFixture.withListReference(
                            header: header(version, format), attribute: attribute,
                            form: indirect ? .indirect : form, value: value,
                            sectionName: isRange ? ".debug_ranges" : ".debug_loc"
                        ) { machO, machOUnit, elf, elfUnit in
                            let machOEntry = try XCTUnwrap(machOUnit.debugInfoEntries(in: machO).first)
                            let elfEntry = try XCTUnwrap(elfUnit.debugInfoEntries(in: elf).first)
                            let machOValue = try XCTUnwrap(machOEntry.attributes.first?.value)
                            let elfValue = try XCTUnwrap(elfEntry.attributes.first?.value)
                            for resolved in [
                                machOValue.value(for: machOUnit, in: machO, attribute: attribute),
                                elfValue.value(for: elfUnit, in: elf, attribute: attribute),
                            ] {
                                if isRange {
                                    guard case .ranges(let ranges) = resolved else {
                                        return XCTFail("Expected resolved ranges")
                                    }
                                    XCTAssertTrue(ranges.isEmpty)
                                } else {
                                    guard case .locations(let locations) = resolved else {
                                        return XCTFail("Expected resolved locations")
                                    }
                                    XCTAssertTrue(locations.isEmpty)
                                }
                            }
                            if isRange {
                                let first = try XCTUnwrap(machOValue._rangeList(at: 8, for: machOUnit, in: machO))
                                let second = try XCTUnwrap(elfValue._rangeList(at: 8, for: elfUnit, in: elf))
                                XCTAssertEqual(first.offset, 0x408)
                                XCTAssertEqual(second.offset, 0x408)
                                XCTAssertNotNil(first.entries(in: machO))
                                XCTAssertNotNil(second.entries(in: elf))
                            } else {
                                let first = try XCTUnwrap(machOValue._locationList(
                                    at: 8, for: machOUnit, in: machO
                                ))
                                let second = try XCTUnwrap(elfValue._locationList(
                                    at: 8, for: elfUnit, in: elf
                                ))
                                XCTAssertEqual(first.offset, 0x408)
                                XCTAssertEqual(second.offset, 0x408)
                                XCTAssertNotNil(first.entries(in: machO))
                                XCTAssertNotNil(second.entries(in: elf))
                            }
                        }
                    }
                }
            }
        }
    }

    func testAttributeAndFormSelection() {
        let attributes: [DWARFAttribute] = [.ranges, .start_scope, .location,
            .string_length, .return_addr, .data_member_location, .frame_base,
            .segment, .static_link, .use_location, .vtable_elem_location,
            .data_location, .allocated, .byte_size, .stmt_list]
        let locationAttributes = Set([DWARFAttribute.location, .string_length,
            .return_addr, .data_member_location, .frame_base, .segment,
            .static_link, .use_location, .vtable_elem_location])
        for version: DWARFVersion in [.v2, .v3, .v4, .v5] {
            for format: DWARFFormat in [._32bit, ._64bit] {
                let unit = DWARFCompilationUnit(header: header(version, format), offset: 0x200)
                let values: [DWARFAttributeValue] = [
                    .data4(.init(value: 0)), .data8(.init(value: 0)),
                    .sec_offset(.init(offset: 0)), .data1(.init(value: 0)),
                    .udata(.init(value: 0)), .addr(0),
                    .block(.init(length: 1, data: Data([0x50]))),
                    .exprloc(.init(length: 1, data: Data([0x50]))),
                ]
                for (index, value) in values.enumerated() {
                    let validForm = (version == .v3 && index == (format == ._32bit ? 0 : 1)) ||
                        ((version == .v4 || version == .v5) && index == 2)
                    for attribute in attributes {
                        let isList = validForm && (
                            attribute == .ranges ||
                            (attribute == .start_scope && (version == .v4 || version == .v5)) ||
                            locationAttributes.contains(attribute)
                        )
                        let resolved = value.__value(for: unit, in: nil, attribute: attribute)
                        // A recognized list reference needs a binary, and must not
                        // fall back to a constant or section offset when absent.
                        if isList || index == 7 { // exprloc also needs a binary.
                            XCTAssertNil(resolved)
                        } else {
                            XCTAssertNotNil(resolved)
                        }
                    }
                }
            }
        }
    }

    func testInvalidSectionOffsets() throws {
        for offset in [UInt64(32), UInt64.max] {
            try UnitTypeBinaryFixture.withListReference(
                header: header(.v4, ._64bit), attribute: .location,
                form: .sec_offset, value: bytes(offset, count: 8), sectionName: ".debug_loc"
            ) { machO, machOUnit, elf, elfUnit in
                let first = try XCTUnwrap(machOUnit.debugInfoEntries(in: machO).first)
                let second = try XCTUnwrap(elfUnit.debugInfoEntries(in: elf).first)
                let firstValue = try XCTUnwrap(first.attributes.first?.value)
                let secondValue = try XCTUnwrap(second.attributes.first?.value)
                XCTAssertNil(firstValue._locationList(at: offset, for: machOUnit, in: machO))
                XCTAssertNil(secondValue._locationList(at: offset, for: elfUnit, in: elf))
                XCTAssertNil(firstValue.value(for: machOUnit, in: machO, attribute: .location))
                XCTAssertNil(secondValue.value(for: elfUnit, in: elf, attribute: .location))
            }
        }
    }

    func testResolvedNonemptyLists() throws {
        let ranges = Data([0x10, 0, 0, 0, 0x20, 0, 0, 0]) + Data(repeating: 0, count: 8)
        let locations = Data([0x10, 0, 0, 0, 0x20, 0, 0, 0, 1, 0, 0x50]) + Data(repeating: 0, count: 8)
        for version: DWARFVersion in [.v3, .v4] {
            let header = header(version, ._64bit) // address size 4
            let value: DWARFAttributeValue = .indirect(version == .v3
                ? .data8(.init(value: 0)) : .sec_offset(.init(offset: 0)))
            try UnitTypeBinaryFixture.withLegacyRanges(
                header: header, lowPC: 0x1000, debugRanges: ranges
            ) { machO, machOUnit, elf, elfUnit in
                for resolved in [
                    value.value(for: machOUnit, in: machO, attribute: .ranges),
                    value.value(for: elfUnit, in: elf, attribute: .ranges),
                ] {
                    guard case .ranges(let ranges) = resolved else {
                        return XCTFail("Expected resolved ranges")
                    }
                    XCTAssertEqual(ranges, [.init(start: .init(address: 0x1010), end: .init(address: 0x1020))])
                }
            }
            try UnitTypeBinaryFixture.withLegacyLocations(
                header: header, debugLoc: locations, lowPC: 0x1000
            ) { machO, machOUnit, elf, elfUnit in
                for resolved in [
                    value.value(for: machOUnit, in: machO, attribute: .location),
                    value.value(for: elfUnit, in: elf, attribute: .location),
                ] {
                    guard case .locations(let locations) = resolved else {
                        return XCTFail("Expected resolved locations")
                    }
                    XCTAssertEqual(locations.count, 1)
                    XCTAssertEqual(locations.first?.range, .init(start: .init(address: 0x1010), end: .init(address: 0x1020)))
                    XCTAssertEqual(locations.first?.descriptions, [.reg0])
                }
            }
        }
    }

    func testResolutionDoesNotReinterpretConstantsOrBaseAttributes() throws {
        for version: DWARFVersion in [.v3, .v4] {
            try UnitTypeBinaryFixture.withUnits(
                header: header(version, ._64bit), rootTag: .compile_unit
            ) { machO, machOUnit, elf, elfUnit in
                let constant = DWARFAttributeValue.data8(.init(value: 42))
                let offset = DWARFAttributeValue.sec_offset(.init(offset: 42))
                for resolved in [
                    constant.value(for: machOUnit, in: machO, attribute: .const_value),
                    constant.value(for: elfUnit, in: elf, attribute: .const_value),
                ] {
                    guard case .unsignedInteger(let value) = resolved else {
                        return XCTFail("Expected a constant")
                    }
                    XCTAssertEqual(value, 42)
                }
                for resolved in [
                    offset.value(for: machOUnit, in: machO, attribute: .rnglists_base),
                    offset.value(for: elfUnit, in: elf, attribute: .rnglists_base),
                ] {
                    guard case .sectionOffset(let value) = resolved else {
                        return XCTFail("Expected a section offset")
                    }
                    XCTAssertEqual(value, 42)
                }
                let pointer = version == .v3 ? constant : offset
                XCTAssertNil(pointer.value(for: machOUnit, in: machO, attribute: .ranges))
                XCTAssertNil(pointer.value(for: elfUnit, in: elf, attribute: .location))
                if version == .v4 {
                    guard case .unsignedInteger(let value) = constant.value(
                        for: machOUnit, in: machO, attribute: .data_member_location
                    ) else { return XCTFail("DWARF4 data8 is a constant, not a list reference") }
                    XCTAssertEqual(value, 42)
                }
            }
        }
    }
}
