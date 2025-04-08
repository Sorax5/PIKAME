//
//  Card.swift
//  PIKAME
//
//  Created by Matteo Rauch on 20/03/2025.
//

import Foundation

/// Représente une carte sérializable Data transfer object
struct CardDTO : Codable {
    /// identifiant de la carte
    public var uniqueId : Int
    public var name : String
    public var description : String
    
    /// Hero = 0, objet = 1
    public var type : Int
    
    /// valeur utilisé dans la partie clicker
    public var value : Double
    public var img : String
    
    /// 0 -> 4
    public var rarity : Int
}
