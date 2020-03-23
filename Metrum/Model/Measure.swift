//
//  Measure.swift
//  Metrum
//
//  Created by Jonas Zwink on 10.02.20.
//  Copyright © 2020 Jonas Zwink. All rights reserved.
//

// measure (engl.) = Versmaß (dt.)
import Foundation

enum Measure: String, Codable {
    case jambus = "jambus"
    case daktylus = "daktylus"
    case trochaeus = "trochaeus"
    case anapaest = "anapaest"
}
