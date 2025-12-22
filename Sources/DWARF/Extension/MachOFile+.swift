//
//  MachOFile+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2025/12/23
//  
//

import Foundation
@_spi(Support) import MachOKit
internal import FileIO
import struct os.OSAllocatedUnfairLock

fileprivate final class FileHandleHolder: @unchecked Sendable {
    static let shared = FileHandleHolder()

    private let lock: OSAllocatedUnfairLock = .init()
    private let _mapTable: NSMapTable<MachOFile, MachOFile.File> = .weakToStrongObjects()

    private init() {}

    func fileHandle(
        for machOFile: MachOFile,
        initialize: () -> MachOFile.File
    ) -> MachOFile.File {
        lock.lock()
        defer { lock.unlock() }

        if let fileHandle = _mapTable.object(forKey: machOFile) {
            return fileHandle
        } else {
            let fileHandle = initialize()
            _mapTable.setObject(fileHandle, forKey: machOFile)
            return fileHandle
        }
    }
}

extension MachOFile {
    internal typealias File = MemoryMappedFile

    var fileHandle: File {
        FileHandleHolder.shared.fileHandle(
            for: self,
            initialize: {
                try! .open(url: url, isWritable: false)
            }
        )
    }
}
