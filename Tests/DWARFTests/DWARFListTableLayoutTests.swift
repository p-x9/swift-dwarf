import XCTest
@testable import DWARF

final class DWARFListTableLayoutTests: XCTestCase {
    func testConvertsContributionOffsetToEntryOffset() throws {
        for format: DWARFFormat in [._32bit, ._64bit] {
            let headerSize = format == ._32bit ? 12 : 20
            let width = format == ._32bit ? 4 : 8
            for count in [0, 2] {
                let listStart = headerSize + count * width
                let layout = DWARFListTableLayout(
                    contributionSize: listStart + 3, headerSize: headerSize,
                    offsetEntryCount: count, format: format
                )
                XCTAssertEqual(try layout.entryOffset(at: listStart), count * width)
                XCTAssertEqual(try layout.entryOffset(at: listStart + 2), count * width + 2)
                for offset in [-1, 0, listStart - 1, listStart + 3] {
                    XCTAssertThrowsError(try layout.entryOffset(at: offset))
                }
            }
        }
    }

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
