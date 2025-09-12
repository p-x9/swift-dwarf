//
//  DataChunks.swift
//  swift-edf
//
//  Created by p-x9 on 2025/02/09
//
//

import Foundation

public struct DataChunks: Sequence, IteratorProtocol {
    public let data: Data
    public let chunkSize: Int

    private var offset: Int = 0

    init(data: Data, chunkSize: Int) {
        self.data = data
        self.chunkSize = chunkSize
    }

    public mutating func next() -> Data? {
        guard offset < data.count else { return nil }

        let end = Swift.min(offset + chunkSize, data.count)
        let chunk = data[offset..<end]
        offset = end
        return Data(chunk)
    }
}

extension DataChunks: Collection {
    public typealias Index = Int

    public var startIndex: Index { 0 }
    public var endIndex: Index { data.count / chunkSize }

    public func index(after i: Int) -> Int {
        i + 1
    }

    public subscript(position: Int) -> Element {
        precondition(position >= 0)
        precondition(position < endIndex)
        precondition(data.count >= (position + 1) * chunkSize)

        let offset = chunkSize * position
        let end = Swift.min(offset + chunkSize, data.count)
        let chunk = data[offset..<end]

        return Data(chunk)
    }
}

extension DataChunks: RandomAccessCollection {}
