//
//  DWARFAttributeValue.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/05
//
//

extension DWARFAttributeValue {
    public static func load(
        at offset: Int,
        from elf: ELFFile,
        as format: DWARFAttributeFormat,
        dwarfFormat: DWARFFormat,
        addressSize: Int
    ) -> Self? {
        _load(
            at: offset,
            from: elf,
            as: format,
            dwarfFormat: dwarfFormat,
            addressSize: addressSize
        )
    }
}

extension DWARFAttributeValue {
    public func value(
        for unit: DWARFCompilationUnit,
        in elf: ELFFile
    ) -> DWARFAttributeResolvedValue? {
        _value(for: unit, in: elf)
    }

    public func _value(
        for unit: DWARFCompilationUnit?,
        in elf: ELFFile?
    ) -> DWARFAttributeResolvedValue? {
        __value(for: unit, in: elf)
    }
}
