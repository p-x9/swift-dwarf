import XCTest
@testable import DWARF
import DWARFC
import DWARFMachO
import DWARFELF

final class DWARFUnitRootTests: XCTestCase {
    func testLegacyUnitTypeIsResolvedFromRootDIE() throws {
        for version: DWARFVersion in [.v2, .v3, .v4] {
            for header in legacyHeaders(version: version) {
                for tag: DWARFTag in [.compile_unit, .partial_unit] {
                    let expected: DWARFUnitType? = tag == .compile_unit
                        ? .compile : (version == .v2 ? nil : .partial)
                    try UnitTypeBinaryFixture.withUnits(
                        header: header,
                        rootTag: tag
                    ) { machO, machOUnit, elf, elfUnit in
                        XCTAssertNil(machOUnit.header.unitType)
                        XCTAssertNil(elfUnit.header.unitType)
                        XCTAssertEqual(machOUnit.unitType(in: machO), expected)
                        XCTAssertEqual(elfUnit.unitType(in: elf), expected)
                    }
                }
            }
        }
    }

    func testLegacyUnitTypeRejectsInvalidOrUnavailableRoots() throws {
        for header in legacyHeaders(version: .v4) {
            for tag: DWARFTag? in [nil, .null, .subprogram, .type_unit, .skeleton_unit] {
                try UnitTypeBinaryFixture.withUnits(
                    header: header,
                    rootTag: tag
                ) { machO, machOUnit, elf, elfUnit in
                    XCTAssertNil(machOUnit.unitType(in: machO))
                    XCTAssertNil(elfUnit.unitType(in: elf))
                }
            }
        }
    }

    func testDWARF5UnitTypeUsesHeaderWithoutReadingRootDIE() throws {
        for unitType in DWARFUnitType.allCases {
            for header in version5Headers(unitType: unitType) {
                // No abbreviation section is provided. In particular, split
                // unit kinds must not be collapsed into compile/type kinds.
                try UnitTypeBinaryFixture.withUnits(
                    header: header,
                    rootTag: nil
                ) { machO, machOUnit, elf, elfUnit in
                    XCTAssertEqual(machOUnit.unitType(in: machO), unitType)
                    XCTAssertEqual(elfUnit.unitType(in: elf), unitType)
                }
            }
        }
    }

    func testDWARF4InfoHeadersAcceptFullAndPartialUnits() {
        for header in legacyHeaders(version: .v4) {
            XCTAssertNil(header.unitType)
            for tag in DWARFTag.allCases {
                XCTAssertEqual(
                    header._acceptsRootTag(tag),
                    tag == .compile_unit || tag == .partial_unit,
                    "\(header.format): \(tag)"
                )
            }
        }
    }

    func testDWARF3InfoHeadersAcceptFullAndPartialUnits() {
        for header in legacyHeaders(version: .v3) {
            XCTAssertNil(header.unitType)
            XCTAssertTrue(header._acceptsRootTag(.compile_unit))
            XCTAssertTrue(header._acceptsRootTag(.partial_unit))
            XCTAssertFalse(header._acceptsRootTag(.type_unit))
            XCTAssertFalse(header._acceptsRootTag(.skeleton_unit))
        }
    }

    func testOlderHeadersDoNotAcceptPartialUnits() {
        for version: DWARFVersion in [.v1, .v2] {
            for header in legacyHeaders(version: version) {
                for tag in DWARFTag.allCases {
                    XCTAssertEqual(
                        header._acceptsRootTag(tag),
                        tag == .compile_unit,
                        "\(version), \(header.format): \(tag)"
                    )
                }
            }
        }
    }

    func testDWARF5HeadersAcceptOnlyTheirMatchingRootTag() {
        let cases: [(DWARFUnitType, DWARFTag)] = [
            (.compile, .compile_unit),
            (.partial, .partial_unit),
            (.skeleton, .skeleton_unit),
            (.split_compile, .compile_unit),
            (.type, .type_unit),
            (.split_type, .type_unit)
        ]

        for (unitType, expectedTag) in cases {
            for header in version5Headers(unitType: unitType) {
                XCTAssertEqual(header.unitType, unitType)
                for tag in DWARFTag.allCases {
                    XCTAssertEqual(
                        header._acceptsRootTag(tag),
                        tag == expectedTag,
                        "\(unitType), \(header.format): \(tag)"
                    )
                }
            }
        }
    }

    func testPublicBaseAccessorsReadValidDWARF5RootAttributes() throws {
        let cases: [(
            unitType: DWARFUnitType,
            rootTag: DWARFTag,
            attribute: DWARFAttribute,
            value: UInt64
        )] = [
            (.partial, .partial_unit, .addr_base, 0x1234),
            (.skeleton, .skeleton_unit, .addr_base, 0x2345),
            (.type, .type_unit, .str_offsets_base, 0x3456)
        ]

        for testCase in cases {
            for header in version5Headers(unitType: testCase.unitType) {
                try UnitTypeBinaryFixture.withUnits(
                    header: header,
                    rootTag: testCase.rootTag,
                    rootAttributes: [(testCase.attribute, testCase.value)]
                ) { machO, machOUnit, elf, elfUnit in
                    switch testCase.attribute {
                    case .addr_base:
                        XCTAssertEqual(machOUnit.addressesBase(in: machO), testCase.value)
                        XCTAssertEqual(elfUnit.addressesBase(in: elf), testCase.value)
                    case .str_offsets_base:
                        XCTAssertEqual(machOUnit.stringOffsetsBase(in: machO), testCase.value)
                        XCTAssertEqual(elfUnit.stringOffsetsBase(in: elf), testCase.value)
                    default:
                        XCTFail("Unexpected fixture attribute: \(testCase.attribute)")
                    }
                }
            }
        }
    }

    func testPublicBaseAccessorsRejectMismatchedDWARF5RootTag() throws {
        for header in version5Headers(unitType: .skeleton) {
            try UnitTypeBinaryFixture.withUnits(
                header: header,
                rootTag: .compile_unit,
                rootAttributes: [(.addr_base, 0x1234)]
            ) { machO, machOUnit, elf, elfUnit in
                XCTAssertNil(machOUnit.addressesBase(in: machO))
                XCTAssertNil(elfUnit.addressesBase(in: elf))
            }
        }
    }
}

// MARK: - Header Fixtures

extension DWARFUnitRootTests {
    private func legacyHeaders(version: DWARFVersion) -> [DWARFCompilationUnitHeader] {
        var layout32 = dwarf4_cu_header32_t()
        layout32.version = version.rawValue
        var layout64 = dwarf4_cu_header64_t()
        layout64.version = version.rawValue
        layout64.unit_length._pad = UInt32.max

        return [
            .upToVersion4_32(.init(layout: layout32, offset: 0)),
            .upToVersion4(.init(layout: layout64, offset: 0))
        ]
    }

    private func version5Headers(unitType: DWARFUnitType) -> [DWARFCompilationUnitHeader] {
        switch unitType {
        case .compile, .partial:
            var layout32 = dwarf5_cu_header32_t()
            layout32.version = 5
            layout32.unit_type = unitType.rawValue
            var layout64 = dwarf5_cu_header64_t()
            layout64.version = 5
            layout64.unit_type = unitType.rawValue
            layout64.unit_length._pad = UInt32.max
            return [
                .version5_32(.init(layout: layout32, offset: 0)),
                .version5(.init(layout: layout64, offset: 0))
            ]
        case .skeleton, .split_compile:
            var layout32 = dwarf5_split_cu_header32_t()
            layout32.version = 5
            layout32.unit_type = unitType.rawValue
            var layout64 = dwarf5_split_cu_header64_t()
            layout64.version = 5
            layout64.unit_type = unitType.rawValue
            layout64.unit_length._pad = UInt32.max
            return [
                .version5Split_32(.init(layout: layout32, offset: 0)),
                .version5Split(.init(layout: layout64, offset: 0))
            ]
        case .type, .split_type:
            var layout32 = dwarf5_tu_header32_t()
            layout32.version = 5
            layout32.unit_type = unitType.rawValue
            var layout64 = dwarf5_tu_header64_t()
            layout64.version = 5
            layout64.unit_type = unitType.rawValue
            layout64.unit_length._pad = UInt32.max
            return [
                .version5Type_32(.init(layout: layout32, offset: 0)),
                .version5Type(.init(layout: layout64, offset: 0))
            ]
        }
    }
}
