import Foundation
import XCTest
@_spi(Support) import MachOKit
import ELFKit
@testable import DWARF
import DWARFMachO
import DWARFELF

/// Minimal object files containing one unit and an optional abbreviation set.
enum UnitTypeBinaryFixture {
    private static let infoOffset = 0x200
    private static let abbrevOffset = 0x300

    static func withUnits(
        header: DWARFCompilationUnitHeader,
        rootTag: DWARFTag?,
        body: (MachOFile, DWARFCompilationUnit, ELFFile, DWARFCompilationUnit) throws -> Void
    ) throws {
        var info = headerData(header)
        info.append(rootTag == .null || rootTag == nil ? 0 : 1)
        if header.format == ._32bit {
            info.replaceSubrange(0 ..< 4, with: bytes(UInt32(info.count - 4)))
        } else {
            info.replaceSubrange(4 ..< 12, with: bytes(UInt64(info.count - 12)))
        }

        // Abbreviation 1: selected tag, no children, no attributes. All tags
        // used here fit in one ULEB128 byte. A final zero terminates the set.
        let abbrev = rootTag.map { Data([1, UInt8($0.rawValue), 0, 0, 0, 0]) }
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let machOURL = directory.appendingPathComponent("unit.macho")
        let elfURL = directory.appendingPathComponent("unit.elf")
        try machOData(info: info, abbrev: abbrev).write(to: machOURL)
        try elfData(info: info, abbrev: abbrev).write(to: elfURL)

        let machO = try MachOFile(url: machOURL)
        let elf = try ELFFile(url: elfURL)
        let machOUnit = try XCTUnwrap(machO.dwarf.compilationUnits.first)
        let elfUnit = try XCTUnwrap(elf.dwarf.compilationUnits.first)
        try body(machO, machOUnit, elf, elfUnit)
    }

    // MARK: - Object File Containers

    private static func machOData(info: Data, abbrev: Data?) -> Data {
        var header = mach_header_64()
        header.magic = MH_MAGIC_64
        header.cputype = CPU_TYPE_ARM64
        header.cpusubtype = CPU_SUBTYPE_ARM64_ALL
        header.filetype = numericCast(MH_OBJECT)
        header.ncmds = 1

        var segment = segment_command_64()
        segment.cmd = numericCast(LC_SEGMENT_64)
        segment.nsects = abbrev == nil ? 1 : 2
        segment.cmdsize = numericCast(
            MemoryLayout<segment_command_64>.size
                + Int(segment.nsects) * MemoryLayout<section_64>.size
        )
        withUnsafeMutableBytes(of: &segment.segname) {
            $0.copyBytes(from: "__DWARF".utf8)
        }
        header.sizeofcmds = segment.cmdsize
        segment.fileoff = numericCast(infoOffset)
        let contentEnd = abbrev.map { abbrevOffset + $0.count } ?? (infoOffset + info.count)
        segment.filesize = numericCast(contentEnd - infoOffset)
        segment.vmsize = segment.filesize

        var data = bytes(header)
        data.append(bytes(segment))
        for (name, offset, contents) in sections(info: info, abbrev: abbrev) {
            var section = section_64()
            withUnsafeMutableBytes(of: &section.segname) {
                $0.copyBytes(from: "__DWARF".utf8)
            }
            withUnsafeMutableBytes(of: &section.sectname) {
                $0.copyBytes(from: ("__" + name.dropFirst()).utf8)
            }
            section.offset = numericCast(offset)
            section.size = numericCast(contents.count)
            data.append(bytes(section))
        }
        appendSections(to: &data, info: info, abbrev: abbrev)
        return data
    }

    private static func elfData(info: Data, abbrev: Data?) -> Data {
        let names = Data("\0.shstrtab\0.debug_info\0.debug_abbrev\0".utf8)
        let namesOffset = 0x180
        var header = ELF64Header.Layout()
        header.e_ident = (0x7f, 0x45, 0x4c, 0x46, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        header.e_type = 1 // ET_REL
        header.e_machine = 183 // EM_AARCH64
        header.e_version = 1
        header.e_ehsize = numericCast(MemoryLayout<ELF64Header.Layout>.size)
        header.e_shoff = numericCast(header.e_ehsize)
        header.e_shentsize = numericCast(MemoryLayout<ELF64SectionHeader.Layout>.size)
        header.e_shnum = abbrev == nil ? 3 : 4
        header.e_shstrndx = 1

        var data = bytes(header)
        data.append(bytes(ELF64SectionHeader.Layout())) // Null section.
        let entries = [(".shstrtab", namesOffset, names)] + sections(info: info, abbrev: abbrev)
        for (name, offset, contents) in entries {
            var section = ELF64SectionHeader.Layout()
            section.sh_name = numericCast(names.range(of: Data(name.utf8))!.lowerBound)
            section.sh_type = name == ".shstrtab" ? 3 : 1 // SHT_STRTAB / SHT_PROGBITS
            section.sh_offset = numericCast(offset)
            section.sh_size = numericCast(contents.count)
            section.sh_addralign = 1
            data.append(bytes(section))
        }
        data.append(Data(repeating: 0, count: namesOffset - data.count))
        data.append(names)
        appendSections(to: &data, info: info, abbrev: abbrev)
        return data
    }

    // MARK: - DWARF Contributions

    private static func sections(info: Data, abbrev: Data?) -> [(String, Int, Data)] {
        var sections = [(".debug_info", infoOffset, info)]
        if let abbrev { sections.append((".debug_abbrev", abbrevOffset, abbrev)) }
        return sections
    }

    private static func appendSections(to data: inout Data, info: Data, abbrev: Data?) {
        for (_, offset, contents) in sections(info: info, abbrev: abbrev) {
            data.append(Data(repeating: 0, count: offset - data.count))
            data.append(contents)
        }
    }

    private static func headerData(_ header: DWARFCompilationUnitHeader) -> Data {
        switch header {
        case .upToVersion4(let header): bytes(header.layout)
        case .upToVersion4_32(let header): bytes(header.layout)
        case .version5(let header): bytes(header.layout)
        case .version5_32(let header): bytes(header.layout)
        case .version5Split(let header): bytes(header.layout)
        case .version5Split_32(let header): bytes(header.layout)
        case .version5Type(let header): bytes(header.layout)
        case .version5Type_32(let header): bytes(header.layout)
        }
    }

    private static func bytes<T>(_ value: T) -> Data {
        withUnsafeBytes(of: value) { Data($0) }
    }
}
