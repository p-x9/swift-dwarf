//
//  SegmentCommandProtocol+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/29
//  
//

import MachOKit

extension SegmentCommandProtocol {
    func __debug_abbrev(in machO: MachOFile) -> SectionType? {
        section(for: .__debug_abbrev, in: machO)
    }

    func __debug_info(in machO: MachOFile) -> SectionType? {
        section(for: .__debug_info, in: machO)
    }

    func __debug_line(in machO: MachOFile) -> SectionType? {
        section(for: .__debug_line, in: machO)
    }

    func __debug_str(in machO: MachOFile) -> SectionType? {
        section(for: .__debug_str, in: machO)
    }

    func __debug_line_str(in machO: MachOFile) -> SectionType? {
        section(for: .__debug_line_str, in: machO)
    }

    func __debug_str_offs(in machO: MachOFile) -> SectionType? {
        section(for: .__debug_str_offs, in: machO)
    }

    func __debug_addr(in machO: MachOFile) -> SectionType? {
        section(for: .__debug_addr, in: machO)
    }

    func __debug_rnglists(in machO: MachOFile) -> SectionType? {
        section(for: .__debug_rnglists, in: machO)
    }

    func __debug_loclists(in machO: MachOFile) -> SectionType? {
        section(for: .__debug_loclists, in: machO)
    }

    func __debug_aranges(in machO: MachOFile) -> SectionType? {
        section(for: .__debug_aranges, in: machO)
    }
}

extension SegmentCommandProtocol {
    @inline(__always)
    func section(
        for section: DWARFMachOSection,
        in machO: MachOFile
    ) -> SectionType? {
        _section(for: section.rawValue, in: machO)
    }

    @inline(__always)
    func section(
        for section: DWARFMachOSection,
        in machO: MachOImage
    ) -> SectionType? {
        _section(for: section.rawValue, in: machO)
    }
}

extension SegmentCommandProtocol {
    @inline(__always)
    func _section(for name: String, in machO: MachOFile) -> SectionType? {
        sections(in: machO).first(
            where: {
                $0.sectionName == name
            }
        )
    }

    @inline(__always)
    func _section(for name: String, in machO: MachOImage) -> SectionType? {
        sections(cmdsStart: machO.cmdsStartPtr).first(
            where: {
                $0.sectionName == name
            }
        )
    }
}
