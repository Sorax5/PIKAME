//
//  Card.swift
//  PIKAME
//
//  Created by Matteo Rauch on 20/03/2025.
//

import Foundation

/**
 Représente une carte sérializable
 */
struct CardDTO : Codable {
    public var uniqueId : UUID
    public var name : String
    public var description : String
    public var type : Int
    public var value : Double
    public var img : String
    public var rarity : Int
}
