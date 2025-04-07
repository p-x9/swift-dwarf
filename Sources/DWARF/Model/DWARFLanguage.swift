//
//  DWARFLanguage.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/04/06
//  
//

import Foundation
import DWARFC

public enum DWARFLanguage: CaseIterable {
    /// DW_LANG_C89
    case c89
    /// DW_LANG_C
    case c
    /// DW_LANG_Ada83
    case ada83
    /// DW_LANG_C_plus_plus
    case c_plus_plus
    /// DW_LANG_C_plus_plus_03
    case c_plus_plus_03
    /// DW_LANG_C_plus_plus_11
    case c_plus_plus_11
    /// DW_LANG_C_plus_plus_14
    case c_plus_plus_14
    /// DW_LANG_Cobol74
    case cobol74
    /// DW_LANG_Cobol85
    case cobol85
    /// DW_LANG_Fortran77
    case fortran77
    /// DW_LANG_Fortran90
    case fortran90
    /// DW_LANG_Pascal83
    case pascal83
    /// DW_LANG_Modula2
    case modula2
    /// DW_LANG_Java
    case java
    /// DW_LANG_C99
    case c99
    /// DW_LANG_Ada95
    case ada95
    /// DW_LANG_Fortran95
    case fortran95
    /// DW_LANG_PLI
    case pli
    /// DW_LANG_ObjC
    case objc
    /// DW_LANG_ObjC_plus_plus
    case objc_plus_plus
    /// DW_LANG_UPC
    case upc
    /// DW_LANG_D
    case d
    /// DW_LANG_Python
    case python
    /// DW_LANG_Mips_Assembler
    case mips_assembler
    /// DW_LANG_Upc
    case upcLegacy
    /// DW_LANG_ALTIUM_Assembler
    case altium_assembler
}

extension DWARFLanguage: RawRepresentable {
    public typealias RawValue = UInt16

    public init?(rawValue: RawValue) {
        switch rawValue {
        case numericCast(DW_LANG_C89): self = .c89
        case numericCast(DW_LANG_C): self = .c
        case numericCast(DW_LANG_Ada83): self = .ada83
        case numericCast(DW_LANG_C_plus_plus): self = .c_plus_plus
        case numericCast(DW_LANG_C_plus_plus_03): self = .c_plus_plus_03
        case numericCast(DW_LANG_C_plus_plus_11): self = .c_plus_plus_11
        case numericCast(DW_LANG_C_plus_plus_14): self = .c_plus_plus_14
        case numericCast(DW_LANG_Cobol74): self = .cobol74
        case numericCast(DW_LANG_Cobol85): self = .cobol85
        case numericCast(DW_LANG_Fortran77): self = .fortran77
        case numericCast(DW_LANG_Fortran90): self = .fortran90
        case numericCast(DW_LANG_Pascal83): self = .pascal83
        case numericCast(DW_LANG_Modula2): self = .modula2
        case numericCast(DW_LANG_Java): self = .java
        case numericCast(DW_LANG_C99): self = .c99
        case numericCast(DW_LANG_Ada95): self = .ada95
        case numericCast(DW_LANG_Fortran95): self = .fortran95
        case numericCast(DW_LANG_PLI): self = .pli
        case numericCast(DW_LANG_ObjC): self = .objc
        case numericCast(DW_LANG_ObjC_plus_plus): self = .objc_plus_plus
        case numericCast(DW_LANG_UPC): self = .upc
        case numericCast(DW_LANG_D): self = .d
        case numericCast(DW_LANG_Python): self = .python
        case numericCast(DW_LANG_Mips_Assembler): self = .mips_assembler
        case numericCast(DW_LANG_Upc): self = .upcLegacy
        case numericCast(DW_LANG_ALTIUM_Assembler): self = .altium_assembler
        default: return nil
        }
    }
    public var rawValue: RawValue {
        switch self {
        case .c89: numericCast(DW_LANG_C89)
        case .c: numericCast(DW_LANG_C)
        case .ada83: numericCast(DW_LANG_Ada83)
        case .c_plus_plus: numericCast(DW_LANG_C_plus_plus)
        case .c_plus_plus_03: numericCast(DW_LANG_C_plus_plus_03)
        case .c_plus_plus_11: numericCast(DW_LANG_C_plus_plus_11)
        case .c_plus_plus_14: numericCast(DW_LANG_C_plus_plus_14)
        case .cobol74: numericCast(DW_LANG_Cobol74)
        case .cobol85: numericCast(DW_LANG_Cobol85)
        case .fortran77: numericCast(DW_LANG_Fortran77)
        case .fortran90: numericCast(DW_LANG_Fortran90)
        case .pascal83: numericCast(DW_LANG_Pascal83)
        case .modula2: numericCast(DW_LANG_Modula2)
        case .java: numericCast(DW_LANG_Java)
        case .c99: numericCast(DW_LANG_C99)
        case .ada95: numericCast(DW_LANG_Ada95)
        case .fortran95: numericCast(DW_LANG_Fortran95)
        case .pli: numericCast(DW_LANG_PLI)
        case .objc: numericCast(DW_LANG_ObjC)
        case .objc_plus_plus: numericCast(DW_LANG_ObjC_plus_plus)
        case .upc: numericCast(DW_LANG_UPC)
        case .d: numericCast(DW_LANG_D)
        case .python: numericCast(DW_LANG_Python)
        case .mips_assembler: numericCast(DW_LANG_Mips_Assembler)
        case .upcLegacy: numericCast(DW_LANG_Upc)
        case .altium_assembler: numericCast(DW_LANG_ALTIUM_Assembler)
        }
    }
}
extension DWARFLanguage: CustomStringConvertible {
    public var description: String {
        switch self {
        case .c89: "DW_LANG_C89"
        case .c: "DW_LANG_C"
        case .ada83: "DW_LANG_Ada83"
        case .c_plus_plus: "DW_LANG_C_plus_plus"
        case .c_plus_plus_03: "DW_LANG_C_plus_plus_03"
        case .c_plus_plus_11: "DW_LANG_C_plus_plus_11"
        case .c_plus_plus_14: "DW_LANG_C_plus_plus_14"
        case .cobol74: "DW_LANG_Cobol74"
        case .cobol85: "DW_LANG_Cobol85"
        case .fortran77: "DW_LANG_Fortran77"
        case .fortran90: "DW_LANG_Fortran90"
        case .pascal83: "DW_LANG_Pascal83"
        case .modula2: "DW_LANG_Modula2"
        case .java: "DW_LANG_Java"
        case .c99: "DW_LANG_C99"
        case .ada95: "DW_LANG_Ada95"
        case .fortran95: "DW_LANG_Fortran95"
        case .pli: "DW_LANG_PLI"
        case .objc: "DW_LANG_ObjC"
        case .objc_plus_plus: "DW_LANG_ObjC_plus_plus"
        case .upc: "DW_LANG_UPC"
        case .d: "DW_LANG_D"
        case .python: "DW_LANG_Python"
        case .mips_assembler: "DW_LANG_Mips_Assembler"
        case .upcLegacy: "DW_LANG_Upc"
        case .altium_assembler: "DW_LANG_ALTIUM_Assembler"
        }
    }
}
