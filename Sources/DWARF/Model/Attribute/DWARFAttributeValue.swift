//
//  DWARFAttributeValue.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/23
//
//

import Foundation
@testable import MachOKit // FIXME: FileIO

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
    case ref_addr(Reference<UInt64>)
    /// DW_FORM_ref1
    case ref1(Reference<UInt8>)
    /// DW_FORM_ref2
    case ref2(Reference<UInt16>)
    /// DW_FORM_ref4
    case ref4(Reference<UInt32>)
    /// DW_FORM_ref8
    case ref8(Reference<UInt64>)
    /// DW_FORM_ref_udata
    case ref_udata(Reference<UInt64>) // uleb128
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
    case addrx(IndexedAddress) // uleb128
    /// DW_FORM_ref_sup4
    case ref_sup4(Reference<UInt32>)
    /// DW_FORM_strp_sup
    case strp_sup(RefString)
    /// DW_FORM_data16
    case data16(Constant<(UInt64, UInt64)>)
    /// DW_FORM_line_strp
    case line_strp(RefString)
    /// DW_FORM_ref_sig8
    case ref_sig8(Reference<UInt64>)
    /// DW_FORM_implicit_const
    case implicit_const(Constant<Int64>) // sleb128
    /// DW_FORM_loclistx
    case loclistx(LocList)
    /// DW_FORM_rnglistx
    case rnglistx(RngList)
    /// DW_FORM_ref_sup8
    case ref_sup8(Reference<UInt64>)
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
    case gnu_str_index(IndexedString)
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
    }

    public struct Reference<Raw: FixedWidthInteger> {
        public let _offset: Raw

        public var offset: UInt64 {
            numericCast(_offset)
        }
    }

    public struct LocList {
        public let offset: UInt64
    }

    public struct RngList {
        public let offset: UInt64
    }

    public struct RefString {
        public let offset: UInt64
    }

    public struct IndexedString {
        public let index: UInt64
    }

    public struct IndexedAddress {
        public let index: UInt64
    }
}

// ref: https://github.com/llvm/llvm-project/blob/357297c0f2839ffb3c6b814ab3276580c7eae90d/llvm/lib/DebugInfo/DWARF/DWARFFormValue.cpp#L220
extension DWARFAttributeValue {
    public func size(
        dwarfFormat: DWARFFormat,
        addressSize: Int
    ) -> Int {
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
            dwarfFormat.addressSize
        case .udata(let constant):
            constant.value.uleb128Size
        case .ref_addr:
            dwarfFormat.addressSize
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
            DWARFAttributeValue.type.rawValue.uleb128Size + DWARFAttributeValue.size(
                dwarfFormat: dwarfFormat,
                addressSize: addressSize
            )
        case .sec_offset:
            dwarfFormat.addressSize
        case .exprloc(let exprLoc):
            exprLoc.length.uleb128Size + exprLoc.data.count
        case .flag_present:
            0
        case .strx(let indexedString):
            indexedString.index.uleb128Size
        case .addrx(let indexedAddress):
            indexedAddress.index.uleb128Size
        case .ref_sup4:
            MemoryLayout<UInt32>.size
        case .strp_sup:
            dwarfFormat.addressSize
        case .data16:
            MemoryLayout<UInt64>.size * 2
        case .line_strp:
            dwarfFormat.addressSize
        case .ref_sig8:
            MemoryLayout<UInt64>.size
        case .implicit_const:
            0
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
            indexedAddress.index.uleb128Size
        case .gnu_str_index(let indexedAddress):
            indexedAddress.index.uleb128Size
        case .gnu_ref_alt:
            dwarfFormat.addressSize
        case .gnu_strp_alt:
            dwarfFormat.addressSize
        case .llvm_addrx_offset(let offset):
            (offset >> 32).uleb128Size + 4
        }
    }
}

extension DWARFAttributeValue {
    public static func load(
        at offset: Int,
        from machO: MachOFile,
        as format: DWARFAttributeFormat,
        dwarfFormat: DWARFFormat,
        addressSize: Int
    ) -> Self? {
        let offset = offset + machO.headerStartOffset
        switch format {
        case .addr:
            if addressSize == 4 {
                let offset: UInt32 = try! machO.fileHandle.read(offset: offset)
                return .addr(numericCast(offset))
            } else {
                let offset: UInt64 = try! machO.fileHandle.read(offset: offset)
                return .addr(numericCast(offset))
            }
        case .block2:
            let length: UInt16 = try! machO.fileHandle.read(offset: offset)
            let data = try! machO.fileHandle.readData(
                offset: offset + MemoryLayout<UInt16>.size,
                length: numericCast(length)
            )
            return .block2(
                .init(length: numericCast(length), data: data)
            )
        case .block4:
            let length: UInt32 = try! machO.fileHandle.read(offset: offset)
            let data = try! machO.fileHandle.readData(
                offset: offset + MemoryLayout<UInt32>.size,
                length: numericCast(length)
            )
            return .block4(
                .init(length: numericCast(length), data: data)
            )
        case .data2:
            return .data2(
                .init(value: try! machO.fileHandle.read(offset: offset))
            )
        case .data4:
            return .data4(
                .init(value: try! machO.fileHandle.read(offset: offset))
            )
        case .data8:
            return .data8(
                .init(value: try! machO.fileHandle.read(offset: offset))
            )
        case .string:
            return .string(
                machO.fileHandle.readString(offset: numericCast(offset)) ?? ""
            )
        case .block:
            let (length, lengthSize) = machO.fileHandle.readULEB128(
                baseOffset: numericCast(offset)
            )
            let data = try! machO.fileHandle.readData(
                offset: offset + lengthSize,
                length: numericCast(length)
            )
            return .block(
                .init(length: numericCast(length), data: data)
            )
        case .block1:
            let length: UInt8 = try! machO.fileHandle.read(offset: offset)
            let data = try! machO.fileHandle.readData(
                offset: offset + MemoryLayout<UInt8>.size,
                length: numericCast(length)
            )
            return .block1(
                .init(length: numericCast(length), data: data)
            )
        case .data1:
            return .data1(
                .init(value: try! machO.fileHandle.read(offset: offset))
            )
        case .flag:
            return .flag(
                .init(_value: try! machO.fileHandle.read(offset: offset))
            )
        case .sdata:
            let (data, _) = machO.fileHandle.readSLEB128(
                baseOffset: numericCast(offset)
            )
            return .sdata(.init(value: numericCast(data)))
        case .strp:
            switch dwarfFormat {
            case ._32bit:
                let offset: UInt32 = try! machO.fileHandle.read(offset: offset)
                return .strp(.init(offset: numericCast(offset)))
            case ._64bit:
                let offset: UInt64 = try! machO.fileHandle.read(offset: offset)
                return .strp(.init(offset: offset))
            }
        case .udata:
            let (data, _) = machO.fileHandle.readULEB128(
                baseOffset: numericCast(offset)
            )
            return .udata(.init(value: numericCast(data)))
        case .ref_addr:
            switch dwarfFormat {
            case ._32bit:
                let offset: UInt32 = try! machO.fileHandle.read(offset: offset)
                return .ref_addr(.init(_offset: numericCast(offset)))
            case ._64bit:
                let offset: UInt64 = try! machO.fileHandle.read(offset: offset)
                return .ref_addr(.init(_offset: offset))
            }
        case .ref1:
            return .ref1(.init(_offset: try! machO.fileHandle.read(offset: offset)))
        case .ref2:
            return .ref2(.init(_offset: try! machO.fileHandle.read(offset: offset)))
        case .ref4:
            return .ref4(.init(_offset: try! machO.fileHandle.read(offset: offset)))
        case .ref8:
            return .ref8(.init(_offset: try! machO.fileHandle.read(offset: offset)))
        case .ref_udata:
            let (data, _) = machO.fileHandle.readULEB128(
                baseOffset: numericCast(offset)
            )
            return .ref_udata(.init(_offset: numericCast(data)))
        case .indirect:
            let format: DWARFAttributeFormat = .load(
                from: machO.fileHandle.ptr
                    .advanced(by: offset)
            )
            guard let value: DWARFAttributeValue = .load(
                at: offset - machO.headerStartOffset + format.size,
                from: machO,
                as: format,
                dwarfFormat: dwarfFormat,
                addressSize: addressSize
            ) else { fatalError() }
            return .indirect(value)
        case .sec_offset:
            switch dwarfFormat {
            case ._32bit:
                let address: UInt32 = try! machO.fileHandle.read(offset: offset)
                return .sec_offset(.init(address: numericCast(address)))
            case ._64bit:
                let address: UInt64 = try! machO.fileHandle.read(offset: offset)
                return .sec_offset(.init(address: address))
            }
        case .exprloc:
            let (length, lengthSize) = machO.fileHandle.readULEB128(
                baseOffset: numericCast(offset)
            )
            let data = try! machO.fileHandle.readData(
                offset: offset + lengthSize,
                length: numericCast(length)
            )
            return .exprloc(
                .init(length: numericCast(length), data: data)
            )
        case .flag_present:
            return .flag_present
        case .strx:
            let (index, _) = machO.fileHandle.readULEB128(
                baseOffset: numericCast(offset)
            )
            return .strx(.init(index: numericCast(index)))
        case .addrx:
            let (index, _) = machO.fileHandle.readULEB128(
                baseOffset: numericCast(offset)
            )
            return .addrx(.init(index: numericCast(index)))
        case .ref_sup4:
            return .ref_sup4(.init(_offset: try! machO.fileHandle.read(offset: offset)))
        case .strp_sup:
            switch dwarfFormat {
            case ._32bit:
                let address: UInt32 = try! machO.fileHandle.read(offset: offset)
                return .strp_sup(.init(offset: numericCast(address)))
            case ._64bit:
                let address: UInt64 = try! machO.fileHandle.read(offset: offset)
                return .strp_sup(.init(offset: address))
            }
        case .data16:
            let data1: UInt64 = try! machO.fileHandle.read(offset: offset)
            let data2: UInt64 = try! machO.fileHandle.read(offset: offset + 8)
            return .data16(.init(value: (data1, data2)))
        case .line_strp:
            switch dwarfFormat {
            case ._32bit:
                let address: UInt32 = try! machO.fileHandle.read(offset: offset)
                return .line_strp(.init(offset: numericCast(address)))
            case ._64bit:
                let address: UInt64 = try! machO.fileHandle.read(offset: offset)
                return .line_strp(.init(offset: address))
            }
        case .ref_sig8:
            return .ref_sig8(.init(_offset: try! machO.fileHandle.read(offset: offset)))
        case .implicit_const(let constant):
            return .implicit_const(.init(value: constant))
        case .loclistx:
            let (offset, _) = machO.fileHandle.readULEB128(
                baseOffset: numericCast(offset)
            )
            return .loclistx(.init(offset: numericCast(offset)))
        case .rnglistx:
            let (offset, _) = machO.fileHandle.readULEB128(
                baseOffset: numericCast(offset)
            )
            return .rnglistx(.init(offset: numericCast(offset)))
        case .ref_sup8:
            return .ref_sup8(.init(_offset: try! machO.fileHandle.read(offset: offset)))
        case .strx1:
            let index: UInt8 = try! machO.fileHandle.read(offset: offset)
            return .strx1(.init(index: numericCast(index)))
        case .strx2:
            let index: UInt16 = try! machO.fileHandle.read(offset: offset)
            return .strx2(.init(index: numericCast(index)))
        case .strx3:
            // ref: https://github.com/llvm/llvm-project/blob/f205e354ae3e002158060c830778d8c5409a9984/llvm/include/llvm/Support/DataExtractor.h#L28
            let bytes: (UInt8, UInt8, UInt8) = try! machO.fileHandle.read(
                offset: offset
            )
            if machO.endian == .little {
                return .strx3(
                    .init(
                        index: numericCast(bytes.0) + (numericCast(bytes.1) << 8) + (numericCast(bytes.2) << 16)
                    )
                )
            } else {
                return .strx3(
                    .init(
                        index: numericCast(bytes.2) + (numericCast(bytes.1) << 8) + (numericCast(bytes.0) << 16)
                    )
                )
            }
        case .strx4:
            let index: UInt32 = try! machO.fileHandle.read(offset: offset)
            return .strx4(.init(index: numericCast(index)))
        case .addrx1:
            let index: UInt8 = try! machO.fileHandle.read(offset: offset)
            return .addrx1(.init(index: numericCast(index)))
        case .addrx2:
            let index: UInt16 = try! machO.fileHandle.read(offset: offset)
            return .addrx2(.init(index: numericCast(index)))
        case .addrx3:
            let bytes: (UInt8, UInt8, UInt8) = try! machO.fileHandle.read(
                offset: offset
            )
            if machO.endian == .little {
                return .addrx3(
                    .init(
                        index: numericCast(bytes.0) + (numericCast(bytes.1) << 8) + (numericCast(bytes.2) << 16)
                    )
                )
            } else {
                return .addrx3(
                    .init(
                        index: numericCast(bytes.2) + (numericCast(bytes.1) << 8) + (numericCast(bytes.0) << 16)
                    )
                )
            }
        case .addrx4:
            let index: UInt32 = try! machO.fileHandle.read(offset: offset)
            return .addrx4(.init(index: numericCast(index)))
        case .gnu_addr_index:
            let (index, _) = machO.fileHandle.readULEB128(
                baseOffset: numericCast(offset)
            )
            return .gnu_addr_index(.init(index: numericCast(index)))
        case .gnu_str_index:
            let (offset, _) = machO.fileHandle.readULEB128(
                baseOffset: numericCast(offset)
            )
            return .gnu_str_index(.init(index: numericCast(offset)))
        case .gnu_ref_alt:
            switch dwarfFormat {
            case ._32bit:
                let address: UInt32 = try! machO.fileHandle.read(offset: offset)
                return .gnu_ref_alt(numericCast(address))
            case ._64bit:
                let address: UInt64 = try! machO.fileHandle.read(offset: offset)
                return .gnu_ref_alt(address)
            }
        case .gnu_strp_alt:
            switch dwarfFormat {
            case ._32bit:
                let address: UInt32 = try! machO.fileHandle.read(offset: offset)
                return .gnu_strp_alt(numericCast(address))
            case ._64bit:
                let address: UInt64 = try! machO.fileHandle.read(offset: offset)
                return .gnu_strp_alt(address)
            }
        case .llvm_addrx_offset:
            let (high, size) = machO.fileHandle.readULEB128(
                baseOffset: numericCast(offset)
            )
            let low: UInt32 = try! machO.fileHandle.read(
                offset: offset + numericCast(size)
            )
            return .llvm_addrx_offset(numericCast(high) << 32 | numericCast(low))
        }
    }
}

extension DWARFAttributeValue {
    public func value(
        for unit: DWARFCompilationUnit,
        in machO: MachOFile
    ) -> Any? {
        switch self {
        case .addr(let uInt64):
            return uInt64
        case .block2(let block):
            return block.data
        case .block4(let block):
            return block.data
        case .data2(let constant):
            return constant.value
        case .data4(let constant):
            return constant.value
        case .data8(let constant):
            return constant.value
        case .string(let string):
            return string
        case .block(let block):
            return block.data
        case .block1(let block):
            return block.data
        case .data1(let constant):
            return constant.value
        case .flag(let flag):
            return flag.value
        case .sdata(let constant):
            return constant.value
        case .strp(let refString):
            guard let strings = machO.dwarf.strings else {
                return nil
            }
            return strings.string(
                at: numericCast(refString.offset)
            )?.string
        case .udata(let constant):
            return constant.value
        case .ref_addr(let reference):
            return debugInfoEntry(reference, for: unit, in: machO, isInSameUnit: false)
        case .ref1(let reference):
            return debugInfoEntry(reference, for: unit, in: machO, isInSameUnit: true)
        case .ref2(let reference):
            return debugInfoEntry(reference, for: unit, in: machO, isInSameUnit: true)
        case .ref4(let reference):
            return debugInfoEntry(reference, for: unit, in: machO, isInSameUnit: true)
        case .ref8(let reference):
            return debugInfoEntry(reference, for: unit, in: machO, isInSameUnit: true)
        case .ref_udata(let reference):
            return debugInfoEntry(reference, for: unit, in: machO, isInSameUnit: true)
        case .indirect(let dWARFAttributeValue):
            return dWARFAttributeValue.value(for: unit, in: machO)
        case .sec_offset(let ptr):
            return nil
        case .exprloc(let exprLoc):
            return nil
        case .flag_present:
            return true
        case .strx(let indexedString):
            return string(from: indexedString, in: machO)
        case .addrx(let indexedAddress):
            return address(from: indexedAddress, in: machO)
        case .ref_sup4(let reference):
            return nil
        case .strp_sup(let refString):
            return nil
        case .data16(let constant):
            return constant.value
        case .line_strp(let refString):
            guard let strings = machO.dwarf.lineStrings else {
                return nil
            }
            return strings.string(
                at: numericCast(refString.offset)
            )?.string
        case .ref_sig8(let reference):
            return nil
        case .implicit_const(let constant):
            return constant
        case .loclistx(let locList):
            return nil
        case .rnglistx(let rngList):
            return nil
        case .ref_sup8(let reference):
            return nil
        case .strx1(let indexedString):
            return string(from: indexedString, in: machO)
        case .strx2(let indexedString):
            return string(from: indexedString, in: machO)
        case .strx3(let indexedString):
            return string(from: indexedString, in: machO)
        case .strx4(let indexedString):
            return string(from: indexedString, in: machO)
        case .addrx1(let indexedAddress):
            return address(from: indexedAddress, in: machO)
        case .addrx2(let indexedAddress):
            return address(from: indexedAddress, in: machO)
        case .addrx3(let indexedAddress):
            return address(from: indexedAddress, in: machO)
        case .addrx4(let indexedAddress):
            return address(from: indexedAddress, in: machO)
        case .gnu_addr_index(let indexedAddress):
            return address(from: indexedAddress, in: machO)
        case .gnu_str_index(let indexedString):
            return string(from: indexedString, in: machO)
        case .gnu_ref_alt(let uInt64):
            return nil
        case .gnu_strp_alt(let uInt64):
            return nil
        case .llvm_addrx_offset(let uInt64):
            let index = uInt64 >> 32
            let offset = uInt64 & 0xffffffff
            guard let address = address(from: .init(index: index), in: machO) else {
                return nil
            }
            return DWARFAddress(
                segmentSelector: address.segmentSelector,
                address: address.address + offset
            )
        }
    }
}

extension DWARFAttributeValue {
    // FIXME: performance & logic
    // addr_base == list.offset - __debug_str_offs.offset + header.layoutSize
    fileprivate func string(
        from indexedString: IndexedString,
        in machO: MachOFile
    ) -> String? {
        let dwarf = machO.dwarf
        let index: Int = numericCast(indexedString.index)

        guard let list = dwarf.stringOffsetsTables.first else { return nil }
        let offsets = Array(list.offsets(in: machO))
        if offsets.indices.contains(index) {
            let offset = offsets[index]
            guard let strings = dwarf.strings,
                  let string = strings.string(at: numericCast(offset)) else {
                return nil
            }
            return string.string
        }
        return nil
    }

    // FIXME: performance & logic
    // addr_base == list.offset - __debug_addr.offset + header.layoutSize
    fileprivate func address(
        from indexedAddress: IndexedAddress,
        in machO: MachOFile
    ) -> DWARFAddress? {
        let dwarf = machO.dwarf
        let index: Int = numericCast(indexedAddress.index)

        guard let list = dwarf.addresses.first else { return nil }
        let addresses = Array(list.addresses(in: machO))
        if addresses.indices.contains(index) {
            return addresses[index]
        }
        return nil
    }

    fileprivate func debugInfoEntry<T>(
        _ reference: Reference<T>,
        for unit: DWARFCompilationUnit,
        in machO: MachOFile,
        isInSameUnit: Bool
    ) -> DWARFDebugInfoEntry? {
        guard let abbreviationsSet = unit.abbreviationsSet(in: machO) else {
            return nil
        }
        if isInSameUnit {
            return .load(
                at: unit.offset + numericCast(reference.offset),
                from: machO,
                dwarfFormat: unit.header.format,
                abbreviationsSet: abbreviationsSet,
                addressSize: unit.header.addressSize
            )
        } else {
            guard let dwarfSegment = machO.dwarfSegment,
                  let __debug_info = dwarfSegment.__debug_info(in: machO) else {
                return nil
            }
            return .load(
                at: __debug_info.offset + numericCast(reference.offset),
                from: machO,
                dwarfFormat: unit.header.format,
                abbreviationsSet: abbreviationsSet,
                addressSize: unit.header.addressSize
            )
        }
    }
}
