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
        var ranges: [Range<Int>] = []
        for (i, bucket) in buckets.enumerated() {
            let start = Int(bucket)

            // empty
            if start == 0 {
                if let last = ranges.last {
                    ranges.append(
                        last.upperBound..<last.upperBound + 1
                    )
                } else {
                    ranges.append(0..<1)
                }
                continue
            }

            var end: Int = 0
            var offset = 1
            while end == 0 {
                if i + offset < buckets.count {
                    end = Int(buckets[i + offset])
                    offset += 1
                } else {
                    end = hashes.count + 1
                }
            }
            ranges.append(start ..< end)
        }
        return ranges
    }
}

extension DWARFNameIndexHashTable {
    public func searchCandidateIndices(
        for name: String
    ) -> [Int] {
        let hash = hash(for: name)
        let bucketIndex = Int(hash % numericCast(buckets.count))

        let start = Int(buckets[bucketIndex])
        let end = if bucketIndex + 1 < buckets.count {
            Int(buckets[bucketIndex + 1])
        } else { hashes.count - 1 }

        return zip(
            start ..< end,
            hashes[start ..< end]
        )
        .filter { $0.1 == hash }
        .map { Int($0.0) }
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
