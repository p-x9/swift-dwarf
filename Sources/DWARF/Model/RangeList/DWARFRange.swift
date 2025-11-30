//
//  DWARFRange.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/30
//  
//

import Foundation

public struct DWARFRange: Sendable, Equatable {
    public let start: DWARFAddress
    public let end: DWARFAddress
}
