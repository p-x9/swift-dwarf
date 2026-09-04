//
//  UnsafeBufferPointer+.swift
//  swift-dwarf
//

extension UnsafeBufferPointer<UInt8> {
    /// Reads an integer without requiring aligned storage.
    ///
    /// Short inputs are sign- or zero-extended according to T. Invalid widths
    /// or reads outside this buffer return nil without changing nextOffset.
    /// The buffer must refer to valid storage for its entire count and remain
    /// alive for the duration of the call.
    func readFixedWidthInteger<T: FixedWidthInteger>(
        byteCount: Int = T.bitWidth / 8,
        endian: Endian,
        nextOffset: inout Int
    ) -> T? {
        guard nextOffset >= 0, nextOffset <= count,
              byteCount > 0, byteCount <= T.bitWidth / 8,
              byteCount <= count - nextOffset else {
            return nil
        }
        let endOffset = nextOffset + byteCount
        guard let value = T(
            bytes: self[nextOffset..<endOffset],
            endian: endian
        ) else { return nil }
        nextOffset = endOffset
        return value
    }
}
