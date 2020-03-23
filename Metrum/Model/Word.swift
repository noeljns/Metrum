//
//  Word.swift
//  Metrum
//
//  Created by Jonas Zwink on 10.02.20.
//  Copyright © 2020 Jonas Zwink. All rights reserved.
//

import Foundation

struct Word: Codable {
    let syllables: [Syllable]
    // neglected since "Mitternacht" is as single word daktylus but in a line can be used within a jambus
    // in case of two or more syllables, the word itself has a measure
    // let measureOfWord: Measure
    
    // computed property
    var word: String {
        // concatenate syllableStrings of word
        var str = syllables.reduce("") { $0 + $1.syllableString + "·"}
        // cut last character, so that last middle point is removed from word
        str.removeLast()
        return str
    }
    
    enum CodingKeys: String, CodingKey {
        case syllables = "syllables"
    }
}
