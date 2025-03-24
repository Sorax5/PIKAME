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
    
    init(repository: any ICardRepository) {
        self.repository = repository
    }
    
    func loadAll() async {
        if let loadedCards = await repository.readAll() as? [Card] {
            cards = loadedCards
        } else {
            cards = []
        }
    }
    
    func reloadAll() async {
        if let loadedCards = await repository.readAll() as? [Card] {
            cards = loadedCards
        } else {
            cards = []
        }
    }
    
    func getCard(by id: UUID) -> Card? {
        return cards.first { $0.uniqueId == id }
    }
        
    
}

