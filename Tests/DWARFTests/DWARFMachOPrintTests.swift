//
//  DWARFMachOPrintTests.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/26
//
//

import XCTest
@testable import DWARF
@testable import DWARFMachO
import DWARFC
@_spi(Support) @testable import MachOKit

final class DWARFMachOPrintTests: XCTestCase {
    private var fat: FatFile!
    private var machO: MachOFile!

    override func setUp() async throws {
        let path = ""

        let url = URL(fileURLWithPath: path)
        guard let file = try? MachOKit.loadFromFile(url: url) else {
            XCTFail("Failed to load file")
            return
        }
        switch file {
        case let .fat(fatFile):
            self.fat = fatFile
            self.machO = try! fatFile.machOFiles()[0]
        case let .machO(machO):
            self.machO = machO
        }
    }
}

extension DWARFMachOPrintTests {
    func testDwarfSections() {
        for section in machO.sections64 {
            if section.segmentName == "__DWARF" {
                print(section.segmentName, section.sectionName)
            }
        }
    }
}

extension DWARFMachOPrintTests {
    func testStrings() {
        let dwarf = machO.dwarf
        guard let strings = dwarf.strings else { return }
        dump(strings)
    }

    func testLineStrings() {
        let dwarf = machO.dwarf
        guard let strings = dwarf.lineStrings else { return }
        dump(strings)
    }

    func testStrOffsets() {
        let dwarf = machO.dwarf
        guard let strings = dwarf.strings else { return }

        for table in dwarf.stringOffsetsTables {
            let header = table.header
            print(
                "Contribution size = \(table.layoutSize - header.format.unitLengthSize),",
                "Format = \(header.format),",
                "Version = \(header.version)"
            )

            let offsets = table.offsets(in: machO)
            for offset in offsets {
                let string = strings.string(at: numericCast(offset))?.string
                print("0x" + String(format: "%08X", offset) + ":", string ?? "")
            }
        }
    }
}

extension DWARFMachOPrintTests {
    func testAddresses() {
        let dwarf = machO.dwarf
        guard let dwarfSegment = machO.dwarfSegment,
              let __debug_addr = dwarfSegment.debug_addr(in: machO) else {
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

            let addresses = list.addresses(in: machO)
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
        let dwarf = machO.dwarf
        guard let dwarfSegment = machO.dwarfSegment,
              let __debug_aranges = dwarfSegment.debug_aranges(in: machO) else {
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
            let ranges = list.addressRanges(in: machO)
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

extension DWARFMachOPrintTests {
    func testRangeListsOperations() throws {
        let dwarf = machO.dwarf
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
            let operations = try list.operations(for: machO)
            for operation in operations {
                print(operation)
            }
        }
    }
}

extension DWARFMachOPrintTests {
    func testLocationListsOperations() throws {
        let dwarf = machO.dwarf
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
            let operations = try list.operations(for: machO)
            for operation in operations {
                print(operation)
            }
        }
    }
}

extension DWARFMachOPrintTests {
    func testNameIndices() throws {
        let dwarf = machO.dwarf

        guard let dwarfSegment = machO.dwarfSegment,
              let __debug_names = dwarfSegment.debug_names(in: machO) else {
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
                  Augmentation: '\(header.augmentation(in: machO))'
                }
                """
            )

            print("Compilation Unit offsets [")
            for (i, offset) in nameIndex.compilationUnitOffsets(in: machO).enumerated() {
                print(" CU[\(i)]:", "0x" + String(format: "%08x", offset))
            }
            print("]")

            print("Local Type Unit offsets [")
            for (i, offset) in nameIndex.localTypeUnitOffsets(in: machO).enumerated() {
                print(" Local TU[\(i)]:", "0x" + String(format: "%08x", offset))
            }
            print("]")

            print("Foreign Type Unit offsets [")
            for (i, offset) in nameIndex.foreignTypeUnitOffsets(in: machO).enumerated() {
                print(" Foreign TU[\(i)]:", "0x" + String(format: "%08x", offset))
            }
            print("]")

            print("Abbreviations [")
            if let abbreviationsSets = nameIndex.abbreviationsSet(in: machO) {
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

            let nameTable = nameIndex.nameTable(in: machO)
            let names = nameTable.strings(in: machO) ?? []
            let entryOffsets = nameTable.entryOffsets

            let hashTable = nameIndex.hashTable(in: machO)
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
                            in: machO
                        )
                        for entry in entries {
                            dump(entry, in: machO, baseOffset: __debug_names.offset)
                        }
                    }
                }
            }
        }
    }
}

extension DWARFMachOPrintTests {
    func testLine() throws {
        let dwarf = machO.dwarf
        let tables = dwarf.lineTables

        for table in tables {
            let header = table.header
            print("------")
            dump(header, in: machO)


            if let operations = try? table.operations(for: machO) {
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

extension DWARFMachOPrintTests {
    func testAbbrev() throws {
        let dwarf = machO.dwarf
        for abbrevSet in dwarf.abbreviationsSets {
            dump(abbrevSet)
        }
    }
}

extension DWARFMachOPrintTests {
    func testCompilationUnit() throws {
        let dwarf = machO.dwarf
        guard let dwarfSegment = machO.dwarfSegment,
              let __debug_info = dwarfSegment.debug_info(in: machO) else {
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
            let entries = unit.debugInfoEntries(in: machO)
            for entry in entries {
                dump(
                    entry,
                    for: unit,
                    in: machO,
                    baseOffset: __debug_info.offset,
                    nest: nest
                )
                if entry.hasChildren { nest += 1 }
                if entry.tag == .null { nest -= 1 }
            }
        }
    }
}
