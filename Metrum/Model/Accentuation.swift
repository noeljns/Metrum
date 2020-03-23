//
//  Accentuation.swift
//  Metrum
//
//  Created by Jonas Zwink on 10.02.20.
//  Copyright © 2020 Jonas Zwink. All rights reserved.
//

import Foundation

// accentuation (engl.) = Betonung (dt.)
enum Accentuation: String, Codable {
    case stressed = "stressed"
    case unstressed = "unstressed"
}
