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
    
    // " ", ",", ".", "!"
    // let wordSeparators: [String]
}

// examples of input data
//let freu = Syllable(syllableString: "Freu", accentuation: Accentuation.stressed)
//let de = Syllable(syllableString: "de", accentuation: Accentuation.unstressed)
//var freude = Word(syllables: [freu, de])
//let schoe = Syllable(syllableString: "schoe", accentuation: Accentuation.stressed)
//let ner = Syllable(syllableString: "ner", accentuation: Accentuation.unstressed)
//let schoener = Word(syllables: [schoe, ner])
//let goe = Syllable(syllableString: "Goe", accentuation: Accentuation.stressed)
//let tter = Syllable(syllableString: "tter", accentuation: Accentuation.unstressed)
//let fun = Syllable(syllableString: "fun", accentuation: Accentuation.stressed)
//let ken = Syllable(syllableString: "tter", accentuation: Accentuation.unstressed)
//let goetterfunken = Word(syllables: [goe, tter, fun, ken])
//let lineOne = Line(words: [freude, schoener, goetterfunken], measure: Measure.trochaeus, audioFile: "lineOne.mp3")
//var test = lineOne.words[0].syllables[0].accentuation
//
//let so = Syllable(syllableString: "So", accentuation: Accentuation.stressed)
//let nne = Syllable(syllableString: "nne", accentuation: Accentuation.unstressed)
//let sonne = Word(syllables: [so, nne])
//let lineTwo = Line(words: [sonne], measure: Measure.trochaeus, audioFile: "Sonne.mp3")
//
//var ge = Syllable(syllableString: "Ge", accentuation: Accentuation.unstressed)
//var spenst = Syllable(syllableString: "spenst", accentuation: Accentuation.stressed)
//var gespenst = Word(syllables: [ge, spenst])
//let lineThree = Line(words: [gespenst], measure: Measure.jambus, audioFile: "Gespenst.mp3")

