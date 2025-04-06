//
//  OwnedCardDTO.swift
//  PIKAME
//
//  Created by Matteo Rauch on 25/03/2025.
//

import Foundation

struct OwnedCardDTO : Codable {
    let cardID: Int
    let level: Int
    
    enum CodingKeys: String, CodingKey {
        case cardID = "card"
        case level = "level"
    }
}

