//
//  Application.swift
//  PIKAME
//
//  Created by Matteo Rauch on 27/03/2025.
//

import Foundation

class Application {
    static let INSTANCE = Application()
    
    private let cardService : CardService
    private let ownedCardService : OwnedCardService
    
    init(){
        let localFolder : URL = Bundle.main.bundleURL
        let cardRepository = JsonCardRepository(folder: localFolder)
        self.cardService = CardService(repository: cardRepository)
        
        let ownedCardFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let ownedCardRepository = JsonOwnedCardRepository(cardService: cardService, saveFolder: ownedCardFolder)

        self.ownedCardService = OwnedCardService(repository: ownedCardRepository)
        
        Task {
            await self.cardService.loadAll()
            await self.ownedCardService.loadAll()
        }
    }
    
    public func getCardService() -> CardService {
        return self.cardService
    }
    
    public func getOwnedCardService() -> OwnedCardService {
        return self.ownedCardService
    }
}
