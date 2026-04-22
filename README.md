# swift-dwarf

A Swift library for parsing binary files to obtain DWARF information.

> [!NOTE]
> Mach-O and ELF binaries are supported.
> [MachOKit](https://github.com/p-x9/MachOKit) is used for Mach-O binaries.
> [ELFKit](https://github.com/p-x9/ELFKit) is used for ELF binaries.

<!-- # Badges -->

[![Github issues](https://img.shields.io/github/issues/p-x9/swift-dwarf)](https://github.com/p-x9/swift/issues)
[![Github forks](https://img.shields.io/github/forks/p-x9/swift-dwarf)](https://github.com/p-x9/swift-dwarf/network/members)
[![Github stars](https://img.shields.io/github/stars/p-x9/swift-dwarf)](https://github.com/p-x9/swift-dwarf/stargazers)
[![Github top language](https://img.shields.io/github/languages/top/p-x9/swift-dwarf)](https://github.com/p-x9/swift-dwarf/)

## Usage

### Basic

DWARF information from binary files can be retrieved via the `dwarf` property.
Import the format-specific adapter that matches the binary type you want to inspect.

```swift
import MachOKit
import DWARF
import DWARFMachO

let machO: MachOFile = ...

// string table in `.debug_str` section
let strings = machO.dwarf.strings

// abbreviations tables in `.debug_abbrev` section
let abbreviationSets = machO.dwarf.abbreviationsSets

// compilation units in `.debug_info` section
let compilationUnits = machO.dwarf.compilationUnits
/* ... */
```

```swift
import ELFKit
import DWARF
import DWARFELF

let elf: ELFFile = ...

let elfStrings = elf.dwarf.strings
let elfCompilationUnits = elf.dwarf.compilationUnits
```

[DWARFMachOPrintTests.swift](/Tests/DWARFTests/DWARFMachOPrintTests.swift) provides test cases that generate output similar to dwarfdump.
[DWARFELFPrintTests.swift](/Tests/DWARFTests/DWARFELFPrintTests.swift) provides the same for ELF binaries.
Please use these as a reference.

## Status

### Supported Binary formats

- [x] mach-o
- [x] ELF

### Supported DWARF sections

- [x] `.debug_abbrev`
- [x] `.debug_info`
- [x] `.debug_line`
- [x] `.debug_str`
- [x] `.debug_line_str`
- [x] `.debug_str_offs`
- [x] `.debug_addr`
- [x] `.debug_aranges`
- [x] `.debug_rnglists`
- [x] `.debug_loclists`
- [x] `.debug_names`
- [ ] `.debug-macro`
- [ ] `.debug-pubnames`
- [ ] `.debug-pubtypes`
- [ ] `.debug-ranges`

## License

swift-dwarf is released under the MIT License. See [LICENSE](./LICENSE)
