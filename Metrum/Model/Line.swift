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
    let measure: Measure
    
    // computed property
    var line: String {
        // concatenate words to a line
        // https://medium.com/@abhimuralidharan/higher-order-functions-in-swift-filter-map-reduce-flatmap-1837646a63e8
        return words.reduce("") { $0 + $1.word + " "}
    }
    
    // " ", ",", ".", "!"
    // let wordSeparators: [String]
}


