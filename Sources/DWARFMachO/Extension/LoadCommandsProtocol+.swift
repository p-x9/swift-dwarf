//
//  LoadCommandsProtocol+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/06/29
//
//

import Foundation
@_spi(Support) import MachOKit

extension LoadCommandsProtocol {
    var dwarf: SegmentCommand? {
        infos(of: LoadCommand.segment)
            .first {
                $0.segname == "__DWARF"
            }
    }

    var dwarf64: SegmentCommand64? {
        infos(of: LoadCommand.segment64)
            .first {
                $0.segname == "__DWARF"
            }
    }
}
