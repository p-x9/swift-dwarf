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
                let adjusted = opcode - header.opecodeBase

                let lineIncrement: Int64 = numericCast(header.lineBase) + numericCast(adjusted % header.lineRange)

                let operationAdvance = adjusted / header.lineRange

                state.layout.address += numericCast(header.minimumInstructionLength)
                * ((numericCast(state.op_index) + numericCast(operationAdvance))) / numericCast(header.maximumOperationsPerInstruction)

                state.layout.op_index = (state.op_index + numericCast(operationAdvance)) % numericCast(header.maximumOperationsPerInstruction)

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
                    state.layout.address += numericCast(pcOffset) * numericCast(header.minimumInstructionLength)
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
                    let adjusted = opcode - header.opecodeBase

                    let operationAdvance = adjusted / header.lineRange

                    state.layout.address += numericCast(header.minimumInstructionLength)
                    * ((numericCast(state.op_index) + numericCast(operationAdvance))) / numericCast(header.maximumOperationsPerInstruction)

                    state.layout.op_index = (state.op_index + numericCast(operationAdvance)) % numericCast(header.maximumOperationsPerInstruction)

                case .fixed_advance_pc(pcOffset: let pcOffset):
                    state.layout.address += numericCast(pcOffset)
                case .set_prologue_end:
                    state.layout.prologue_end = true
                case .set_epilogue_begin:
                    state.layout.epilogue_begin = true
                case .set_isa(isa: let isa):
                    state.layout.isa = isa
                }
            }
        }
        return lines
    }
}

// MARK: - DWARFRangeOperation
fileprivate struct RangeOperationsState {
    var base: DWARFAddress = .init(segmentSelector: nil, address: 0)
    var ranges: [DWARFRange] = []
}

extension Sequence<DWARFRangeOperation> {
    package func _ranges(
        addressTable: DWARFAddressTable,
        in binary: some _DWARFBinary
    ) -> [[DWARFRange]] {
        var rangeLists: [[DWARFRange]] = []
        var state: RangeOperationsState = .init()

        let addresses = Array(addressTable._addresses(in: binary))

        for operation in self {
            switch operation {
            case .end_of_list:
                rangeLists.append(state.ranges)
                state = .init()

            case .base_addressx(let addressIndex):
                state.base = addresses[numericCast(addressIndex)]

            case .startx_endx(let startIndex, let endIndex):
                state.ranges.append(
                    .init(
                        start: addresses[numericCast(startIndex)],
                        end: addresses[numericCast(endIndex)]
                    )
                )

            case .startx_length(let startIndex, let length):
                let start = addresses[numericCast(startIndex)]
                state.ranges.append(
                    .init(
                        start: start,
                        end: .init(
                            segmentSelector: start.segmentSelector,
                            address: start.address + numericCast(length)
                        )
                    )
                )

            case .offset_pair(let startOffset, let endOffset):
                state.ranges.append(
                    .init(
                        start: .init(
                            segmentSelector: state.base.segmentSelector,
                            address: state.base.address + startOffset
                        ),
                        end: .init(
                            segmentSelector: state.base.segmentSelector,
                            address: state.base.address + endOffset
                        )
                    )
                )

            case .base_address(let address):
                state.base = address

            case .start_end(let start, let end):
                state.ranges.append(
                    .init(start: start, end: end)
                )

            case .start_length(let start, let length):
                state.ranges.append(
                    .init(
                        start: start,
                        end: .init(
                            segmentSelector: start.segmentSelector,
                            address: start.address + length
                        )
                    )
                )
            }
        }

        return rangeLists
    }
}

// MARK: - DWARFLocationOperation
fileprivate struct LocationOperationsState {
    var base: DWARFAddress = .init(segmentSelector: nil, address: 0)
    var locations: [DWARFLocation] = []
}

extension Sequence<DWARFLocationOperation> {
    package func _locations(
        addressTable: DWARFAddressTable,
        in binary: some _DWARFBinary
    ) -> [[DWARFLocation]] {
        var locationLists: [[DWARFLocation]] = []
        var state: LocationOperationsState = .init()

        let addresses = Array(addressTable._addresses(in: binary))

        for operation in self {
            switch operation {
            case .end_of_list:
                locationLists.append(state.locations)
                state = .init()

            case .base_addressx(let addressIndex):
                state.base = addresses[numericCast(addressIndex)]

            case .startx_endx(let startIndex, let endIndex, let descriptions):
                state.locations.append(
                    .init(
                        range: .init(
                            start: addresses[numericCast(startIndex)],
                            end: addresses[numericCast(endIndex)]
                        ),
                        descriptions: descriptions
                    )
                )

            case .startx_length(let startIndex, let length, let descriptions):
                let start = addresses[numericCast(startIndex)]
                state.locations.append(
                    .init(
                        range: .init(
                            start: start,
                            end: .init(
                                segmentSelector: start.segmentSelector,
                                address: start.address + numericCast(length)
                            )
                        ),
                        descriptions: descriptions
                    )
                )

            case .offset_pair(let startOffset, let endOffset, let descriptions):
                state.locations.append(
                    .init(
                        range: .init(
                            start: .init(
                                segmentSelector: state.base.segmentSelector,
                                address: state.base.address + startOffset
                            ),
                            end: .init(
                                segmentSelector: state.base.segmentSelector,
                                address: state.base.address + endOffset
                            )
                        ),
                        descriptions: descriptions
                    )
                )

            case .default_location(let descriptions):
                state.locations.append(
                    .init(
                        range: .init(
                            start: .init(address: 0),
                            end: .init(address: 0)
                        ), // dummy
                        descriptions: descriptions
                    )
                )

            case .base_address(let address):
                state.base = address

            case .start_end(let start, let end, let descriptions):
                state.locations.append(
                    .init(
                        range: .init(start: start, end: end),
                        descriptions: descriptions
                    )
                )

            case .start_length(let start, let length, let descriptions):
                state.locations.append(
                    .init(
                        range: .init(
                            start: start,
                            end: .init(
                                segmentSelector: start.segmentSelector,
                                address: start.address + length
                            )
                        ),
                        descriptions: descriptions
                    )
                )
            }
        }

        return locationLists
    }
}
