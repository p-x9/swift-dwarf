import XCTest
@testable import DWARF
import DWARFC

final class DWARFReferenceResolutionTests: XCTestCase {
    func testFindsUnitContainingReferencedDebugInfoEntry() {
        let first = makeUnit(offset: 100, length: 20, addressSize: 4)
        let second = make64BitUnit(
            offset: 124,
            length: 36,
            debugAbbrevOffset: 0x40,
            addressSize: 8
        )

        XCTAssertFalse(first._containsDebugInfoEntry(at: 100))
        XCTAssertTrue(first._containsDebugInfoEntry(at: 111))
        XCTAssertTrue(first._containsDebugInfoEntry(at: 123))
        XCTAssertFalse(first._containsDebugInfoEntry(at: 124))

        let containingUnit = DWARFCompilationUnit._containingDebugInfoEntry(
            at: 147,
            in: [first, second]
        )
        XCTAssertEqual(containingUnit?.offset, second.offset)
        XCTAssertEqual(containingUnit?.header.format, ._64bit)
        XCTAssertEqual(containingUnit?.header.debugAbbrevOffset, 0x40)
        XCTAssertEqual(containingUnit?.header.addressSize, 8)
    }

    func testRejectsOffsetInUnitHeaderOrOutsideAllUnits() {
        let unit = makeUnit(offset: 100, length: 20, addressSize: 4)

        XCTAssertNil(
            DWARFCompilationUnit._containingDebugInfoEntry(
                at: 110,
                in: [unit]
            )
        )
        XCTAssertNil(
            DWARFCompilationUnit._containingDebugInfoEntry(
                at: 124,
                in: [unit]
            )
        )
    }
}

private func makeUnit(
    offset: Int,
    length: UInt32,
    addressSize: UInt8
) -> DWARFCompilationUnit {
    var layout = dwarf4_cu_header32_t()
    layout.unit_length.value = length
    layout.version = 4
    layout.debug_abbrev_offset = 0
    layout.address_size = addressSize

    return .init(
        header: .upToVersion4_32(
            .init(layout: layout, offset: offset)
        ),
        offset: offset
    )
}

private func make64BitUnit(
    offset: Int,
    length: UInt64,
    debugAbbrevOffset: UInt64,
    addressSize: UInt8
) -> DWARFCompilationUnit {
    var layout = dwarf4_cu_header64_t()
    layout.unit_length._pad = UInt32.max
    layout.unit_length.value = length
    layout.version = 4
    layout.debug_abbrev_offset = debugAbbrevOffset
    layout.address_size = addressSize

    return .init(
        header: .upToVersion4(
            .init(layout: layout, offset: offset)
        ),
        offset: offset
    )
}
