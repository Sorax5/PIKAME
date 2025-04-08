//
//  OwnedCardDTO.swift
//  PIKAME
//
//  Created by Matteo Rauch on 25/03/2025.
//

import Foundation

struct OwnedCardDTO : Codable {
    /// identifiant unique lié a la carte de base
    let cardID: Int
    
    /// level de la carte (+1 a chaque drop), influence la value de la carte de base
    let level: Int
    
    enum CodingKeys: String, CodingKey {
        case cardID = "card"
        case level = "level"
    }
}

