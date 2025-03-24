//
//  OwnedCard.swift
//  PIKAME
//
//  Created by Matteo Rauch on 25/03/2025.
//

import Foundation

class OwnedCard {
    private var card : Card
    
    init(card: Card) {
        self.card = card
    }
    
    func getCard() -> Card {
        return card
    }
    
    func toDTO() -> OwnedCardDTO {
        return OwnedCardDTO(cardI: card.uniqueId)
    }
    
    static func fromDTO(_ dto: OwnedCardDTO, using cardService: CardService) throws -> OwnedCard {
        guard let foundCard = cardService.getCard(by: dto.cardI) else {
            throw NSError(domain: "OwnedCard", code: 1, userInfo: [NSLocalizedDescriptionKey: "Card not found for UUID \(dto.cardI)"])
        }
        return OwnedCard(card: foundCard)
    }
}
