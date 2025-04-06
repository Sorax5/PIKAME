//
//  Player.swift
//  PIKAME
//
//  Created by Matteo Rauch on 25/03/2025.
//

import Foundation

class Player : NSObject {
    @objc dynamic var money : Int
    @objc dynamic var ownedCards : [OwnedCard] = []
    
    init(dto: PlayerDTO, equippedCards: [OwnedCard]) {
        self.money = 0
        self.ownedCards = equippedCards
    }
    
    override init() {
        self.money = 0
    }
}
