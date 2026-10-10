import Foundation
import XCTest
@testable import DWARF
import DWARFC
import DWARFMachO
import DWARFELF

final class DWARF5ListReferenceTests: XCTestCase {
    private func header(_ format: DWARFFormat, addressSize: UInt8 = 4) -> DWARFCompilationUnitHeader {
        if format == ._32bit {
            var layout = dwarf5_cu_header32_t()
            layout.version = 5
            layout.unit_type = DWARFUnitType.compile.rawValue
            layout.address_size = addressSize
            return .version5_32(.init(layout: layout, offset: 0))
        }
        var layout = dwarf5_cu_header64_t()
        layout.unit_length._pad = .max
        layout.version = 5
        layout.unit_type = DWARFUnitType.compile.rawValue
        layout.address_size = addressSize
        return .version5(.init(layout: layout, offset: 0))
    }

    private func bytes(_ value: UInt64, count: Int) -> Data {
        Data((0..<count).map { UInt8(truncatingIfNeeded: value >> ($0 * 8)) })
    }

    private func table(
        _ format: DWARFFormat, indexed: Bool, operations: Data,
        listOffsets: [UInt64]? = nil
    ) -> Data {
        let headerSize = format == ._32bit ? 12 : 20
        let width = format == ._32bit ? 4 : 8
        let offsets = indexed ? (listOffsets ?? [UInt64(width)]) : []
        let size = headerSize + offsets.count * width + operations.count
        var data = format == ._32bit
            ? bytes(UInt64(size - 4), count: 4)
            : bytes(UInt64(UInt32.max), count: 4) + bytes(UInt64(size - 12), count: 8)
        data.append(contentsOf: [5, 0, 4, 0]) // version, address size, segment size
        data.append(bytes(UInt64(offsets.count), count: 4))
        for offset in offsets { data.append(bytes(offset, count: width)) }
        data.append(operations)
        return data
    }

    private func operations(location: Bool) -> Data {
        var data = Data([location ? 0x07 : 0x06]) // LLE/RLE_start_end
        data.append(bytes(0x1000, count: 4))
        data.append(bytes(0x1040, count: 4))
        if location { data.append(contentsOf: [1, 0x50]) } // expr length, reg0
        data.append(0) // end_of_list
        return data
    }

    private func assertList(
        _ value: DWARFAttributeResolvedValue?, location: Bool,
        start: UInt64 = 0x1000, end: UInt64 = 0x1040,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        let range = DWARFRange(start: .init(address: start), end: .init(address: end))
        if location {
            guard case .locations(let locations) = value else {
                return XCTFail("Expected locations", file: file, line: line)
            }
            XCTAssertEqual(locations.count, 1, file: file, line: line)
            XCTAssertEqual(locations.first?.range, range, file: file, line: line)
            XCTAssertEqual(locations.first?.descriptions, [.reg0], file: file, line: line)
        } else {
            guard case .ranges(let ranges) = value else {
                return XCTFail("Expected ranges", file: file, line: line)
            }
            XCTAssertEqual(ranges, [range], file: file, line: line)
        }
    }

    func testDirectReferencesWithoutBaseOrAddressTables() throws {
        let locationAttributes: [DWARFAttribute] = [.location, .string_length, .return_addr,
            .data_member_location, .frame_base, .segment, .static_link, .use_location,
            .vtable_elem_location]
        for format: DWARFFormat in [._32bit, ._64bit] {
            let headerSize = format == ._32bit ? 12 : 20
            for indexed in [false, true] {
                for attribute in [.ranges, .start_scope] + locationAttributes {
                    let location = locationAttributes.contains(attribute)
                    let data = table(format, indexed: indexed, operations: operations(location: location))
                    let offset = headerSize + (indexed ? (format == ._32bit ? 4 : 8) : 0)
                    for indirect in [false, true] {
                        var value = bytes(UInt64(offset), count: format == ._32bit ? 4 : 8)
                        if indirect { value.insert(UInt8(DWARFAttributeFormatType.sec_offset.rawValue), at: 0) }
                        try UnitTypeBinaryFixture.withDWARF5Lists(
                            header: header(format), sectionName: location ? ".debug_loclists" : ".debug_rnglists",
                            data: data, rootAttributes: [(attribute, indirect ? .indirect : .sec_offset, value)]
                        ) { machO, machOUnit, elf, elfUnit in
                            let first = try XCTUnwrap(machOUnit.debugInfoEntries(in: machO).first?.attributes.first?.value)
                            let second = try XCTUnwrap(elfUnit.debugInfoEntries(in: elf).first?.attributes.first?.value)
                            self.assertList(first.value(for: machOUnit, in: machO, attribute: attribute), location: location)
                            self.assertList(second.value(for: elfUnit, in: elf, attribute: attribute), location: location)
                        }
                    }
                }
            }
        }
    }

    func testPublicTableAPIsResolveAllAndIndividualLists() throws {
        for format: DWARFFormat in [._32bit, ._64bit] {
            for location in [false, true] {
                let directOperations = operations(location: location)
                var offsetPair = Data([4, 0x10, 0x20])
                if location { offsetPair.append(contentsOf: [1, 0x50]) }
                offsetPair.append(0)
                let payload = Data([0]) + directOperations + offsetPair
                let width = format == ._32bit ? 4 : 8
                for indexed in [false, true] {
                    let firstOffset = indexed ? width * 3 : 0
                    let offsets = [firstOffset, firstOffset + 1,
                                   firstOffset + 1 + directOperations.count]
                    try UnitTypeBinaryFixture.withDWARF5Lists(
                        header: header(format), sectionName: location ? ".debug_loclists" : ".debug_rnglists",
                        data: table(format, indexed: indexed, operations: payload, listOffsets: offsets.map(UInt64.init)),
                        rootAttributes: [(.low_pc, .addr, bytes(0x2000, count: 4))]
                    ) { machO, machOUnit, elf, elfUnit in
                        let expected: [[DWARFRange]] = [[],
                            [.init(start: .init(address: 0x1000), end: .init(address: 0x1040))],
                            [.init(start: .init(address: 0x2010), end: .init(address: 0x2020))],
                        ]
                        if location {
                            let first = try XCTUnwrap(machO.dwarf.locationListTables.first)
                            let second = try XCTUnwrap(elf.dwarf.locationListTables.first)
                            for lists in [first.locations(for: machOUnit, in: machO), second.locations(for: elfUnit, in: elf)] {
                                let lists = try XCTUnwrap(lists)
                                XCTAssertEqual(lists.map { $0.map(\.range) }, expected)
                                XCTAssertEqual(lists.map { $0.map(\.descriptions) }, [[], [[.reg0]], [[.reg0]]])
                            }
                            for (index, offset) in offsets.enumerated() {
                                let a = try XCTUnwrap(first.locations(for: machOUnit, in: machO, entryOffset: offset))
                                let b = try XCTUnwrap(second.locations(for: elfUnit, in: elf, entryOffset: offset))
                                XCTAssertEqual(a.map(\.range), expected[index])
                                XCTAssertEqual(b.map(\.range), expected[index])
                            }
                        } else {
                            let first = try XCTUnwrap(machO.dwarf.rangeListTables.first)
                            let second = try XCTUnwrap(elf.dwarf.rangeListTables.first)
                            XCTAssertEqual(first.ranges(for: machOUnit, in: machO), expected)
                            XCTAssertEqual(second.ranges(for: elfUnit, in: elf), expected)
                            for (index, offset) in offsets.enumerated() {
                                XCTAssertEqual(first.ranges(for: machOUnit, in: machO, entryOffset: offset), expected[index])
                                XCTAssertEqual(second.ranges(for: elfUnit, in: elf, entryOffset: offset), expected[index])
                            }
                        }
                    }
                }
            }
        }
    }

    func testPublicTableAPIsRejectAddressSizeMismatch() throws {
        for location in [false, true] {
            try UnitTypeBinaryFixture.withDWARF5Lists(
                header: header(._32bit, addressSize: 8),
                sectionName: location ? ".debug_loclists" : ".debug_rnglists",
                data: table(._32bit, indexed: false, operations: Data([0]))
            ) { machO, machOUnit, elf, elfUnit in
                if location {
                    let first = try XCTUnwrap(machO.dwarf.locationListTables.first)
                    let second = try XCTUnwrap(elf.dwarf.locationListTables.first)
                    XCTAssertNil(first.locations(for: machOUnit, in: machO))
                    XCTAssertNil(second.locations(for: elfUnit, in: elf))
                    XCTAssertNil(first.locations(for: machOUnit, in: machO, entryOffset: 0))
                    XCTAssertNil(second.locations(for: elfUnit, in: elf, entryOffset: 0))
                } else {
                    let first = try XCTUnwrap(machO.dwarf.rangeListTables.first)
                    let second = try XCTUnwrap(elf.dwarf.rangeListTables.first)
                    XCTAssertNil(first.ranges(for: machOUnit, in: machO))
                    XCTAssertNil(second.ranges(for: elfUnit, in: elf))
                }
            }
        }
    }

    func testSelectsListInSecondContributionAndMatchesIndexedReference() throws {
        for format: DWARFFormat in [._32bit, ._64bit] {
            for location in [false, true] {
                let first = table(format, indexed: false, operations: Data([0]))
                let second = table(format, indexed: true, operations: operations(location: location))
                let headerSize = format == ._32bit ? 12 : 20
                let width = format == ._32bit ? 4 : 8
                let base = first.count + headerSize
                let direct = DWARFAttributeValue.sec_offset(.init(offset: UInt64(base + width)))
                let indexed: DWARFAttributeValue = location ? .loclistx(.init(index: 0)) : .rnglistx(.init(index: 0))
                let attribute: DWARFAttribute = location ? .location : .ranges
                try UnitTypeBinaryFixture.withDWARF5Lists(
                    header: header(format), sectionName: location ? ".debug_loclists" : ".debug_rnglists",
                    data: first + second,
                    rootAttributes: [(location ? .loclists_base : .rnglists_base, .sec_offset, bytes(UInt64(base), count: width))]
                ) { machO, machOUnit, elf, elfUnit in
                    for value in [direct, indexed] {
                        self.assertList(value.value(for: machOUnit, in: machO, attribute: attribute), location: location)
                        self.assertList(value.value(for: elfUnit, in: elf, attribute: attribute), location: location)
                    }
                }
            }
        }
    }

    func testRejectsNonListOffsetsAndAddressSizeMismatch() throws {
        for format: DWARFFormat in [._32bit, ._64bit] {
            for location in [false, true] {
                let data = table(format, indexed: true, operations: operations(location: location))
                let headerSize = format == ._32bit ? 12 : 20
                let listStart = headerSize + (format == ._32bit ? 4 : 8)
                let attribute: DWARFAttribute = location ? .location : .ranges
                for size: UInt8 in [4, 8] {
                    try UnitTypeBinaryFixture.withDWARF5Lists(
                        header: header(format, addressSize: size),
                        sectionName: location ? ".debug_loclists" : ".debug_rnglists", data: data
                    ) { machO, machOUnit, elf, elfUnit in
                        var offsets: [UInt64] = [0, UInt64(headerSize - 1), UInt64(headerSize),
                            UInt64(listStart - 1), UInt64(data.count), UInt64(data.count + 1), .max]
                        if size == 8 { offsets.append(UInt64(listStart)) }
                        for offset in offsets {
                            let value = DWARFAttributeValue.sec_offset(.init(offset: offset))
                            XCTAssertNil(value.value(for: machOUnit, in: machO, attribute: attribute))
                            XCTAssertNil(value.value(for: elfUnit, in: elf, attribute: attribute))
                        }
                    }
                }
            }
        }
    }

    func testSelectsUnindexedListDespiteBasePointingToAnotherTable() throws {
        for location in [false, true] {
            let first = table(._32bit, indexed: true, operations: Data([0]))
            let second = table(._32bit, indexed: false, operations: Data([0]) + operations(location: location))
            let value = DWARFAttributeValue.sec_offset(.init(offset: UInt64(first.count + 13)))
            try UnitTypeBinaryFixture.withDWARF5Lists(
                header: header(._32bit), sectionName: location ? ".debug_loclists" : ".debug_rnglists",
                data: first + second,
                rootAttributes: [(location ? .loclists_base : .rnglists_base, .sec_offset, bytes(12, count: 4))]
            ) { machO, machOUnit, elf, elfUnit in
                let attribute: DWARFAttribute = location ? .location : .ranges
                self.assertList(value.value(for: machOUnit, in: machO, attribute: attribute), location: location)
                self.assertList(value.value(for: elfUnit, in: elf, attribute: attribute), location: location)
            }
        }
    }

    func testMissingListSectionsReturnNil() throws {
        try UnitTypeBinaryFixture.withUnits(
            header: header(._32bit), rootTag: .compile_unit
        ) { machO, machOUnit, elf, elfUnit in
            let value = DWARFAttributeValue.sec_offset(.init(offset: 12))
            for attribute: DWARFAttribute in [.ranges, .location] {
                XCTAssertNil(value.value(for: machOUnit, in: machO, attribute: attribute))
                XCTAssertNil(value.value(for: elfUnit, in: elf, attribute: attribute))
            }
        }
    }

    func testResolvesInitialBaseAndStopsAtFirstTerminator() throws {
        for location in [false, true] {
            var operations = Data([0x04, 0x10, 0x20]) // offset_pair
            if location { operations.append(contentsOf: [1, 0x50]) }
            operations.append(contentsOf: [0, 0]) // list terminator, another empty list
            let value = DWARFAttributeValue.sec_offset(.init(offset: 12))
            try UnitTypeBinaryFixture.withDWARF5Lists(
                header: header(._32bit), sectionName: location ? ".debug_loclists" : ".debug_rnglists",
                data: table(._32bit, indexed: false, operations: operations),
                rootAttributes: [(.low_pc, .addr, bytes(0x2000, count: 4))]
            ) { machO, machOUnit, elf, elfUnit in
                let attribute: DWARFAttribute = location ? .location : .ranges
                self.assertList(value.value(for: machOUnit, in: machO, attribute: attribute), location: location, start: 0x2010, end: 0x2020)
                self.assertList(value.value(for: elfUnit, in: elf, attribute: attribute), location: location, start: 0x2010, end: 0x2020)
            }
        }
    }

    func testEmptyListsAndMissingTerminatorOrIndexedAddress() throws {
        for location in [false, true] {
            for (operations, valid) in [(Data([0]), true), (Data(), false),
                (Data([1, 0, 0]), false), // base_addressx without .debug_addr
                (operations(location: location).dropLast(), false)] {
                try UnitTypeBinaryFixture.withDWARF5Lists(
                    header: header(._32bit), sectionName: location ? ".debug_loclists" : ".debug_rnglists",
                    data: table(._32bit, indexed: false, operations: Data(operations))
                ) { machO, machOUnit, elf, elfUnit in
                    let value = DWARFAttributeValue.sec_offset(.init(offset: 12))
                    let attribute: DWARFAttribute = location ? .location : .ranges
                    for resolved in [value.value(for: machOUnit, in: machO, attribute: attribute),
                                     value.value(for: elfUnit, in: elf, attribute: attribute)] {
                        if valid {
                            switch resolved {
                            case .ranges(let ranges): XCTAssertTrue(ranges.isEmpty)
                            case .locations(let locations): XCTAssertTrue(locations.isEmpty)
                            default: XCTFail("Expected an empty list")
                            }
                        } else { XCTAssertNil(resolved) }
                    }
                }
            }
        }
    }

    func testKeepsNonListAttributesAndConstantsUnchanged() {
        let unit = DWARFCompilationUnit(header: header(._32bit), offset: 0)
        for attribute: DWARFAttribute in [.rnglists_base, .loclists_base, .addr_base,
            .stmt_list, .data_location, .call_value] {
            guard case .sectionOffset(let offset) = DWARFAttributeValue.sec_offset(.init(offset: 42))
                .__value(for: unit, in: nil, attribute: attribute) else {
                return XCTFail("Expected section offset")
            }
            XCTAssertEqual(offset, 42)
        }
        guard case .unsignedInteger(let value) = DWARFAttributeValue.data4(.init(value: 42))
            .__value(for: unit, in: nil, attribute: .data_member_location) else {
            return XCTFail("Expected constant")
        }
        XCTAssertEqual(value, 42)
        XCTAssertNil(DWARFAttributeValue.sec_offset(.init(offset: 12))
            .__value(for: unit, in: nil, attribute: .ranges))
    }
}
