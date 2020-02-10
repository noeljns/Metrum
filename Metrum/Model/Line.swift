//
//  Line.swift
//  Metrum
//
//  Created by Jonas Jonas on 10.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import Foundation

// line (engl.) = Vers (dt.)
struct Line {
    let words: [Word]
    let measureOfLine: Measure
    let wordSeparators: [String] // " ", ",", ".", "!"
}
