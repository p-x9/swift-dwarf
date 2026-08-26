import XCTest
@testable import DWARF
import DWARFC

final class DWARFUnitRootTests: XCTestCase {
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
