//
//  DWARF3LocationListEntry.swift
//  swift-dwarf
//

import Foundation

/// An entry in the DWARF3/4 `.debug_loc` format. See DWARF4 Section 2.6.2.
public enum DWARF3LocationListEntry: Sendable, Equatable {
    /// Base-relative half-open bounds and the uninterpreted expression bytes.
    /// Empty expressions, zero-length ranges, and overlapping ranges are kept.
    case location(
        beginningOffset: UInt64,
        endOffset: UInt64,
        expression: Data
    )

    /// Selects the base address for subsequent entries.
    case baseAddressSelection(address: UInt64)

    /// Marks the end of this list; no expression follows.
    case endOfList
}
