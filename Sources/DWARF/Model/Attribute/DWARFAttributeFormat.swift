//
//  DWARFAttributeFormat.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/22
//  
//

import Foundation

public enum DWARFAttributeFormat: Sendable {
    /// DW_FORM_addr
    case addr
    /// DW_FORM_block2
    case block2
    /// DW_FORM_block4
    case block4
    /// DW_FORM_data2
    case data2
    /// DW_FORM_data4
    case data4
    /// DW_FORM_data8
    case data8
    /// DW_FORM_string
    case string
    /// DW_FORM_block
    case block
    /// DW_FORM_block1
    case block1
    /// DW_FORM_data1
    case data1
    /// DW_FORM_flag
    case flag
    /// DW_FORM_sdata
    case sdata
    /// DW_FORM_strp
    case strp
    /// DW_FORM_udata
    case udata
    /// DW_FORM_ref_addr
    case ref_addr
    /// DW_FORM_ref1
    case ref1
    /// DW_FORM_ref2
    case ref2
    /// DW_FORM_ref4
    case ref4
    /// DW_FORM_ref8
    case ref8
    /// DW_FORM_ref_udata
    case ref_udata
    /// DW_FORM_indirect
    case indirect
    /// DW_FORM_sec_offset
    case sec_offset
    /// DW_FORM_exprloc
    case exprloc
    /// DW_FORM_flag_present
    case flag_present
    /// DW_FORM_strx
    case strx
    /// DW_FORM_addrx
    case addrx
    /// DW_FORM_ref_sup4
    case ref_sup4
    /// DW_FORM_strp_sup
    case strp_sup
    /// DW_FORM_data16
    case data16
    /// DW_FORM_line_strp
    case line_strp
    /// DW_FORM_ref_sig8
    case ref_sig8
    /// DW_FORM_implicit_const
    case implicit_const(Int64)
    /// DW_FORM_loclistx
    case loclistx
    /// DW_FORM_rnglistx
    case rnglistx
    /// DW_FORM_ref_sup8
    case ref_sup8
    /// DW_FORM_strx1
    case strx1
    /// DW_FORM_strx2
    case strx2
    /// DW_FORM_strx3
    case strx3
    /// DW_FORM_strx4
    case strx4
    /// DW_FORM_addrx1
    case addrx1
    /// DW_FORM_addrx2
    case addrx2
    /// DW_FORM_addrx3
    case addrx3
    /// DW_FORM_addrx4
    case addrx4
    /// DW_FORM_GNU_addr_index
    case gnu_addr_index
    /// DW_FORM_GNU_str_index
    case gnu_str_index
    /// DW_FORM_GNU_ref_alt
    case gnu_ref_alt
    /// DW_FORM_GNU_strp_alt
    case gnu_strp_alt
    /// DW_FORM_LLVM_addrx_offset
    case llvm_addrx_offset
}

extension DWARFAttributeFormat {
    public var type: DWARFAttributeFormatType {
        switch self {
        case .addr: .addr
        case .block2: .block2
        case .block4: .block4
        case .data2: .data2
        case .data4: .data4
        case .data8: .data8
        case .string: .string
        case .block: .block
        case .block1: .block1
        case .data1: .data1
        case .flag: .flag
        case .sdata: .sdata
        case .strp: .strp
        case .udata: .udata
        case .ref_addr: .ref_addr
        case .ref1: .ref1
        case .ref2: .ref2
        case .ref4: .ref4
        case .ref8: .ref8
        case .ref_udata: .ref_udata
        case .indirect: .indirect
        case .sec_offset: .sec_offset
        case .exprloc: .exprloc
        case .flag_present: .flag_present
        case .strx: .strx
        case .addrx: .addrx
        case .ref_sup4: .ref_sup4
        case .strp_sup: .strp_sup
        case .data16: .data16
        case .line_strp: .line_strp
        case .ref_sig8: .ref_sig8
        case .implicit_const: .implicit_const
        case .loclistx: .loclistx
        case .rnglistx: .rnglistx
        case .ref_sup8: .ref_sup8
        case .strx1: .strx1
        case .strx2: .strx2
        case .strx3: .strx3
        case .strx4: .strx4
        case .addrx1: .addrx1
        case .addrx2: .addrx2
        case .addrx3: .addrx3
        case .addrx4: .addrx4
        case .gnu_addr_index: .gnu_addr_index
        case .gnu_str_index: .gnu_str_index
        case .gnu_ref_alt: .gnu_ref_alt
        case .gnu_strp_alt: .gnu_strp_alt
        case .llvm_addrx_offset: .llvm_addrx_offset
        }
    }
}

extension DWARFAttributeFormat: CustomStringConvertible {
    public var description: String {
        switch self {
        case .implicit_const(let v):
            type.description + "(\(v))"
        default:
            type.description
        }
    }
}

extension DWARFAttributeFormat {
    public var size: Int {
        switch self {
        case .implicit_const(let v):
            type.rawValue.uleb128Size + v.sleb128Size
        default:
            type.rawValue.uleb128Size
        }
    }
}

extension DWARFAttributeFormat {
    public static func load(from ptr: UnsafeRawPointer) -> Self {
        let (formatCode, formatCodeSize) = ptr
            .assumingMemoryBound(to: UInt8.self)
            .readULEB128()
        guard let formatType = DWARFAttributeFormatType(rawValue: .init(formatCode)) else {
            fatalError()
        }
        return switch formatType {
        case .addr: .addr
        case .block2: .block2
        case .block4: .block4
        case .data2: .data2
        case .data4: .data4
        case .data8: .data8
        case .string: .string
        case .block: .block
        case .block1: .block1
        case .data1: .data1
        case .flag: .flag
        case .sdata: .sdata
        case .strp: .strp
        case .udata: .udata
        case .ref_addr: .ref_addr
        case .ref1: .ref1
        case .ref2: .ref2
        case .ref4: .ref4
        case .ref8: .ref8
        case .ref_udata: .ref_udata
        case .indirect: .indirect
        case .sec_offset: .sec_offset
        case .exprloc: .exprloc
        case .flag_present: .flag_present
        case .strx: .strx
        case .addrx: .addrx
        case .ref_sup4: .ref_sup4
        case .strp_sup: .strp_sup
        case .data16: .data16
        case .line_strp: .line_strp
        case .ref_sig8: .ref_sig8
        case .implicit_const:
            {
                let (value, _) = ptr
                    .advanced(by: numericCast(formatCodeSize))
                    .assumingMemoryBound(to: UInt8.self)
                    .readSLEB128()
                return .implicit_const(numericCast(value))
            }()
        case .loclistx: .loclistx
        case .rnglistx: .rnglistx
        case .ref_sup8: .ref_sup8
        case .strx1: .strx1
        case .strx2: .strx2
        case .strx3: .strx3
        case .strx4: .strx4
        case .addrx1: .addrx1
        case .addrx2: .addrx2
        case .addrx3: .addrx3
        case .addrx4: .addrx4
        case .gnu_addr_index: .gnu_addr_index
        case .gnu_str_index: .gnu_str_index
        case .gnu_ref_alt: .gnu_ref_alt
        case .gnu_strp_alt: .gnu_strp_alt
        case .llvm_addrx_offset: .llvm_addrx_offset
        }
    }
}
