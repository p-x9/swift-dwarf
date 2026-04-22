//
//  dump.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/29
//
//

import Foundation
import DWARF
import MachOKit

func dump(_ abbrevsSet: DWARFAbbreviationsSet) {
    print("Abbrev table for offset: 0x\(String(abbrevsSet.offset, radix: 16))")
    for abbrev in abbrevsSet.abbreviations {
        print("[\(abbrev.code)]", abbrev.tag, abbrev.hasChildren ? "DW_CHILDREN_yes" : "DW_CHILDREN_no")
        for attr in abbrev.attributes {
            print("    \(attr.0) \(attr.1)")
        }
        print("")
    }
}

func dump<Binary: _DWARFBinary>(
    _ entry: DWARFDebugInfoEntry,
    for unit: DWARFCompilationUnit,
    in binary: Binary,
    baseOffset: Int,
    nest: Int
) {
    print(
        String(format: "0x%08x", entry.offset - baseOffset) + ":",
        String(repeating: " ", count: nest),
        entry.tag
    )
    for attribute in entry.attributes {
        dump(attribute, for: unit, in: binary, nest: nest)
    }
}

func dump<Binary: _DWARFBinary>(
    _ attribute: (attribute: DWARFAttribute, value: DWARFAttributeValue),
    for unit: DWARFCompilationUnit,
    in binary: Binary,
    nest: Int
) {
    let dwarf = binary.dwarf
    let (attribute, _value) = attribute

    let format = _value.format
    let value = if let value = _value._value(
        for: unit,
        in: binary
    ) {
        "\(value)"
    } else { "\(_value)" }

    let space = "              " + String(repeating: " ", count: nest)

    if attribute == .decl_file {
        print(space + "\(attribute): \(value) (\(format))", terminator: ", ")
        print(space + Array(dwarf.lineStrings!)[Int(value)!].string)
    } else {
        print(space + "\(attribute): \(value) (\(format))")
    }
}

func dump<Binary: _DWARFBinary>(
    _ entry: DWARFNameIndexEntry,
    in binary: Binary,
    baseOffset: Int
) {
    print(
        "    Entry @ " + String(format: "0x%08x", entry.offset - baseOffset) + " {"
    )
    print("      Abbrev: 0x\(String(entry.abbreviationCode, radix: 16))")
    print("      Tag: \(entry.tag)")
    for attribute in entry.attributes {
        dump(attribute, in: binary)
    }
    print("    }")
}

func dump<Binary: _DWARFBinary>(
    _ attribute: (attribute: DWARFNameIndexAttribute, value: DWARFAttributeValue),
    in binary: Binary
) {
    let (attribute, _value) = attribute

    let format = _value.format
    let value = if let value = _value.constantUIntValue {
        "\(value)"
    } else { "\(_value)" }

    print("        \(attribute): \(value) (\(format))")
}

func dump<Binary: _DWARFBinary>(
    _ header: DWARFLineHeader,
    in binary: Binary
) {
    print(
        """
            total_length: 0x\(String(format: "%08x", header.length))
                  format: \(header.format)
                 version: \(header.version)
         prologue_length: 0x\(String(format: "%08x", header.length - header.layoutSize))
         min_inst_length: \(header.minimumInstructionLength)
        max_ops_per_inst: \(header.maximumOperationsPerInstruction)
         default_is_stmt: \(header.defaultOfIsStmt)
               line_base: \(header.lineBase)
              line_range: \(header.lineRange)
             opcode_base: \(header.opecodeBase)
        """
    )

    let opcodes = DWARFLineStandardOpcode.allCases
    let opcodeLengths = header.standardOpcodeLengths
    for i in 0 ..< Int(header.opecodeBase - 1) {
        let opcode = opcodes[i]
        print("standard_opcode_lengths[\(opcode)] = \(opcodeLengths[i])")
    }

    if let directories = header.dwarf5Directories {
        print("Directories:")
        for dir in directories {
            for content in dir.contents {
                print(
                    "",
                    content.type,
                    content.value.__value(
                        for: nil,
                        in: binary
                    ) ?? ""
                )
            }
        }
    }
    if let directories = header.dwarf4Directories {
        print("Directories:")
        for dir in directories {
            print(dir)
        }
    }

    if let files = header.dwarf5Files {
        print("Files:")
        for (i, file_name) in files.enumerated() {
            print("file_names[  \(i)]:")
            for content in file_name.contents {
                print(
                    "    ",
                    content.type,
                    content.value.__value(
                        for: nil,
                        in: binary
                    ) ?? ""
                )
            }
        }
    }

    if let files = header.dwarf4Files {
        print("Directories:")
        for (i, file) in files.enumerated() {
            print(
                """
                file_names[  \(i)]:
                           name: "\(file.name)"
                      dir_index: \(file.dir_index)
                       mod_time: 0x\(String(file.modification_time, radix: 16))
                         length: 0x\(String(file.file_size, radix: 16))
                """
            )
        }
    }
}

func dump(_ strings: MachOFile.Strings) {
    for string in strings {
        print("0x" + String(format: "%08X", string.offset) + ":", string.string)
    }
}

extension DWARFLine: CustomStringConvertible {
    public var description: String {
        var entries = [
            String(format: "0x%016x", layout.address),
            String(format: "%6d", layout.line),
            String(format: "%6d", layout.column),
            String(format: "%6d", layout.file),
            String(format: "%3d", layout.isa),
            String(format: "%13d", layout.discriminator),
            String(format: "%7d", layout.op_index),
        ]

        var flags: [String] = []
        if layout.is_stmt {
            flags.append("is_stmt")
        }
        if layout.basic_block {
            flags.append("basic_block")
        }
        if layout.end_sequence {
            flags.append("end_sequence")
        }
        if layout.prologue_end {
            flags.append("prologue_end")
        }
        if layout.epilogue_begin {
            flags.append("epilogue_begin")
        }

        entries.append(" " + flags.joined(separator: " "))

        return entries.joined(separator: " ")
    }
}
