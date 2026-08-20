import XCTest
@testable import DWARF

final class DWARFListTableLayoutTests: XCTestCase {
    func testDWARF32UsesFourByteOffsetEntries() throws {
        let layout = DWARFListTableLayout(
            contributionSize: 25,
            headerSize: 12,
            offsetEntryCount: 2,
            format: ._32bit
        )

        XCTAssertEqual(try layout.offsetTableRange, 12 ..< 20)
        XCTAssertEqual(try layout.operationsRange(entryOffset: nil), 20 ..< 25)
        XCTAssertEqual(try layout.operationsRange(entryOffset: 10), 22 ..< 25)
    }

    func testDWARF64UsesEightByteOffsetEntries() throws {
        let layout = DWARFListTableLayout(
            contributionSize: 41,
            headerSize: 20,
            offsetEntryCount: 2,
            format: ._64bit
        )

        XCTAssertEqual(try layout.offsetTableRange, 20 ..< 36)
        XCTAssertEqual(try layout.operationsRange(entryOffset: nil), 36 ..< 41)
        XCTAssertEqual(try layout.operationsRange(entryOffset: 18), 38 ..< 41)
    }

    func testRejectsOffsetIntoOffsetTable() throws {
        let layout = DWARFListTableLayout(
            contributionSize: 25,
            headerSize: 12,
            offsetEntryCount: 2,
            format: ._32bit
        )

        XCTAssertThrowsError(try layout.operationsRange(entryOffset: 7))
    }

    func testRejectsOffsetPastContributionEnd() throws {
        let layout = DWARFListTableLayout(
            contributionSize: 25,
            headerSize: 12,
            offsetEntryCount: 2,
            format: ._32bit
        )

        XCTAssertThrowsError(try layout.operationsRange(entryOffset: 14))
    }

    func testRejectsOffsetTablePastContributionEnd() {
        let layout = DWARFListTableLayout(
            contributionSize: 19,
            headerSize: 12,
            offsetEntryCount: 2,
            format: ._32bit
        )

        XCTAssertThrowsError(try layout.offsetTableRange)
    }
}
