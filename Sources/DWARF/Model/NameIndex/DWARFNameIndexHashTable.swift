//
//  DWARFNameIndexHashTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/21
//  
//

import Foundation

public struct DWARFNameIndexHashTable {
    public let buckets: DataSequence<UInt32>
    public let hashes: DataSequence<UInt32>
}

extension DWARFNameIndexHashTable {
    public var bucketRanges: [Range<Int>] {
        buckets.indices.map { bucketRange(at: $0) ?? 0 ..< 0 }
    }
}

extension DWARFNameIndexHashTable {
    public func searchCandidateIndices(
        for name: String
    ) -> [Int] {
        guard !buckets.isEmpty else { return [] }

        let hash = hash(for: name)
        let bucketIndex = Int(hash % numericCast(buckets.count))
        guard let range = bucketRange(at: bucketIndex) else { return [] }

        return range.filter { hashes[$0 - 1] == hash }
    }
}

extension DWARFNameIndexHashTable {
    private func bucketRange(at bucketIndex: Int) -> Range<Int>? {
        let rawStart = Int(buckets[bucketIndex])
        guard rawStart != 0 else { return 0 ..< 0 }

        // Keep the indices in the DWARF-defined 1-based domain. Convert them
        // only when accessing a 0-based Swift collection.
        let start = rawStart
        let rawEnd = buckets[(bucketIndex + 1)...]
            .first(where: { $0 != 0 })
            .map(Int.init)
        let end = rawEnd ?? hashes.count + 1

        guard start >= 1,
              start < end,
              end <= hashes.count + 1 else {
            return nil
        }
        return start ..< end
    }
}

extension DWARFNameIndexHashTable {
    // ref: DWARF5 p268 (Page 250) 7.33 Name Table Hash Function
    public func hash(for name: String) -> UInt32 {
        let name = name
            .replacingOccurrences(of: "\u{0130}", with: "i")
            .replacingOccurrences(of: "\u{0131}", with: "i")
            .folding(
                options: [.caseInsensitive],
                locale: nil
            )
        var h: UInt32 = 5381
        for c in name.utf8 {
            h = h &* 33 &+ UInt32(c)
        }
        return h
    }
}
