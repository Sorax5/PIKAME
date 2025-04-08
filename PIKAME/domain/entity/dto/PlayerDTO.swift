//
//  PlayerDTO.swift
//  PIKAME
//
//  Created by Matteo Rauch on 04/04/2025.
//

/// Data transfer object du joueur
struct PlayerDTO : Codable {
    /// montant d'argent du joueur
    let money: Int
    
    /// identifiants liés aux la carte possédés
    let firstHero: Int?
    let secondHero: Int?
    let object: Int?
}


