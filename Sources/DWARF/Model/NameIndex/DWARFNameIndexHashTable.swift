//
//  DWARFNameIndexHashTable.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/21
//  
//

import Foundation
import MachOKit

public struct DWARFNameIndexHashTable {
    public let buckets: DataSequence<UInt32>
    public let hashes: DataSequence<UInt32>
}
