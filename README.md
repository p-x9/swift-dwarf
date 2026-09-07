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

Support is tracked by section and feature below. A supported section does not
imply complete support for every DWARF version, form, or related object-file
feature.

Legend: ✅ supported, 🟡 partially supported, ❌ not implemented.

### Binary formats

| Format | Status | Notes |
| --- | --- | --- |
| Mach-O | ✅ | Thin and fat binaries are supported. Full big-endian DWARF support is not guaranteed. |
| ELF | 🟡 | ELFKit currently limits parsing to binaries with the same endianness as the host. Compressed debug sections are not supported. |

### DWARF sections

| Section | DWARF version | Status | Notes |
| --- | --- | --- | --- |
| `.debug_abbrev` | 2–5 | ✅ | Abbreviation tables and attribute specifications. |
| `.debug_info` | 2–5 | 🟡 | Compilation units and DIEs. Some forms and external-file references remain unsupported. |
| `.debug_line` | 4–5 | 🟡 | Headers, file tables, line programs, and VLIW operation state. DWARF 5 `DW_LNE_define_file` format descriptors and DWARF 2–3 headers are not supported. |
| `.debug_str` | 2–5 | ✅ | String table lookup. |
| `.debug_line_str` | 5 | ✅ | Line string table lookup. |
| `.debug_str_offsets` | 5 | ✅ | String offsets tables. |
| `.debug_addr` | 5 | ✅ | Address tables. |
| `.debug_aranges` | 2–5 | ✅ | Address range table headers and tuples. |
| `.debug_rnglists` | 5 | ✅ | Range list tables and entries. |
| `.debug_loclists` | 5 | ✅ | Location list tables and entries. |
| `.debug_names` | 5 | ✅ | Name index tables and lookup. |
| `.debug_ranges` | 2–4 | ❌ | Legacy range lists. |
| `.debug_loc` | 2–4 | ❌ | Legacy location lists. |
| `.debug_types` | 4 | ❌ | Type unit headers and signature lookup are not implemented. |
| `.debug_macro` | 5 | ❌ | Macro information. |
| `.debug_macinfo` | 2–4 | ❌ | Legacy macro information. |
| `.debug_frame` / `.eh_frame` | — | ❌ | Call frame information and unwinding. |
| `.debug_pubnames` / `.debug_pubtypes` | 2–4 | ❌ | Legacy public name and type indexes. |

### Known limitations

- Split DWARF `.dwo` loading and supplementary object files are not supported.
- `DW_FORM_ref_sig8`, `DW_FORM_ref_sup4`, `DW_FORM_ref_sup8`,
  `DW_FORM_strp_sup`, and GNU alternate reference/string forms are read but not
  resolved.
- ELF compressed debug sections are not supported.
- Endianness is handled by several DWARF readers, but the library does not yet
  claim complete big-endian coverage across every section and container.

## License

swift-dwarf is released under the MIT License. See [LICENSE](./LICENSE)
