//
//  Player.swift
//  PIKAME
//
//  Created by Matteo Rauch on 25/03/2025.
//

import Foundation

class Player : NSObject {
    @objc dynamic var money : Int
    
    @objc dynamic var firstHero: OwnedCard?
    @objc dynamic var secondHero: OwnedCard?
    @objc dynamic var object: OwnedCard?
    
    init(dto: PlayerDTO) {
        self.money = dto.money
    }
    
    override init() {
        self.money = 0
    }
}
