//
//  Data+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/13
//  
//

import Foundation

extension Data {
    /// Decodes a signed (two's complement) or unsigned integer.
    /// Short inputs are sign- or zero-extended according to T; empty or
    /// oversized inputs return nil. See FixedWidthInteger.init(bytes:endian:).
    func integerValue<T: FixedWidthInteger>(
        endian: Endian
    ) -> T? {
        T(bytes: self, endian: endian)
    }
}
