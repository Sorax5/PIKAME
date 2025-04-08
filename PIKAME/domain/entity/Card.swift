//
//  Card.swift
//  PIKAME
//
//  Created by Matteo Rauch on 20/03/2025.
//

import Foundation

/// Représente une carte
class Card : CardDecorator {
    private var uniqueId : Int
    private var name : String
    private var description : String
    private var type : Int
    private var value : Double
    private var img : Data
    private var rarity : Int
    
    init(uniqueId: Int, name: String, description: String, type: Int, value: Double, img: Data, rarity: Int) {
        self.uniqueId = uniqueId
        self.name = name
        self.description = description
        self.type = type
        self.value = value
        self.img = img
        self.rarity = rarity
    }
    
    init(dto: CardDTO, imgData: Data){
        self.uniqueId = dto.uniqueId
        self.name = dto.name
        self.description = dto.description
        self.type = dto.type
        self.value = dto.value
        self.img = imgData
        self.rarity = dto.rarity
    }
    
    func getUniqueId() -> Int {
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
    
    func getImg() -> Data {
        return img
    }
    
    static func fromDTO(dto: CardDTO, imgData : Data) -> Card {
        return Card(dto: dto, imgData: imgData)
    }
        
}
