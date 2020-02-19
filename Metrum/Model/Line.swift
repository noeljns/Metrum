//
//  Line.swift
//  Metrum
//
//  Created by Jonas Jonas on 10.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import Foundation

// line (engl.) = Vers (dt.)
struct Line: Hashable, Codable {
    let words: [Word]
    let measure: Measure
    let audioFile: String
    
    // computed property
    var line: String {
        // concatenate words to a line
        // https://medium.com/@abhimuralidharan/higher-order-functions-in-swift-filter-map-reduce-flatmap-1837646a63e8
        var str = words.reduce("") { $0 + $1.word + " "}
        // cut last character, so that last space is removed from line
        str.removeLast()
        return str
    }
    
    enum CodingKeys: String, CodingKey {
        case words = "words"
        case measure = "measure"
        case audioFile
    }
    
    // make Line conform to protocol Hashable so that is can be used as Set
    var hashValue: Int {
        return line.hashValue
    }
    
    static func == (lhs: Line, rhs: Line) -> Bool {
        return lhs.line == rhs.line && lhs.measure == rhs.measure && lhs.audioFile == rhs.audioFile
    }
}


