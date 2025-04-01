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
    
    private let rarityWeights: Array<Double> = [0.5, 0.3, 0.15, 0.04, 0.01]
    
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
    
    /// fais avec l'IA le chat
    /// on récupère un dictionnaire de toute les cartes avec leur poids selon la liste des poids
    /// on additione tout les poids
    /// on choisit un poids entre 0 et le total
    /// on prend la carte dans notre dictionnaire de poids
    /// dans le cas ou il y a un problème on prend une carte aléatoire
    private func selectCardWithWeight() -> Card {
        var weightedCards: [(card: Card, weight: Double)] = []

        for card in cards {
            let weight = rarityWeights[card.getRarity()]
            weightedCards.append((card: card, weight: weight))
        }

        let totalWeight = weightedCards.reduce(0) { $0 + $1.weight }
        let randomWeight = Double.random(in: 0..<totalWeight)
        var cumulativeWeight = 0.0

        for (card, weight) in weightedCards {
            cumulativeWeight += weight
            if randomWeight < cumulativeWeight {
                return card
            }
        }

        return cards.randomElement()!
    }
    
    func openBooster() -> [Card] {
        var choosedCards : [Card] = []
        for _ in 0...5 {
            let choosedCard = selectCardWithWeight()
            choosedCards.append(choosedCard)
        }
        
        return choosedCards
    }
}

