//
//  FixedWidthInteger+.swift
//  MachOKit
//
//  Created by p-x9 on 2024/11/20
//
//

import Foundation

extension FixedWidthInteger {
    var uleb128Size: Int {
        var value = self
        var result = 0

        repeat {
            value = value >> 7
            result += 1
        } while value != 0

        return result
    }
}

extension FixedWidthInteger where Self: SignedInteger {
    var sleb128Size: Int {
        var value = self
        var result = 0
        var more = true

        while more {
            let byte = UInt8(truncatingIfNeeded: value) & 0x7F
            let signBit = (byte & 0x40) != 0

            value >>= 7
            result += 1

            if (value == 0 && !signBit) || (value == -1 && signBit) {
                more = false
            }
        }

        return result
    }
}
