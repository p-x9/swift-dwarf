//
//  DWARFLocation.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/01
//  
//

public struct DWARFLocation {
    public let range: DWARFRange
    public let descriptions: [DWARFOperation]
}

extension DWARFLocation {
    public var isDefault: Bool {
        range == .init(
            start: .init(address: 0),
            end: .init(address: 0)
        )
    }
}
