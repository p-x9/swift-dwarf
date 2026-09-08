//
//  DWARF3RangeListEntry.swift
//  swift-dwarf
//

/// An entry in the `.debug_ranges` format introduced in DWARF3.
///
/// The same format is retained by DWARF4. See DWARF4 Section 2.17.3.
public enum DWARF3RangeListEntry: Sendable, Equatable {
    /// A half-open range whose bounds are relative to the applicable base
    /// address of the compilation unit.
    case range(beginningOffset: UInt64, endOffset: UInt64)

    /// Selects the base address used by subsequent range entries in this list.
    case baseAddressSelection(address: UInt64)

    /// Marks the end of this range list.
    case endOfList
}
