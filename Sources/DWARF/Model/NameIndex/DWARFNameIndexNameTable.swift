//
//  DWARFNameIndexNameTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/21
//  
//

import Foundation

public struct DWARFNameIndexNameTable {
    public let stringOffsets: AnyRandomAccessCollection<Int>
    public let entryOffsets: AnyRandomAccessCollection<Int>
}

extension DWARFNameIndexNameTable {
    package func _strings(
        in binary: some _DWARFBinary
    ) -> [String]? {
        guard let strings = binary.dwarf.strings else { return nil }
        return stringOffsets.map {
            strings.string(at: $0)?.string ?? ""
        }
    }
}
