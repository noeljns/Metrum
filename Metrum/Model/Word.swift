//
//  Word.swift
//  Metrum
//
//  Created by Jonas Jonas on 10.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import Foundation

struct Word: Codable {
    let syllables: [Syllable]

    // in case of two or more syllables, the word itself has a measure
    // verworfen, wegen Mitternacht einzeln Daktylus und z.B. in Vers in Jambus eingebettet
    // let measureOfWord: Measure
    
    // computed property
//    var word: String {
//        // concatenate syllableStrings of word
//        // https://medium.com/@abhimuralidharan/higher-order-functions-in-swift-filter-map-reduce-flatmap-1837646a63e8
//        var str = syllables.reduce("") { $0 + $1.syllableString + "·"}
//        // cut last character, so that last middle point is removed from word
//        str.removeLast()
//        return str
//    }
    
    enum CodingKeys: String, CodingKey {
        case syllables = "syllables"
    }
    
    func getWord() -> String {
        // concatenate syllableStrings of word
        // https://medium.com/@abhimuralidharan/higher-order-functions-in-swift-filter-map-reduce-flatmap-1837646a63e8
        var str = syllables.reduce("") { $0 + $1.syllableString + "·"}
        // cut last character, so that last middle point is removed from word
        str.removeLast()
        return str
    }
}
