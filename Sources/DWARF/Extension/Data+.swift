//
//  Data+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/13
//  
//

import Foundation
import MachOKit

extension Data {
    func uintValue<T: FixedWidthInteger>(
        endian: Endian = .little
    ) -> T {
        precondition(
            count <= T.bitWidth / 8,
            "Invalid byte count for target type"
        )
        var value: T = 0
        for (i, byte) in self.enumerated() {
            let byte: T = numericCast(byte)
            if endian == .little {
                value |= (byte << (i * 8))
            } else {
                value |= (byte << ((count - 1 - i) * 8))
            }
        }
        return value
    }
}
