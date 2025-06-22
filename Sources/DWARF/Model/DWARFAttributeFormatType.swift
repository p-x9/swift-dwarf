//
//  DWARFAttributeFormatType.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/22
//  
//

import Foundation

public enum DWARFAttributeFormatType: CaseIterable {
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
    /// DW_FORM_ref_sig8
    case ref_sig8
    /// DW_FORM_implicit_const
    case implicit_const
    /// DW_FORM_loclistx
    case loclistx
    /// DW_FORM_rnglistx
    case rnglistx
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
}

extension DWARFAttributeFormatType: RawRepresentable {
    public typealias RawValue = UInt8

    public init?(rawValue: RawValue) {
        switch rawValue {
        case numericCast(DW_FORM_addr): self = .addr
        case numericCast(DW_FORM_block2): self = .block2
        case numericCast(DW_FORM_block4): self = .block4
        case numericCast(DW_FORM_data2): self = .data2
        case numericCast(DW_FORM_data4): self = .data4
        case numericCast(DW_FORM_data8): self = .data8
        case numericCast(DW_FORM_string): self = .string
        case numericCast(DW_FORM_block): self = .block
        case numericCast(DW_FORM_block1): self = .block1
        case numericCast(DW_FORM_data1): self = .data1
        case numericCast(DW_FORM_flag): self = .flag
        case numericCast(DW_FORM_sdata): self = .sdata
        case numericCast(DW_FORM_strp): self = .strp
        case numericCast(DW_FORM_udata): self = .udata
        case numericCast(DW_FORM_ref_addr): self = .ref_addr
        case numericCast(DW_FORM_ref1): self = .ref1
        case numericCast(DW_FORM_ref2): self = .ref2
        case numericCast(DW_FORM_ref4): self = .ref4
        case numericCast(DW_FORM_ref8): self = .ref8
        case numericCast(DW_FORM_ref_udata): self = .ref_udata
        case numericCast(DW_FORM_indirect): self = .indirect
        case numericCast(DW_FORM_sec_offset): self = .sec_offset
        case numericCast(DW_FORM_exprloc): self = .exprloc
        case numericCast(DW_FORM_flag_present): self = .flag_present
        case numericCast(DW_FORM_strx): self = .strx
        case numericCast(DW_FORM_addrx): self = .addrx
        case numericCast(DW_FORM_ref_sig8): self = .ref_sig8
        case numericCast(DW_FORM_implicit_const): self = .implicit_const
        case numericCast(DW_FORM_loclistx): self = .loclistx
        case numericCast(DW_FORM_rnglistx): self = .rnglistx
        case numericCast(DW_FORM_strx1): self = .strx1
        case numericCast(DW_FORM_strx2): self = .strx2
        case numericCast(DW_FORM_strx3): self = .strx3
        case numericCast(DW_FORM_strx4): self = .strx4
        case numericCast(DW_FORM_addrx1): self = .addrx1
        case numericCast(DW_FORM_addrx2): self = .addrx2
        case numericCast(DW_FORM_addrx3): self = .addrx3
        case numericCast(DW_FORM_addrx4): self = .addrx4
        default: return nil
        }
    }
    public var rawValue: RawValue {
        switch self {
        case .addr: numericCast(DW_FORM_addr)
        case .block2: numericCast(DW_FORM_block2)
        case .block4: numericCast(DW_FORM_block4)
        case .data2: numericCast(DW_FORM_data2)
        case .data4: numericCast(DW_FORM_data4)
        case .data8: numericCast(DW_FORM_data8)
        case .string: numericCast(DW_FORM_string)
        case .block: numericCast(DW_FORM_block)
        case .block1: numericCast(DW_FORM_block1)
        case .data1: numericCast(DW_FORM_data1)
        case .flag: numericCast(DW_FORM_flag)
        case .sdata: numericCast(DW_FORM_sdata)
        case .strp: numericCast(DW_FORM_strp)
        case .udata: numericCast(DW_FORM_udata)
        case .ref_addr: numericCast(DW_FORM_ref_addr)
        case .ref1: numericCast(DW_FORM_ref1)
        case .ref2: numericCast(DW_FORM_ref2)
        case .ref4: numericCast(DW_FORM_ref4)
        case .ref8: numericCast(DW_FORM_ref8)
        case .ref_udata: numericCast(DW_FORM_ref_udata)
        case .indirect: numericCast(DW_FORM_indirect)
        case .sec_offset: numericCast(DW_FORM_sec_offset)
        case .exprloc: numericCast(DW_FORM_exprloc)
        case .flag_present: numericCast(DW_FORM_flag_present)
        case .strx: numericCast(DW_FORM_strx)
        case .addrx: numericCast(DW_FORM_addrx)
        case .ref_sig8: numericCast(DW_FORM_ref_sig8)
        case .implicit_const: numericCast(DW_FORM_implicit_const)
        case .loclistx: numericCast(DW_FORM_loclistx)
        case .rnglistx: numericCast(DW_FORM_rnglistx)
        case .strx1: numericCast(DW_FORM_strx1)
        case .strx2: numericCast(DW_FORM_strx2)
        case .strx3: numericCast(DW_FORM_strx3)
        case .strx4: numericCast(DW_FORM_strx4)
        case .addrx1: numericCast(DW_FORM_addrx1)
        case .addrx2: numericCast(DW_FORM_addrx2)
        case .addrx3: numericCast(DW_FORM_addrx3)
        case .addrx4: numericCast(DW_FORM_addrx4)
        }
    }
}
extension DWARFAttributeFormatType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .addr: "DW_FORM_addr"
        case .block2: "DW_FORM_block2"
        case .block4: "DW_FORM_block4"
        case .data2: "DW_FORM_data2"
        case .data4: "DW_FORM_data4"
        case .data8: "DW_FORM_data8"
        case .string: "DW_FORM_string"
        case .block: "DW_FORM_block"
        case .block1: "DW_FORM_block1"
        case .data1: "DW_FORM_data1"
        case .flag: "DW_FORM_flag"
        case .sdata: "DW_FORM_sdata"
        case .strp: "DW_FORM_strp"
        case .udata: "DW_FORM_udata"
        case .ref_addr: "DW_FORM_ref_addr"
        case .ref1: "DW_FORM_ref1"
        case .ref2: "DW_FORM_ref2"
        case .ref4: "DW_FORM_ref4"
        case .ref8: "DW_FORM_ref8"
        case .ref_udata: "DW_FORM_ref_udata"
        case .indirect: "DW_FORM_indirect"
        case .sec_offset: "DW_FORM_sec_offset"
        case .exprloc: "DW_FORM_exprloc"
        case .flag_present: "DW_FORM_flag_present"
        case .strx: "DW_FORM_strx"
        case .addrx: "DW_FORM_addrx"
        case .ref_sig8: "DW_FORM_ref_sig8"
        case .implicit_const: "DW_FORM_implicit_const"
        case .loclistx: "DW_FORM_loclistx"
        case .rnglistx: "DW_FORM_rnglistx"
        case .strx1: "DW_FORM_strx1"
        case .strx2: "DW_FORM_strx2"
        case .strx3: "DW_FORM_strx3"
        case .strx4: "DW_FORM_strx4"
        case .addrx1: "DW_FORM_addrx1"
        case .addrx2: "DW_FORM_addrx2"
        case .addrx3: "DW_FORM_addrx3"
        case .addrx4: "DW_FORM_addrx4"
        }
    }
}
