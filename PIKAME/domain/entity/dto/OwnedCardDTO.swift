//
//  OwnedCardDTO.swift
//  PIKAME
//
//  Created by Matteo Rauch on 25/03/2025.
//

import Foundation

struct OwnedCardDTO : Codable {
    let cardI: UUID
    
    enum CodingKeys: String, CodingKey {
        case cardI = "card"
    }
}

