import XCTest
@testable import DWARF
@testable import DWARFELF
@testable import DWARFMachO

final class DWARFSectionKindTests: XCTestCase {
    func testStringOffsetsSectionNamesMatchObjectFileConventions() {
        XCTAssertEqual(
            DWARFSectionKind.debug_str_offsets.elfName,
            ".debug_str_offsets"
        )
        XCTAssertEqual(
            DWARFSectionKind.debug_str_offsets.machOName,
            "__debug_str_offs"
        )
    }

    func testOtherSectionNamesRetainTheirPrefixes() {
        XCTAssertEqual(DWARFSectionKind.debug_info.elfName, ".debug_info")
        XCTAssertEqual(DWARFSectionKind.debug_info.machOName, "__debug_info")
    }
}
