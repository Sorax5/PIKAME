//
//  IOwnedCardRepository.swift
//  PIKAME
//
//  Created by Matteo Rauch on 25/03/2025.
//

import Foundation

protocol IOwnedCardRepository : IRepository where T == OwnedCard, I == UUID{
    func readAll() async -> [OwnedCard]
}
