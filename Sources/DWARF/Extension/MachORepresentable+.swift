//
//  MachORepresentable+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/29
//  
//

import Foundation
import MachOKit

extension MachORepresentable {
    var dwarfSegment: (any SegmentCommandProtocol)? {
        segments.first(where: {
            $0.segmentName == "__DWARF"
        })
    }
}
