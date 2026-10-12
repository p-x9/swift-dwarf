//
//  Sequence+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/11/28
//  
//

import Foundation

// MARK: - DWARFLineOperation
extension Sequence<DWARFLineOperation> {
    public func lines(
        header: DWARFLineHeader
    ) -> [DWARFLine] {
        var lines: [DWARFLine] = []
        var state: DWARFLine = .initial(
            defaultOfIsStmt: header.defaultOfIsStmt
        )
        for operation in self {
            switch operation {
            case .specal(let opcode):
                let adjusted = opcode - header.opcodeBase

                let lineIncrement: Int64 = numericCast(header.lineBase) + numericCast(adjusted % header.lineRange)

                let operationAdvance = adjusted / header.lineRange

                state.advanceAddress(
                    operationAdvance: UInt64(operationAdvance),
                    header: header
                )

                state.layout.line = numericCast(
                    Int64(state.line) + lineIncrement
                )

                lines.append(state)

                state.layout.basic_block = false
                state.layout.prologue_end = false
                state.layout.epilogue_begin = false
                state.layout.discriminator = 0

            case .extended(let operation):
                switch operation {
                case .end_sequence:
                    state.layout.end_sequence = true
                    lines.append(state)
                    state = .initial(defaultOfIsStmt: header.defaultOfIsStmt)
                case .set_address(address: let address):
                    state.layout.address = address
                    state.layout.op_index = 0
                case .define_file:
                    break // file defined
                case .set_discriminator(discriminator: let discriminator):
                    state.layout.discriminator = discriminator
                }

            case .standard(let operation):
                switch operation {
                case .copy:
                    lines.append(state)
                    state.layout.basic_block = false
                    state.layout.prologue_end = false
                    state.layout.epilogue_begin = false
                    state.layout.discriminator = 0
                case .advance_pc(pcOffset: let pcOffset):
                    state.advanceAddress(
                        operationAdvance: pcOffset,
                        header: header
                    )
                case .advance_line(lineOffset: let lineOffset):
                    state.layout.line = numericCast(
                        Int64(state.layout.line) + numericCast(lineOffset)
                    )
                case .set_file(file: let file):
                    state.layout.file = file
                case .set_column(column: let column):
                    state.layout.column = column
                case .negate_stmt:
                    state.layout.is_stmt.toggle()
                case .set_basic_block:
                    state.layout.basic_block = true
                case .const_add_pc:
                    let opcode: UInt8 = 255
                    let adjusted = opcode - header.opcodeBase

                    let operationAdvance = adjusted / header.lineRange

                    state.advanceAddress(
                        operationAdvance: UInt64(operationAdvance),
                        header: header
                    )

                case .fixed_advance_pc(pcOffset: let pcOffset):
                    state.layout.address += numericCast(pcOffset)
                    state.layout.op_index = 0
                case .set_prologue_end:
                    state.layout.prologue_end = true
                case .set_epilogue_begin:
                    state.layout.epilogue_begin = true
                case .set_isa(isa: let isa):
                    state.layout.isa = isa
                }

            case .unknownStandard:
                break
            }
        }
        return lines
    }
}

// MARK: - DWARFRangeOperation
fileprivate struct RangeOperationsState {
    var base: DWARFAddress?
    var ranges: [DWARFRange] = []
}

fileprivate func addingRangeOffset(
    _ offset: UInt64,
    to address: UInt64,
    maximumAddress: UInt64
) -> UInt64? {
    let (result, overflow) = address.addingReportingOverflow(offset)
    return !overflow && result <= maximumAddress ? result : nil
}

extension IteratorProtocol<DWARFRangeOperation> {
    /// Consumes one list, including its terminator, leaving subsequent lists unread.
    fileprivate mutating func _nextRanges(
        addressSize: Int,
        initialBaseAddress: @autoclosure () -> DWARFAddress?,
        addressAtIndex: (UInt64) -> DWARFAddress?
    ) -> [DWARFRange]? {
        guard let maximumAddress = DWARFAddress.maximumValue(
            addressSize: addressSize
        ) else { return nil }
        var state = RangeOperationsState()

        while let operation = next() {
            switch operation {
            case .end_of_list:
                return state.ranges

            case .base_addressx(let addressIndex):
                guard let address = addressAtIndex(addressIndex) else {
                    return nil
                }
                state.base = address

            case .startx_endx(let startIndex, let endIndex):
                guard let start = addressAtIndex(startIndex),
                      let end = addressAtIndex(endIndex),
                      start.address <= maximumAddress,
                      end.address <= maximumAddress,
                      start.segmentSelector != end.segmentSelector
                        || end.address >= start.address else {
                    return nil
                }
                state.ranges.append(
                    .init(start: start, end: end)
                )

            case .startx_length(let startIndex, let length):
                guard let start = addressAtIndex(startIndex),
                      let endAddress = addingRangeOffset(
                          length,
                          to: start.address,
                          maximumAddress: maximumAddress
                      ) else {
                    return nil
                }
                state.ranges.append(
                    .init(
                        start: start,
                        end: .init(
                            segmentSelector: start.segmentSelector,
                            address: endAddress
                        )
                    )
                )

            case .offset_pair(let startOffset, let endOffset):
                guard endOffset >= startOffset else { return nil }
                if state.base == nil {
                    state.base = initialBaseAddress()
                }
                guard let base = state.base,
                      let startAddress = addingRangeOffset(
                          startOffset,
                          to: base.address,
                          maximumAddress: maximumAddress
                      ),
                      let endAddress = addingRangeOffset(
                          endOffset,
                          to: base.address,
                          maximumAddress: maximumAddress
                      ) else {
                    return nil
                }
                state.ranges.append(
                    .init(
                        start: .init(
                            segmentSelector: base.segmentSelector,
                            address: startAddress
                        ),
                        end: .init(
                            segmentSelector: base.segmentSelector,
                            address: endAddress
                        )
                    )
                )

            case .base_address(let address):
                state.base = address

            case .start_end(let start, let end):
                guard start.address <= maximumAddress,
                      end.address <= maximumAddress,
                      start.segmentSelector != end.segmentSelector
                        || end.address >= start.address else {
                    return nil
                }
                state.ranges.append(
                    .init(start: start, end: end)
                )

            case .start_length(let start, let length):
                guard let endAddress = addingRangeOffset(
                    length,
                    to: start.address,
                    maximumAddress: maximumAddress
                ) else {
                    return nil
                }
                state.ranges.append(
                    .init(
                        start: start,
                        end: .init(
                            segmentSelector: start.segmentSelector,
                            address: endAddress
                        )
                    )
                )
            }
        }

        return nil
    }
}

extension Sequence<DWARFRangeOperation> {
    package func _ranges(
        addressSize: Int,
        initialBaseAddress: @autoclosure () -> DWARFAddress?,
        addressAtIndex: (UInt64) -> DWARFAddress?
    ) -> [DWARFRange]? {
        var iterator = makeIterator()
        return iterator._nextRanges(
            addressSize: addressSize,
            initialBaseAddress: initialBaseAddress(),
            addressAtIndex: addressAtIndex
        )
    }

    /// Resolves completed lists in order, stopping before the first invalid or unterminated list.
    package func _ranges(
        for unit: DWARFCompilationUnit,
        in binary: some _DWARFBinary
    ) -> [[DWARFRange]] {
        guard unit.header.version == .v5 else { return [] }
        var lists: [[DWARFRange]] = []
        var iterator = makeIterator()
        var context = DWARFListResolutionContext(unit: unit, binary: binary)

        while let ranges = iterator._nextRanges(
            addressSize: unit.header.addressSize,
            initialBaseAddress: context.initialBaseAddress,
            addressAtIndex: { context.address(at: $0) }
        ) {
            lists.append(ranges)
        }
        return lists
    }
}

// MARK: - DWARF3RangeListEntry
extension Sequence<DWARF3RangeListEntry> {
    package func _ranges(
        addressSize: Int,
        initialBaseAddress: @autoclosure () -> DWARFAddress?
    ) -> [DWARFRange]? {
        guard let maximumAddress = DWARFAddress.maximumValue(
            addressSize: addressSize
        ) else { return nil }
        var state = RangeOperationsState()

        for entry in self {
            switch entry {
            case .endOfList:
                return state.ranges

            case .baseAddressSelection(let address):
                state.base = .init(
                    segmentSelector: nil,
                    address: address
                )

            case .range(let beginningOffset, let endOffset):
                if beginningOffset == endOffset {
                    continue
                }
                if state.base == nil {
                    state.base = initialBaseAddress()
                }
                guard let base = state.base,
                      let startAddress = addingRangeOffset(
                          beginningOffset,
                          to: base.address,
                          maximumAddress: maximumAddress
                      ),
                      let endAddress = addingRangeOffset(
                          endOffset,
                          to: base.address,
                          maximumAddress: maximumAddress
                      ) else {
                    return nil
                }
                state.ranges.append(
                    .init(
                        start: .init(
                            segmentSelector: base.segmentSelector,
                            address: startAddress
                        ),
                        end: .init(
                            segmentSelector: base.segmentSelector,
                            address: endAddress
                        )
                    )
                )
            }
        }

        return nil
    }
}

// MARK: - DWARF3LocationListEntry
extension Sequence<DWARF3LocationListEntry> {
    package func _locations(
        addressSize: Int,
        initialBaseAddress: @autoclosure () -> DWARFAddress?,
        descriptions: (Data) -> [DWARFOperation]?
    ) -> [DWARFLocation]? {
        guard let maximumAddress = DWARFAddress.maximumValue(
            addressSize: addressSize
        ) else { return nil }
        var base: DWARFAddress?
        var locations: [DWARFLocation] = []

        for entry in self {
            switch entry {
            case .endOfList:
                return locations
            case .baseAddressSelection(let address):
                base = .init(segmentSelector: nil, address: address)
            case .location(let beginningOffset, let endOffset, let expression):
                guard endOffset >= beginningOffset else { return nil }
                if beginningOffset == endOffset { continue }
                if base == nil { base = initialBaseAddress() }
                guard let base,
                      let start = addingRangeOffset(
                          beginningOffset, to: base.address,
                          maximumAddress: maximumAddress
                      ),
                      let end = addingRangeOffset(
                          endOffset, to: base.address,
                          maximumAddress: maximumAddress
                      ),
                      let operations = descriptions(expression) else {
                    return nil
                }
                locations.append(.init(
                    range: .init(
                        start: .init(segmentSelector: base.segmentSelector, address: start),
                        end: .init(segmentSelector: base.segmentSelector, address: end)
                    ),
                    descriptions: operations
                ))
            }
        }
        return nil
    }
}

// MARK: - DWARFLocationOperation
extension IteratorProtocol<DWARFLocationOperation> {
    /// Consumes one list, including its terminator, leaving subsequent lists unread.
    fileprivate mutating func _nextLocations(
        addressSize: Int,
        initialBaseAddress: @autoclosure () -> DWARFAddress?,
        addressAtIndex: (UInt64) -> DWARFAddress?
    ) -> [DWARFLocation]? {
        guard let maximumAddress = DWARFAddress.maximumValue(
            addressSize: addressSize
        ) else { return nil }
        var base: DWARFAddress?
        var locations: [DWARFLocation] = []

        func location(
            start: DWARFAddress, end: DWARFAddress,
            descriptions: [DWARFOperation]
        ) -> DWARFLocation? {
            guard start.address <= maximumAddress, end.address <= maximumAddress,
                  start.segmentSelector != end.segmentSelector
                    || end.address >= start.address else { return nil }
            return .init(range: .init(start: start, end: end), descriptions: descriptions)
        }

        func endAddress(start: DWARFAddress, length: UInt64) -> DWARFAddress? {
            guard let end = addingRangeOffset(
                length, to: start.address, maximumAddress: maximumAddress
            ) else { return nil }
            return .init(segmentSelector: start.segmentSelector, address: end)
        }

        while let operation = next() {
            switch operation {
            case .end_of_list:
                return locations
            case .base_addressx(let index):
                guard let address = addressAtIndex(index) else { return nil }
                base = address
            case .base_address(let address):
                base = address
            case .startx_endx(let startIndex, let endIndex, let descriptions):
                guard let start = addressAtIndex(startIndex),
                      let end = addressAtIndex(endIndex),
                      let value = location(start: start, end: end, descriptions: descriptions) else {
                    return nil
                }
                locations.append(value)
            case .startx_length(let index, let length, let descriptions):
                guard let start = addressAtIndex(index),
                      let end = endAddress(start: start, length: length),
                      let value = location(start: start, end: end, descriptions: descriptions) else {
                    return nil
                }
                locations.append(value)
            case .offset_pair(let startOffset, let endOffset, let descriptions):
                guard endOffset >= startOffset else { return nil }
                if base == nil { base = initialBaseAddress() }
                guard let base,
                      let start = endAddress(start: base, length: startOffset),
                      let end = endAddress(start: base, length: endOffset),
                      let value = location(start: start, end: end, descriptions: descriptions) else {
                    return nil
                }
                locations.append(value)
            case .default_location(let descriptions):
                // Preserve the existing DWARFLocation.isDefault representation.
                locations.append(.init(
                    range: .init(start: .init(address: 0), end: .init(address: 0)),
                    descriptions: descriptions
                ))
            case .start_end(let start, let end, let descriptions):
                guard let value = location(start: start, end: end, descriptions: descriptions) else {
                    return nil
                }
                locations.append(value)
            case .start_length(let start, let length, let descriptions):
                guard let end = endAddress(start: start, length: length),
                      let value = location(start: start, end: end, descriptions: descriptions) else {
                    return nil
                }
                locations.append(value)
            }
        }
        return nil
    }
}

extension Sequence<DWARFLocationOperation> {
    /// Resolves one list, stopping at its terminator just like the range resolver.
    package func _locations(
        addressSize: Int,
        initialBaseAddress: @autoclosure () -> DWARFAddress?,
        addressAtIndex: (UInt64) -> DWARFAddress?
    ) -> [DWARFLocation]? {
        var iterator = makeIterator()
        return iterator._nextLocations(
            addressSize: addressSize,
            initialBaseAddress: initialBaseAddress(),
            addressAtIndex: addressAtIndex
        )
    }

    /// Resolves completed lists in order, stopping before the first invalid or unterminated list.
    package func _locations(
        for unit: DWARFCompilationUnit,
        in binary: some _DWARFBinary
    ) -> [[DWARFLocation]] {
        guard unit.header.version == .v5 else { return [] }
        var locationLists: [[DWARFLocation]] = []
        var iterator = makeIterator()
        var context = DWARFListResolutionContext(unit: unit, binary: binary)

        while let locations = iterator._nextLocations(
            addressSize: unit.header.addressSize,
            initialBaseAddress: context.initialBaseAddress,
            addressAtIndex: { context.address(at: $0) }
        ) {
            locationLists.append(locations)
        }
        return locationLists
    }
}
