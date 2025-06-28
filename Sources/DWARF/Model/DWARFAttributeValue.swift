//
//  DWARFAttributeValue.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/23
//  
//

import Foundation

// ref: https://github.com/llvm/llvm-project/blob/357297c0f2839ffb3c6b814ab3276580c7eae90d/llvm/lib/DebugInfo/DWARF/DWARFFormValue.cpp
public indirect enum DWARFAttributeValue {
    /// DW_FORM_addr
    case addr(UInt64) // address_size 4 or 8
    /// DW_FORM_block2
    case block2(Block)
    /// DW_FORM_block4
    case block4(Block)
    /// DW_FORM_data2
    case data2(Constant<UInt16>)
    /// DW_FORM_data4
    case data4(Constant<UInt32>)
    /// DW_FORM_data8
    case data8(Constant<UInt64>)
    /// DW_FORM_string
    case string(String)
    /// DW_FORM_block
    case block(Block) // uleb128
    /// DW_FORM_block1
    case block1(Block)
    /// DW_FORM_data1
    case data1(Constant<UInt8>)
    /// DW_FORM_flag
    case flag(Flag) // uint8
    /// DW_FORM_sdata
    case sdata(Constant<Int64>) // sleb128
    /// DW_FORM_strp
    case strp(RefString)
    /// DW_FORM_udata
    case udata(Constant<UInt64>) // uleb128
    /// DW_FORM_ref_addr
    case ref_addr(Reference)
    /// DW_FORM_ref1
    case ref1(Reference)
    /// DW_FORM_ref2
    case ref2(Reference)
    /// DW_FORM_ref4
    case ref4(Reference)
    /// DW_FORM_ref8
    case ref8(Reference)
    /// DW_FORM_ref_udata
    case ref_udata(Reference)
    /// DW_FORM_indirect
    case indirect(DWARFAttributeValue) // uleb128
    /// DW_FORM_sec_offset
    case sec_offset(Ptr)
    /// DW_FORM_exprloc
    case exprloc(ExprLoc)
    /// DW_FORM_flag_present
    case flag_present
    /// DW_FORM_strx
    case strx(IndexedString)
    /// DW_FORM_addrx
    case addrx(UInt64) // uleb128
    /// DW_FORM_ref_sup4
    case ref_sup4(Reference)
    /// DW_FORM_strp_sup
    case strp_sup(RefString)
    /// DW_FORM_data16
    case data16(Constant<(UInt64, UInt64)>)
    /// DW_FORM_line_strp
    case line_strp(RefString)
    /// DW_FORM_ref_sig8
    case ref_sig8(Reference)
    /// DW_FORM_implicit_const
    case implicit_const(Constant<Int64>) // sleb128
    /// DW_FORM_loclistx
    case loclistx(LocList)
    /// DW_FORM_rnglistx
    case rnglistx(RngList)
    /// DW_FORM_ref_sup8
    case ref_sup8(Reference)
    /// DW_FORM_strx1
    case strx1(IndexedString)
    /// DW_FORM_strx2
    case strx2(IndexedString)
    /// DW_FORM_strx3
    case strx3(IndexedString)
    /// DW_FORM_strx4
    case strx4(IndexedString)
    /// DW_FORM_addrx1
    case addrx1(IndexedAddress)
    /// DW_FORM_addrx2
    case addrx2(IndexedAddress)
    /// DW_FORM_addrx3
    case addrx3(IndexedAddress) // uint24
    /// DW_FORM_addrx4
    case addrx4(IndexedAddress)
    /// DW_FORM_GNU_addr_index
    case gnu_addr_index(IndexedAddress)
    /// DW_FORM_GNU_str_index
    case gnu_str_index(IndexedAddress)
    /// DW_FORM_GNU_ref_alt
    case gnu_ref_alt(UInt64)
    /// DW_FORM_GNU_strp_alt
    case gnu_strp_alt(UInt64)
    /// DW_FORM_LLVM_addrx_offset
    case llvm_addrx_offset(UInt64)
}

extension DWARFAttributeValue {
    public var format: DWARFAttributeFormat {
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
        case .implicit_const(let v): .implicit_const(v.value)
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

    public var type: DWARFAttributeFormatType {
        format.type
    }
}

extension DWARFAttributeValue {
    public struct Block {
        public let length: UInt64
        public let data: Data
    }

    public struct Constant<V> {
        public let value: V
    }

    public struct Flag {
        public let _value: UInt8
        public var value: Bool {
            return _value != 0
        }
    }

    public struct ExprLoc {
        public let length: UInt64
        public let data: Data
    }

    public struct Ptr {
        public let address: UInt64
        public let addressSize: Int
    }

    public struct Reference {
        public let offset: UInt64
    }

    public struct LocList {
        public let offset: UInt64
        public let addressSize: Int
    }

    public struct RngList {
        public let offset: UInt64
        public let addressSize: Int
    }

    public struct RefString {
        public let offset: UInt64
    }

    public struct IndexedString {
        public let offset: UInt64
    }

    public struct IndexedAddress {
        public let offset: UInt64
    }
}

// ref: https://github.com/llvm/llvm-project/blob/357297c0f2839ffb3c6b814ab3276580c7eae90d/llvm/lib/DebugInfo/DWARF/DWARFFormValue.cpp#L220
extension DWARFAttributeValue {
    public func size(addressSize: Int) -> Int {
        switch self {
        case .addr:
            addressSize
        case .block2(let block):
            MemoryLayout<UInt16>.size + block.data.count
        case .block4(let block):
            MemoryLayout<UInt32>.size + block.data.count
        case .data2:
            MemoryLayout<UInt16>.size
        case .data4:
            MemoryLayout<UInt32>.size
        case .data8:
            MemoryLayout<UInt64>.size
        case .string(let string):
            string.data(using: .utf8)!.count + 1 // +1 for null terminator
        case .block(let block):
            block.length.uleb128Size + block.data.count
        case .block1(let block):
            MemoryLayout<UInt8>.size + block.data.count
        case .data1:
            MemoryLayout<UInt8>.size
        case .flag:
            MemoryLayout<UInt8>.size
        case .sdata(let constant):
            constant.value.sleb128Size
        case .strp:
            addressSize
        case .udata(let constant):
            constant.value.uleb128Size
        case .ref_addr:
            addressSize
        case .ref1:
            MemoryLayout<UInt8>.size
        case .ref2:
            MemoryLayout<UInt16>.size
        case .ref4:
            MemoryLayout<UInt32>.size
        case .ref8:
            MemoryLayout<UInt64>.size
        case .ref_udata(let reference):
            reference.offset.uleb128Size
        case .indirect(let DWARFAttributeValue):
            DWARFAttributeValue.type.rawValue.uleb128Size + DWARFAttributeValue.size(addressSize: addressSize)
        case .sec_offset:
            addressSize
        case .exprloc(let exprLoc):
            exprLoc.length.uleb128Size + exprLoc.data.count
        case .flag_present:
            0
        case .strx(let indexedString):
            indexedString.offset.uleb128Size
        case .addrx(let uInt64):
            uInt64.uleb128Size
        case .ref_sup4:
            MemoryLayout<UInt32>.size
        case .strp_sup:
            addressSize
        case .data16:
            MemoryLayout<UInt64>.size * 2
        case .line_strp:
            addressSize
        case .ref_sig8:
            MemoryLayout<UInt64>.size
        case .implicit_const:
            0
            //            constant.value.sleb128Size // debug_abbrev内に存在
        case .loclistx(let locList):
            locList.offset.uleb128Size
        case .rnglistx(let rngList):
            rngList.offset.uleb128Size
        case .ref_sup8:
            MemoryLayout<UInt64>.size
        case .strx1:
            MemoryLayout<UInt8>.size
        case .strx2:
            MemoryLayout<UInt16>.size
        case .strx3:
            MemoryLayout<UInt8>.size * 3
        case .strx4:
            MemoryLayout<UInt32>.size
        case .addrx1:
            MemoryLayout<UInt8>.size
        case .addrx2:
            MemoryLayout<UInt16>.size
        case .addrx3:
            MemoryLayout<UInt8>.size * 3
        case .addrx4:
            MemoryLayout<UInt32>.size
        case .gnu_addr_index(let indexedAddress):
            indexedAddress.offset.uleb128Size
        case .gnu_str_index(let indexedAddress):
            indexedAddress.offset.uleb128Size
        case .gnu_ref_alt:
            addressSize
        case .gnu_strp_alt:
            addressSize
        case .llvm_addrx_offset(let offset):
            (offset >> 32).uleb128Size + 4
        }
    }
}
