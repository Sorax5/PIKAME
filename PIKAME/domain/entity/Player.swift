//
//  Player.swift
//  PIKAME
//
//  Created by Matteo Rauch on 25/03/2025.
//

import Foundation

class Player : NSObject {
    @objc dynamic var money : Int
    
    override init() {
        self.money = 0
    }
}
