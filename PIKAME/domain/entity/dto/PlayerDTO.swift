//
//  PlayerDTO.swift
//  PIKAME
//
//  Created by Matteo Rauch on 04/04/2025.
//

/// Data transfer object du joueur
struct PlayerDTO : Codable {
    /// montant d'argent du joueur
    var money: Int
    var level : Int
    
    /// identifiants liés aux la carte possédés
    var firstHero: Int?
    var secondHero: Int?
    var object: Int?
}


