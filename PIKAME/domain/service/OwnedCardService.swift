//
//  OwnedCardService.swift
//  PIKAME
//
//  Created by Matteo Rauch on 25/03/2025.
//

import Foundation

/// Quand les cartes sont chargés
typealias OwnedCardLoadAction = ([OwnedCard]) -> Void

/// Quand une carte est ajouté dans les carte possédé
typealias OwnedCardAddAction = (OwnedCard) -> Void

/// Gère les cartes que l'ont possède
/// Vus que OwnedCard ne dépend pas de Player on externalise
class OwnedCardService {
    private var repository: any IOwnedCardRepository
    private var ownedCards: [OwnedCard]
    
    public var OnOwnCardLoaded : [OwnedCardLoadAction] = []
    public var OnOwnCardAdded : [OwnedCardAddAction] = []
    
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
    
    func getOwnedCard(by id: Int) -> OwnedCard? {
        return ownedCards.first { $0.getUniqueId() == id }
    }
    
    func create(ownedCard: OwnedCard) {
        Task {
            do {
                let hasCreate = await repository.create(ownedCard)
                if !hasCreate{
                    throw NSError(domain: "OwnedCardService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error creating owned card"])
                }
            } catch {
                print("Error creating owned card \(error)")
            }
        }
        
        ownedCards.append(ownedCard)
        
        OnOwnCardAdded.forEach {
            $0(ownedCard)
        }
    }
    
    func getAll() -> [OwnedCard] {
        return ownedCards
    }
    
    func getByIndex(index: IndexPath) -> OwnedCard? {
        return ownedCards[index.row]
    }
    
    func getByUniqueId(id: Int) -> OwnedCard? {
        return self.ownedCards.first { $0.getUniqueId() == id }
    }
    
    func saveAll() {
        Task {
            for ownedCard in ownedCards {
                _ = await repository.update(ownedCard)
            }
        }
    }
    
    func addCard(card: Card){
        if let ownedCard = getByUniqueId(id: card.getUniqueId()) {
            ownedCard.level += 1
        }
        else {
            let ownedCard = OwnedCard(card: card)
            create(ownedCard: ownedCard)
        }
    }
    
    func filterByType(type: Int) -> [OwnedCard] {
        return ownedCards.filter { $0.getType() == type }
    }
    
}
    
