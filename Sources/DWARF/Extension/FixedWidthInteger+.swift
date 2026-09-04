//
//  FixedWidthInteger+.swift
//  MachOKit
//
//  Created by p-x9 on 2024/11/20
//
//

import Foundation

extension FixedWidthInteger {
    /// Decodes an integer in the specified byte order.
    ///
    /// Signed types interpret the input as two's complement and sign-extend
    /// shorter inputs. Unsigned types zero-extend them. Empty inputs and inputs
    /// wider than the destination type return nil; bytes are never truncated.
    init?<Bytes: Collection>(
        bytes: Bytes,
        endian: Endian
    ) where Bytes.Element == UInt8 {
        let byteCount = bytes.count
        guard byteCount > 0, byteCount <= Self.bitWidth / 8 else { return nil }

        var value: Self = 0
        var mostSignificantByte: UInt8 = 0
        for (index, byte) in bytes.enumerated() {
            let shift = endian == .little
                ? index * 8
                : (byteCount - 1 - index) * 8
            if shift == (byteCount - 1) * 8 {
                mostSignificantByte = byte
            }
            value |= Self(truncatingIfNeeded: byte) << shift
        }
        if Self.isSigned, byteCount < Self.bitWidth / 8,
           mostSignificantByte & 0x80 != 0 {
            value |= ~Self.zero << (byteCount * 8)
        }
        self = value
    }
}

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

extension FixedWidthInteger {
    @inline(__always)
    func alignedUp(to alignment: Self) -> Self {
        precondition(alignment > 0 && (alignment & (alignment &- 1)) == 0, "alignment must be a power of two")
        return (self &+ alignment &- 1) & ~(alignment &- 1)
    }
}
