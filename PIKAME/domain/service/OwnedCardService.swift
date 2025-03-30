//
//  OwnedCardService.swift
//  PIKAME
//
//  Created by Matteo Rauch on 25/03/2025.
//

import Foundation

typealias OwnedCardLoadAction = ([OwnedCard]) -> Void

class OwnedCardService {
    private var repository: any IOwnedCardRepository
    private var ownedCards: [OwnedCard]
    
    public var OnOwnCardLoaded : [OwnedCardLoadAction] = []
    
    init(repository: any IOwnedCardRepository) {
        self.repository = repository
        self.ownedCards = []
    }
    
    func loadAll() async {
        ownedCards = await repository.readAll()
        OnOwnCardLoaded.forEach {
            $0(ownedCards)
        }
    }
    
    func getOwnedCard(by id: UUID) -> OwnedCard? {
        return ownedCards.first { $0.getUniqueId() == id }
    }
    
    func create(ownedCard: OwnedCard) {
        Task {
            do {
                let hasCreate = await repository.create(ownedCard)
                if !hasCreate{
                    throw NSError(domain: "OwnedCardService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error creating owned card"])
                }
                ownedCards.append(ownedCard)
            } catch {
                print("Error creating owned card \(error)")
            }
        }
    }
    
    func getAll() -> [OwnedCard] {
        return ownedCards
    }
    
    func getByIndex(index: IndexPath) -> OwnedCard? {
        return ownedCards[index.row]
    }
    
    func saveAll() {
        Task {
            for ownedCard in ownedCards {
                await repository.update(ownedCard)
            }
        }
    }
        
    func hasCard(card: Card) -> Bool {
        return ownedCards.contains { $0.getCard().getUniqueId() == card.getUniqueId() }
    }
    
    func buyCard(card: Card){
        if hasCard(card: card) {
            let ownedCard = ownedCards.first { $0.getCard().getUniqueId() == card.getUniqueId() }
            ownedCard?.level += 1
        }
        else {
            let ownedCard = OwnedCard(card: card)
            create(ownedCard: ownedCard)
        }
    }
    
}
    
