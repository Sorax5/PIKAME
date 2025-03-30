//
//  Application.swift
//  PIKAME
//
//  Created by Matteo Rauch on 27/03/2025.
//

import Foundation

typealias DataLoaded = () -> Void

class Application {
    static let INSTANCE = Application()
    
    private let cardService : CardService
    private let ownedCardService : OwnedCardService
    
    private let player: Player = Player()
    
    public var OnDataLoaded : [DataLoaded] = []
    
    init(){
        let localFolder : URL = Bundle.main.bundleURL
        let cardRepository = JsonCardRepository(folder: localFolder)
        self.cardService = CardService(repository: cardRepository)
        
        let ownedCardFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let ownedCardRepository = JsonOwnedCardRepository(cardService: cardService, saveFolder: ownedCardFolder)

        self.ownedCardService = OwnedCardService(repository: ownedCardRepository)
    }
    
    public func loadAll() {
        Task {
            await self.cardService.loadAll()
            await self.ownedCardService.loadAll()
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.OnDataLoaded.forEach { $0() }
            }
        }
    }
        
    
    public func getCardService() -> CardService {
        return self.cardService
    }
    
    public func getOwnedCardService() -> OwnedCardService {
        return self.ownedCardService
    }
    
    public func getPlayer() -> Player {
        return self.player
    }
}
