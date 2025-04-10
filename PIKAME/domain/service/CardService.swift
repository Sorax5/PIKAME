//
//  CardService.swift
//  PIKAME
//
//  Created by Matteo Rauch on 24/03/2025.
//

import Foundation

/// Quand les cartes ont terminé de chargé
typealias CardLoadAction = ([Card]) -> Void

/// Charge les cartes définis dans un bundle depuis des fichiers JSON
class CardService : NSObject {
    private var repository : any ICardRepository
    private var cards : [Card] = []
    
    public var OnCardLoaded : [CardLoadAction] = []
    
    /// la rareté de chaque carte
    private let rarityWeights: Array<Double> = [70, 25, 4, 1, 0]
    private let rarityWeightsRare: Array<Double> = [0, 40, 30, 20, 10]
    
    init(repository: some ICardRepository) {
        self.repository = repository
    }
    
    func loadAll() async {
        cards = await repository.readAll()
        
        OnCardLoaded.forEach {
            $0(cards)
        }
    }
    
    func getCard(by id: Int) -> Card? {
        return cards.first { $0.getUniqueId() == id }
    }
    
    func create(card: Card) async throws {
        let hasCreate = await repository.create(card)
        if !hasCreate {
            throw NSError(domain: "CardService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error creating card"])
        }
        cards.append(card)
    }
    

    private func selectRarityWithWeight(isRare: Bool) -> Int {
        var pourcentages = rarityWeights
        if isRare {
            pourcentages = rarityWeightsRare
        }
        
        let randomNumber = Double.random(in: 0...1) * 100
        
        var rarity = 0
        var pourcentageCumule : Double = 0
        for currentPercent in pourcentages {
            pourcentageCumule += Double(currentPercent)
            if randomNumber < pourcentageCumule {
                break
            }else{
                rarity += 1
            }
        }
        return rarity
    }
    
    private func chooseCardOfRarity(rarity: Int) -> Card {
        return self.cards.filter {
            $0.getRarity() == rarity
        }.randomElement()!
    }
    
    private func selectCardWithWeight(isRare: Bool) -> Card {
        let rarity = selectRarityWithWeight(isRare: isRare)
        return chooseCardOfRarity(rarity: rarity)
        
    }
    
    func openBooster() -> [Card] {
        var choosedCards : [Card] = []
        for _ in 0...4 {
            let choosedCard = selectCardWithWeight(isRare: false)
            choosedCards.append(choosedCard)
        }
        choosedCards.append(selectCardWithWeight(isRare: true))
        
        return choosedCards
    }
}

