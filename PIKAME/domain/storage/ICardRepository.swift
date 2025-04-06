//
//  ICardRepository.swift
//  PIKAME
//
//  Created by Matteo Rauch on 20/03/2025.
//

import Foundation

protocol ICardRepository : IRepository where T == Card, I == Int {
    func readAll() async -> [Card]
}
