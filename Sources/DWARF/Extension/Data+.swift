//
//  Data+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/09/13
//  
//

import Foundation

extension Data {
    func uintValue<T: FixedWidthInteger>(
        endian: Endian = .little
    ) -> T {
        T(bytes: self, endian: endian)
    }
}
