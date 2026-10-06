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

    func testPublicListReferencesInMachOAndELF() throws {
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
                            if isRange {
                                let first = try XCTUnwrap(machOEntry.rangeList(for: machOUnit, in: machO))
                                let second = try XCTUnwrap(elfEntry.rangeList(for: elfUnit, in: elf))
                                XCTAssertEqual(first.offset, 0x408)
                                XCTAssertEqual(second.offset, 0x408)
                                XCTAssertNotNil(first.entries(in: machO))
                                XCTAssertNotNil(second.entries(in: elf))
                            } else {
                                let first = try XCTUnwrap(machOEntry.locationList(
                                    for: machOUnit, in: machO, attribute: attribute
                                ))
                                let second = try XCTUnwrap(elfEntry.locationList(
                                    for: elfUnit, in: elf, attribute: attribute
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
                        (version == .v4 && index == 2)
                    for attribute in attributes {
                        let entry = DWARFDebugInfoEntry(
                            tag: .variable, abbreviationCode: 1, hasChildren: false,
                            attributes: [(attribute, .indirect(value))],
                            offset: unit.offset + unit.header.actualLayoutSize
                        )
                        XCTAssertEqual(entry._rangeListSectionOffset(for: unit, attribute: attribute),
                            validForm && (attribute == .ranges || (attribute == .start_scope && version == .v4)) ? 0 : nil)
                        XCTAssertEqual(entry._locationListSectionOffset(for: unit, attribute: attribute),
                            validForm && locationAttributes.contains(attribute) ? 0 : nil)
                        XCTAssertNil(entry._locationListSectionOffset(for: unit, attribute: .count))
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
                XCTAssertNil(first.locationList(for: machOUnit, in: machO))
                XCTAssertNil(second.locationList(for: elfUnit, in: elf))
                let wrongUnit = DWARFCompilationUnit(header: machOUnit.header, offset: 0x900)
                XCTAssertNil(first.locationList(for: wrongUnit, in: machO))
            }
        }
    }
}
