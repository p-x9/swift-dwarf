//
//  DWARFELFPrintTests.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/12
//
//

import XCTest
@testable import DWARF
@testable import DWARFELF
import DWARFC
@_spi(Support) @testable import ELFKit

final class DWARFELFPrintTests: XCTestCase {
    private var elf: ELFFile!

    override func setUp() async throws {
        let path = ""

        let url = URL(fileURLWithPath: path)
        self.elf = try .init(url: url)
    }
}

extension DWARFELFPrintTests {
    func testDwarfSections() {
        for section in elf.sections {
            let name = section.name(in: elf)
            if let name, name.starts(with: ".debug") {
                print(name)
            }
        }
    }
}

extension DWARFELFPrintTests {
    func testStrings() {
        let dwarf = elf.dwarf
        guard let strings = dwarf.strings else { return }
        dump(strings)
    }

    func testLineStrings() {
        let dwarf = elf.dwarf
        guard let strings = dwarf.lineStrings else { return }
        dump(strings)
    }

    func testStrOffsets() {
        let dwarf = elf.dwarf
        guard let strings = dwarf.strings else { return }

        for table in dwarf.stringOffsetsTables {
            let header = table.header
            print(
                "Contribution size = \(table.layoutSize - header.format.unitLengthSize),",
                "Format = \(header.format),",
                "Version = \(header.version)"
            )

            let offsets = table.offsets(in: elf)
            for offset in offsets {
                let string = strings.string(at: numericCast(offset))?.string
                print("0x" + String(format: "%08X", offset) + ":", string ?? "")
            }
        }
    }
}

extension DWARFELFPrintTests {
    func testAddresses() {
        let dwarf = elf.dwarf
        guard let dwarfSegment = elf.dwarfSegment,
              let __debug_addr = dwarfSegment.debug_addr(in: elf) else {
            return
        }
        for list in dwarf.addresses {
            let header = list.header
            print("------")
            print(
                "Address table header:",
                "length = 0x\(String(format: "%08x", header.length)),",
                "format = \(header.format),",
                "version = \(header.version),",
                "addr_size = \(header.addressSize),",
                "seg_size = \(header.segmentSelectorSize)"
            )
            print("__debug_addr sec_offset = 0x" + String(list.offset - __debug_addr.offset + header.layoutSize, radix: 16))

            let addresses = list.addresses(in: elf)
            print("Addrs: [")
            for address in addresses {
                print(
                    address.segmentSelector?.description ?? "none",
                    "0x" + String(format: "%016x", address.address)
                )
            }
            print("]")
        }
    }

    func testAddressRanges() {
        let dwarf = elf.dwarf
        guard let dwarfSegment = elf.dwarfSegment,
              let __debug_aranges = dwarfSegment.debug_aranges(in: elf) else {
            return
        }
        for list in dwarf.addressRanges {
            let header = list.header
            print("------")
            print(
                "Address Range table header:",
                "length = 0x\(String(format: "%08x", header.length)),",
                "format = \(header.format),",
                "version = \(header.version),",
                "addr_size = \(header.addressSize),",
                "seg_size = \(header.segmentSelectorSize)"
            )
            let ranges = list.addressRanges(in: elf)
            print("__debug_aranges sec_offset = 0x" + String(list.offset - __debug_aranges.offset + header.layoutSize, radix: 16))
            for range in ranges {
                print(
                    "[",
                    range.address.segmentSelector?.description ?? "none" + " ",
                    "0x" + String(format: "%016x", range.address.address) + ", ",
                    "0x" + String(format: "%016x", range.address.address + range.length),
                    "]",
                    separator: ""
                )
            }
        }
    }
}

extension DWARFELFPrintTests {
    func testRangeListsOperations() throws {
        let dwarf = elf.dwarf
        for list in dwarf.rangeLists {
            let header = list.header
            print("------")
            print(
                "range list header:",
                "length = 0x\(String(format: "%08x", header.length)),",
                "format = \(header.format),",
                "version = \(header.version),",
                "addr_size = \(header.addressSize),",
                "seg_size = \(header.segmentSelectorSize),",
                "offset_entry_count = \(header.offsetEntryCount)"
            )
            let operations = try list.operations(for: elf)
            for operation in operations {
                print(operation)
            }
        }
    }
}

extension DWARFELFPrintTests {
    func testLocationListsOperations() throws {
        let dwarf = elf.dwarf
        for list in dwarf.locationLists {
            let header = list.header
            print("------")
            print(
                "location list header:",
                "length = 0x\(String(format: "%08x", header.length)),",
                "format = \(header.format),",
                "version = \(header.version),",
                "addr_size = \(header.addressSize),",
                "seg_size = \(header.segmentSelectorSize),",
                "offset_entry_count = \(header.offsetEntryCount)"
            )
            let operations = try list.operations(for: elf)
            for operation in operations {
                print(operation)
            }
        }
    }
}

extension DWARFELFPrintTests {
    func testNameIndices() throws {
        let dwarf = elf.dwarf

        guard let dwarfSegment = elf.dwarfSegment,
              let __debug_names = dwarfSegment.debug_names(in: elf) else {
            return
        }

        for nameIndex in dwarf.nameIndices {
            let header = nameIndex.header
            print("------")
            print(
                """
                Header {
                  Length: 0x\(String(header.length, radix: 16))
                  Format: \(header.format)
                  Version: \(header.version)
                  CU count: \(header.numberOfCompilationUnits)
                  Local TU count: \(header.numberOfLocalTypeUnits)
                  Foreign TU count: \(header.numberOfForeignTypeUnits)
                  Bucket count: \(header.numberOfBuckets)
                  Name count: \(header.numberOfNames)
                  Abbreviations table size: 0x\(String(header.abbreviationsTableSize, radix: 16))
                  Augmentation: '\(header.augmentation(in: elf))'
                }
                """
            )

            print("Compilation Unit offsets [")
            for (i, offset) in nameIndex.compilationUnitOffsets(in: elf).enumerated() {
                print(" CU[\(i)]:", "0x" + String(format: "%08x", offset))
            }
            print("]")

            print("Local Type Unit offsets [")
            for (i, offset) in nameIndex.localTypeUnitOffsets(in: elf).enumerated() {
                print(" Local TU[\(i)]:", "0x" + String(format: "%08x", offset))
            }
            print("]")

            print("Foreign Type Unit offsets [")
            for (i, offset) in nameIndex.foreignTypeUnitOffsets(in: elf).enumerated() {
                print(" Foreign TU[\(i)]:", "0x" + String(format: "%08x", offset))
            }
            print("]")

            print("Abbreviations [")
            if let abbreviationsSets = nameIndex.abbreviationsSet(in: elf) {
                for abbrev in abbreviationsSets.abbreviations {
                    print(
                        """
                         Abbreviation 0x\(String(abbrev.code, radix: 16)) {
                           Tag: \(abbrev.tag)
                        """
                    )
                    for attribute in abbrev.attributes {
                        print("   \(attribute.0): \(attribute.1)")
                    }
                    print(" }")
                }
            }
            print("]")

            let nameTable = nameIndex.nameTable(in: elf)
            let names = nameTable.strings(in: elf) ?? []
            let entryOffsets = nameTable.entryOffsets

            let hashTable = nameIndex.hashTable(in: elf)
            let bucketRanges = hashTable.bucketRanges
            let hashes = hashTable.hashes
            for (bi, bucketRange) in bucketRanges.enumerated() {
                print("Bucket \(bi) [")

                if bucketRange.isEmpty {
                    print("EMPTY\n]")
                } else {
                    for ni in bucketRange {
                        print("  Name \(ni) {")
                        print("    Hash \(String(format: "0x%02X", hashes[ni - 1]))")
                        print("    String: \(names[ni - 1])")

                        let entries = nameIndex.entries(
                            at: entryOffsets[AnyIndex(Int(ni - 1))],
                            in: elf
                        )
                        for entry in entries {
                            dump(entry, in: elf, baseOffset: __debug_names.offset)
                        }
                    }
                }
            }
        }
    }
}

extension DWARFELFPrintTests {
    func testLine() throws {
        let dwarf = elf.dwarf
        let tables = dwarf.lineTables

        for table in tables {
            let header = table.header
            print("------")
            dump(header, in: elf)


            if let operations = try? table.operations(for: elf) {
                print(
                    """
                    Address            Line   Column File   ISA Discriminator OpIndex Flags
                    ------------------ ------ ------ ------ --- ------------- ------- -------------
                    """
                )
                let lines = operations.lines(header: table.header)
                for line in lines {
                    print(line)
                }
            }
        }
    }
}

extension DWARFELFPrintTests {
    func testAbbrev() throws {
        let dwarf = elf.dwarf
        for abbrevSet in dwarf.abbreviationsSets {
            dump(abbrevSet)
        }
    }
}

extension DWARFELFPrintTests {
    func testCompilationUnit() throws {
        let dwarf = elf.dwarf
        guard let dwarfSegment = elf.dwarfSegment,
              let __debug_info = dwarfSegment.debug_info(in: elf) else {
            return
        }
        let units = dwarf.compilationUnits
        for unit in units {
            let header = unit.header
            print("------")
            print(
                "Compile Unit:",
                "length = 0x\(String(format: "%08x", header.length)),",
                "format = \(header.format),",
                "version = \(header.version),",
                "abbr_offset = 0x\(String(format: "%04x", header.debugAbbrevOffset)),",
                "addr_size = 0x\(String(format: "%02x", header.addressSize))"
            )

            var nest = 0
            let entries = unit.debugInfoEntries(in: elf)
            for entry in entries {
                dump(
                    entry,
                    for: unit,
                    in: elf,
                    baseOffset: __debug_info.offset,
                    nest: nest
                )
                if entry.hasChildren { nest += 1 }
                if entry.tag == .null { nest -= 1 }
            }
        }
    }
}
