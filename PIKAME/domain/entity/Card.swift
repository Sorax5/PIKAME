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
class Card : Codable, CardDecorator {
    private var uniqueId : UUID
    private var name : String
    private var description : String
    private var type : Int
    private var value : Double
    private var img : String
    private var rarity : Int
    
    init(uniqueId: UUID, name: String, description: String, type: Int, value: Double, img: String, rarity: Int) {
        self.uniqueId = uniqueId
        self.name = name
        self.description = description
        self.type = type
        self.value = value
        self.img = img
        self.rarity = rarity
    }
    
    func getUniqueId() -> UUID {
        return uniqueId
    }
    
    func getName() -> String {
        return name
    }
    
    func getDescription() -> String {
        return description
    }
    
    func getType() -> Int {
        return type
    }
    
    func getValue() -> Double {
        return value
    }
    
    func getRarity() -> Int {
        return rarity
    }
    
    func getImg() -> String {
        return img
    }
}
