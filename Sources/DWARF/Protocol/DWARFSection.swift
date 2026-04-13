//
//  DWARFSection.swift
//  swift-dwarf
//
//  Created by p-x9 on 2026/04/04
//  
//

package protocol DWARFSection {
    /// Name of this section
    var sectionName: String { get }
    /// Memory address
    var address: Int { get }
    /// Size in bytes
    var size: Int { get }
    /// File offset
    var offset: Int { get }
    /// Section alignment (power of 2)
    var align: Int { get }
}
