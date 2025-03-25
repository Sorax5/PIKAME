//
//  OwnedCardDTO.swift
//  PIKAME
//
//  Created by Matteo Rauch on 25/03/2025.
//

import Foundation

struct OwnedCardDTO : Codable {
    let cardI: UUID
    let level: Int
    
    enum CodingKeys: String, CodingKey {
        case cardI = "card"
        case level = "level"
    }
}

