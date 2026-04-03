//
//  DWARFSegment.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/04
//  
//

package protocol DWARFSegment {
    associatedtype DWARFBinary = _DWARFBinary

    associatedtype DWARFSectionType: DWARFSection

    var segmentName: String { get }
    var virtualMemoryAddress: Int { get }
    var virtualMemorySize: Int { get }
    var fileOffset: Int { get }
    var fileSize: Int { get }

    func sections(in binary: DWARFBinary) -> DataSequence<DWARFSectionType>
}

extension DWARFSegment {
    @inline(__always)
    func section(
        for section: DWARFSectionKind,
        in binary: DWARFBinary
    ) -> DWARFSectionType? {
        _section(for: section.rawValue, in: binary)
    }
}

extension DWARFSegment {
    @inline(__always)
    func _section(for name: String, in binary: DWARFBinary) -> DWARFSectionType? {
        sections(in: binary).first(
            where: {
                $0.sectionName == name
            }
        )
    }
}

extension DWARFSegment {
    func debug_abbrev(in binary: DWARFBinary) -> DWARFSectionType? {
        section(for: .debug_abbrev, in: binary)
    }

    func debug_info(in binary: DWARFBinary) -> DWARFSectionType? {
        section(for: .debug_info, in: binary)
    }

    func debug_line(in binary: DWARFBinary) -> DWARFSectionType? {
        section(for: .debug_line, in: binary)
    }

    func debug_str(in binary: DWARFBinary) -> DWARFSectionType? {
        section(for: .debug_str, in: binary)
    }

    func debug_line_str(in binary: DWARFBinary) -> DWARFSectionType? {
        section(for: .debug_line_str, in: binary)
    }

    func debug_str_offs(in binary: DWARFBinary) -> DWARFSectionType? {
        section(for: .debug_str_offs, in: binary)
    }

    func debug_addr(in binary: DWARFBinary) -> DWARFSectionType? {
        section(for: .debug_addr, in: binary)
    }

    func debug_rnglists(in binary: DWARFBinary) -> DWARFSectionType? {
        section(for: .debug_rnglists, in: binary)
    }

    func debug_loclists(in binary: DWARFBinary) -> DWARFSectionType? {
        section(for: .debug_loclists, in: binary)
    }

    func debug_aranges(in binary: DWARFBinary) -> DWARFSectionType? {
        section(for: .debug_aranges, in: binary)
    }

    func debug_names(in binary: DWARFBinary) -> DWARFSectionType? {
        section(for: .debug_names, in: binary)
    }
}
