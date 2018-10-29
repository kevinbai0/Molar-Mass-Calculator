//
//  Element.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-04-07.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import Foundation

// element struct for representing an element
struct Element: Codable, Hashable {
    let atomicNumber: Int
    let symbol: String
    let name: String
    let atomicMass: Double
    
    enum CodingKeys: String, CodingKey {
        case symbol
        case name
        case atomicNumber = "number"
        case atomicMass = "atomic_mass"
    }
}
