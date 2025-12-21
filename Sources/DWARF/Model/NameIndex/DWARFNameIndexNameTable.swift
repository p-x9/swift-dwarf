//
//  DWARFNameIndexNameTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/21
//  
//

import Foundation
import MachOKit

public struct DWARFNameIndexNameTable {
    public let stringOffsets: AnyRandomAccessCollection<Int>
    public let entryOffsets: AnyRandomAccessCollection<Int>
}

extension DWARFNameIndexNameTable {
    public func strings(
        in machO: MachOFile
    ) -> [String]? {
        guard let strings = machO.dwarf.strings else { return nil }
        return stringOffsets.map {
            strings.string(at: $0)?.string ?? ""
        }
    }
}
