//
//  DWARFListResolutionContext.swift
//  swift-dwarf
//

/// Unit context shared by DWARF5 range and location list resolution.
internal struct DWARFListResolutionContext<Binary: _DWARFBinary> {
    private let unit: DWARFCompilationUnit
    private let binary: Binary
    private var addresses: [DWARFAddress]?

    init(unit: DWARFCompilationUnit, binary: Binary) {
        self.unit = unit
        self.binary = binary
    }

    var initialBaseAddress: DWARFAddress? {
        unit._lowPC(in: binary)
    }

    mutating func address(at index: UInt64) -> DWARFAddress? {
        if addresses == nil {
            guard let table = unit._addresses(in: binary) else { return nil }
            addresses = Array(table._addresses(in: binary))
        }
        guard let index = Int(exactly: index),
              let addresses, addresses.indices.contains(index) else { return nil }
        return addresses[index]
    }
}
