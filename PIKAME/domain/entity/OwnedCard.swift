//
//  OwnedCard.swift
//  PIKAME
//
//  Created by Matteo Rauch on 25/03/2025.
//

import Foundation

class OwnedCard : NSObject {
    private var card : Card
    
    @objc dynamic var level: Int = 1
    
    init(card: Card) {
        self.card = card
    }
    
    init(card: Card, level: Int) {
        self.card = card
        self.level = level
    }
    
    func getCard() -> Card {
        return card
    }
    
    func toDTO() -> OwnedCardDTO {
        return OwnedCardDTO(cardI: card.uniqueId, level: level)
    }
    
    static func fromDTO(_ dto: OwnedCardDTO, using cardService: CardService) throws -> OwnedCard {
        guard let foundCard = cardService.getCard(by: dto.cardI) else {
            throw NSError(domain: "OwnedCard", code: 1, userInfo: [NSLocalizedDescriptionKey: "Card not found for UUID \(dto.cardI)"])
        }
        return OwnedCard(card: foundCard, level: dto.level)
    }
}
