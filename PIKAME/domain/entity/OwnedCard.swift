//
//  OwnedCard.swift
//  PIKAME
//
//  Created by Matteo Rauch on 25/03/2025.
//

import Foundation

class OwnedCard : NSObject, CardDecorator {
    
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
    
    func getUniqueId() -> UUID {
        return card.getUniqueId()
    }
    
    func getName() -> String {
        return card.getName()
    }
    
    func getDescription() -> String {
        return card.getDescription()
    }
    
    func getType() -> Int {
        return card.getType()
    }
    
    func getValue() -> Double {
        return card.getValue()
    }
    
    func getRarity() -> Int {
        return card.getRarity()
    }
    
    func getImg() -> Data {
        return card.getImg()
    }
    
    func toDTO() -> OwnedCardDTO {
        return OwnedCardDTO(cardID: card.getUniqueId(), level: level)
    }
    
    static func fromDTO(_ dto: OwnedCardDTO, using cardService: CardService) throws -> OwnedCard {
        guard let foundCard = cardService.getCard(by: dto.cardID) else {
            throw NSError(domain: "OwnedCard", code: 1, userInfo: [NSLocalizedDescriptionKey: "Card not found for UUID \(dto.cardID)"])
        }
        return OwnedCard(card: foundCard, level: dto.level)
    }
}
