//
//  ELFFile+.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/12
//  
//

import Foundation
@_spi(Support) import ELFKit
import DWARF
package import FileIO
#if canImport(os)
import struct os.OSAllocatedUnfairLock
#endif

fileprivate final class FileHandleHolder: @unchecked Sendable {
    static let shared = FileHandleHolder()

#if canImport(os)
    private let lock: OSAllocatedUnfairLock = .init()
#else
    private let lock: NSRecursiveLock = .init()
#endif

#if canImport(ObjectiveC)
    private let _mapTable: NSMapTable<ELFFile, ELFFile.File> = .weakToStrongObjects()
#else
    private var _mapTable = WeakKeyStrongValueMap<ELFFile, ELFFile.File>()
#endif

    private init() {}

    func fileHandle(
        for machOFile: ELFFile,
        initialize: () -> ELFFile.File
    ) -> ELFFile.File {
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

#if !canImport(ObjectiveC)
final class WeakBox<Value: AnyObject> {
    weak var value: Value?
    let id: ObjectIdentifier

    init(_ value: Value) {
        self.value = value
        self.id = ObjectIdentifier(value)
    }
}

struct WeakKeyStrongValueMap<Key: AnyObject, Value> {
    private var storage: [ObjectIdentifier: (key: WeakBox<Key>, value: Value)] = [:]

    mutating func object(forKey key: Key) -> Value? {
        cleanupIfNeeded()
        return storage[ObjectIdentifier(key)]?.value
    }

    mutating func setObject(_ value: Value, forKey key: Key) {
        cleanupIfNeeded()
        let box = WeakBox(key)
        storage[box.id] = (box, value)
    }

    private mutating func cleanupIfNeeded() {
        storage = storage.filter { $0.value.key.value != nil }
    }
}
#endif

extension ELFFile {
    package typealias File = MemoryMappedFile

    package var fileHandle: File {
        FileHandleHolder.shared.fileHandle(
            for: self,
            initialize: {
                try! .open(url: url, isWritable: false)
            }
        )
    }
}

extension ELFFile {
    package var dwarfSegment: (any DWARFSegment<ELFFile>)? {
        if is64Bit {
            DWARFDummySegment64()
        } else {
            DWARFDummySegment32()
        }
    }
}
