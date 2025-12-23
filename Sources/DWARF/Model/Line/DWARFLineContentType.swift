//
//  DWARFLineContentType.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/25
//  
//

import DWARFC

public enum DWARFLineContentType: Sendable, CaseIterable {
    /// DW_LNCT_path
    case path
    /// DW_LNCT_directory_index
    case directory_index
    /// DW_LNCT_timestamp
    case timestamp
    /// DW_LNCT_size
    case size
    /// DW_LNCT_MD5
    case md5
    /// DW_LNCT_GNU_subprogram_name
    case gnu_subprogram_name
    /// DW_LNCT_GNU_decl_file
    case gnu_decl_file
    /// DW_LNCT_GNU_decl_line
    case gnu_decl_line
    /// DW_LNCT_LLVM_source
    case llvm_source
    /// DW_LNCT_LLVM_is_MD5
    case llvm_is_md5
}

extension DWARFLineContentType: RawRepresentable {
    public typealias RawValue = UInt64

    public init?(rawValue: RawValue) {
        switch rawValue {
        case numericCast(DW_LNCT_path): self = .path
        case numericCast(DW_LNCT_directory_index): self = .directory_index
        case numericCast(DW_LNCT_timestamp): self = .timestamp
        case numericCast(DW_LNCT_size): self = .size
        case numericCast(DW_LNCT_MD5): self = .md5
        case numericCast(DW_LNCT_GNU_subprogram_name): self = .gnu_subprogram_name
        case numericCast(DW_LNCT_GNU_decl_file): self = .gnu_decl_file
        case numericCast(DW_LNCT_GNU_decl_line): self = .gnu_decl_line
        case numericCast(DW_LNCT_LLVM_source): self = .llvm_source
        case numericCast(DW_LNCT_LLVM_is_MD5): self = .llvm_is_md5
        default: return nil
        }
    }

    public var rawValue: RawValue {
        switch self {
        case .path: numericCast(DW_LNCT_path)
        case .directory_index: numericCast(DW_LNCT_directory_index)
        case .timestamp: numericCast(DW_LNCT_timestamp)
        case .size: numericCast(DW_LNCT_size)
        case .md5: numericCast(DW_LNCT_MD5)
        case .gnu_subprogram_name: numericCast(DW_LNCT_GNU_subprogram_name)
        case .gnu_decl_file: numericCast(DW_LNCT_GNU_decl_file)
        case .gnu_decl_line: numericCast(DW_LNCT_GNU_decl_line)
        case .llvm_source: numericCast(DW_LNCT_LLVM_source)
        case .llvm_is_md5: numericCast(DW_LNCT_LLVM_is_MD5)
        }
    }
}

extension DWARFLineContentType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .path: "DW_LNCT_path"
        case .directory_index: "DW_LNCT_directory_index"
        case .timestamp: "DW_LNCT_timestamp"
        case .size: "DW_LNCT_size"
        case .md5: "DW_LNCT_MD5"
        case .gnu_subprogram_name: "DW_LNCT_GNU_subprogram_name"
        case .gnu_decl_file: "DW_LNCT_GNU_decl_file"
        case .gnu_decl_line: "DW_LNCT_GNU_decl_line"
        case .llvm_source: "DW_LNCT_LLVM_source"
        case .llvm_is_md5: "DW_LNCT_LLVM_is_MD5"
        }
    }
}
