import Foundation
import XCTest
@testable import DWARF

final class DWARFNameIndexTests: XCTestCase {
    func testDWARF32LayoutUsesEightByteForeignTypeUnitSignatures() {
        let layout = DWARFNameIndexLayout(
            format: ._32bit,
            compilationUnitCount: 1,
            localTypeUnitCount: 1,
            foreignTypeUnitCount: 2,
            bucketCount: 4,
            nameCount: 5,
            abbreviationsTableSize: 7
        )

        XCTAssertEqual(layout.localTypeUnitOffsetsOffset, 4)
        XCTAssertEqual(layout.foreignTypeUnitSignaturesOffset, 8)
        XCTAssertEqual(layout.bucketsOffset, 24)
        XCTAssertEqual(layout.hashesOffset, 40)
        XCTAssertEqual(layout.stringOffsetsOffset, 60)
        XCTAssertEqual(layout.entryOffsetsOffset, 80)
        XCTAssertEqual(layout.abbreviationsOffset, 100)
        XCTAssertEqual(layout.entriesOffset, 107)
    }

    func testDWARF64LayoutUsesEightByteEntriesThroughoutUnitLists() {
        let layout = DWARFNameIndexLayout(
            format: ._64bit,
            compilationUnitCount: 1,
            localTypeUnitCount: 1,
            foreignTypeUnitCount: 2,
            bucketCount: 4,
            nameCount: 5,
            abbreviationsTableSize: 7
        )

        XCTAssertEqual(layout.localTypeUnitOffsetsOffset, 8)
        XCTAssertEqual(layout.foreignTypeUnitSignaturesOffset, 16)
        XCTAssertEqual(layout.bucketsOffset, 32)
        XCTAssertEqual(layout.hashesOffset, 48)
        XCTAssertEqual(layout.stringOffsetsOffset, 68)
        XCTAssertEqual(layout.entryOffsetsOffset, 108)
        XCTAssertEqual(layout.abbreviationsOffset, 148)
        XCTAssertEqual(layout.entriesOffset, 155)
    }

    func testBucketRangesPreserveOneBasedIndicesAndSkipEmptyBuckets() {
        let table = makeHashTable(
            buckets: [1, 0, 3, 5],
            hashes: [10, 20, 30, 40, 50]
        )

        XCTAssertEqual(
            table.bucketRanges,
            [1 ..< 3, 0 ..< 0, 3 ..< 5, 5 ..< 6]
        )
    }

    func testSearchSkipsEmptyBucketWhenFindingRangeEnd() {
        let empty = makeHashTable(buckets: [], hashes: [])
        let cHash = empty.hash(for: "c")
        let bHash = empty.hash(for: "b")
        let table = makeHashTable(
            buckets: [1, 0, 0, 3],
            hashes: [cHash, 0, bHash]
        )

        XCTAssertEqual(table.searchCandidateIndices(for: "c"), [1])
        XCTAssertEqual(table.searchCandidateIndices(for: "b"), [3])
    }

    func testSearchReturnsNoCandidatesForEmptyOrMissingHashTable() {
        let table = makeHashTable(
            buckets: [1, 0, 0, 3],
            hashes: [1, 2, 3]
        )

        XCTAssertTrue(table.searchCandidateIndices(for: "foo").isEmpty)
        XCTAssertTrue(
            makeHashTable(buckets: [], hashes: [])
                .searchCandidateIndices(for: "foo")
                .isEmpty
        )
    }

    func testMalformedBucketRangeDoesNotIndexPastHashes() {
        let table = makeHashTable(
            buckets: [4],
            hashes: [1, 2, 3]
        )

        XCTAssertEqual(table.bucketRanges, [0 ..< 0])
        XCTAssertTrue(table.searchCandidateIndices(for: "foo").isEmpty)
    }
}

private func makeHashTable(
    buckets: [UInt32],
    hashes: [UInt32]
) -> DWARFNameIndexHashTable {
    let bucketsData = buckets.withUnsafeBytes { Data($0) }
    let hashesData = hashes.withUnsafeBytes { Data($0) }
    let bucketsSequence: DataSequence<UInt32> = .init(
        data: bucketsData,
        numberOfElements: buckets.count
    )
    let hashesSequence: DataSequence<UInt32> = .init(
        data: hashesData,
        numberOfElements: hashes.count
    )
    return .init(
        buckets: bucketsSequence,
        hashes: hashesSequence
    )
}
