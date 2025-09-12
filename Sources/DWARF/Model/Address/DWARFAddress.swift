//
//  DWARFAddress.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/13
//  
//

import Foundation

public struct DWARFAddress {
    public let segmentSelector: UInt64?
    public let address: UInt64
}
