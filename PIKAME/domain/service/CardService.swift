//
//  CardService.swift
//  PIKAME
//
//  Created by Matteo Rauch on 24/03/2025.
//

import Foundation

typealias CardLoadAction = ([Card]) -> Void

class CardService : NSObject {
    private var repository : any ICardRepository
    private var cards : [Card] = []
    
    public var OnCardLoaded : [CardLoadAction] = []
    
    init(repository: some ICardRepository) {
        self.repository = repository
    }
    
    func loadAll() async {
        cards = await repository.readAll()
        
        OnCardLoaded.forEach {
            $0(cards)
        }
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
    
    func openBooster() -> [Card] {
        var choosedCards : [Card] = []
        for _ in 0...4 {
            let randomIndex = Int.random(in: 0..<cards.count)
            let choosedCard = self.cards[randomIndex]
            choosedCards.append(choosedCard)
        }
        
        return choosedCards
    }
}

