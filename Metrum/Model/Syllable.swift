//
//  Syllable.swift
//  Metrum
//
//  Created by Jonas Zwink on 10.02.20.
//  Copyright © 2020 Jonas Zwink. All rights reserved.
//

import Foundation

// syllable (engl.) = Silbe (dt.)
struct Syllable: Codable {
    let syllableString: String
    let accentuation: Accentuation
    
    enum CodingKeys: String, CodingKey {
        case syllableString
        case accentuation = "accentuation"
    }
}
