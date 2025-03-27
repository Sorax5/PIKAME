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
    
    func loadAll() async {
        cards = await repository.readAll()
    }
    
    func getCard(by id: UUID) -> Card? {
        return cards.first { $0.getUniqueId() == id }
    }
    
    func create(card: Card) async throws {
        let hasCreate = await repository.create(card)
        if !hasCreate {
            throw NSError(domain: "CardService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error creating card"])
        }
        cards.append(card)
    }
}

