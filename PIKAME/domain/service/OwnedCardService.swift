//
//  OwnedCardService.swift
//  PIKAME
//
//  Created by Matteo Rauch on 25/03/2025.
//

import Foundation

class OwnedCardService {
    private var repository: any IOwnedCardRepository
    private var ownedCards: [OwnedCard]
    
    init(repository: any IOwnedCardRepository) {
        self.repository = repository
        self.ownedCards = []
    }
    
    func loadAll() {
        Task {
            ownedCards = await repository.readAll()
        }
    }
    
    func getOwnedCard(by id: UUID) -> OwnedCard? {
        return ownedCards.first { $0.getCard().uniqueId == id }
    }
}
    
