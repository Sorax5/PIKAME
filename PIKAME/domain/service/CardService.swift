//
//  CardService.swift
//  PIKAME
//
//  Created by Matteo Rauch on 24/03/2025.
//

import Foundation

class CardService {
    private var repository : any ICardRepository
    private var cards : [Card] = []
    
    init(repository: some ICardRepository) {
        self.repository = repository
    }
    
    func loadAll() {
        Task {
            cards = await repository.readAll()
            print(cards)
        }
    }
    
    func reloadAll() {
        Task {
            cards = await repository.readAll()
        }
    }
    
    func getCard(by id: UUID) -> Card? {
        return cards.first { $0.uniqueId == id }
    }
    
    func create(card: Card) async throws {
        try await repository.create(card)
    }
        
    
}

