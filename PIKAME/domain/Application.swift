//
//  Application.swift
//  PIKAME
//
//  Created by Matteo Rauch on 27/03/2025.
//

import Foundation
import UIKit

typealias DataLoaded = () -> Void

class Application {
    static let INSTANCE = Application()
    
    private let cardService : CardService
    private let ownedCardService : OwnedCardService
    private let playerService: PlayerService
    
    private let rarity: Array<UIColor> = [
        .white,
        .systemGreen,
        .blue,
        .systemYellow,
        .systemPurple
    ]
    
    private let type: Array<String> = [
        "Equipement",
        "Heros"
    ]
    
    private let price: Array<Int> = [
        5,
        8,
        10,
        15,
        20
    ]
    
    public var OnDataLoaded : [DataLoaded] = []
    
    init(){
        let localFolder : URL = Bundle.main.bundleURL
        let cardRepository = JsonCardRepository(folder: localFolder)
        self.cardService = CardService(repository: cardRepository)
        
        let ownedCardFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let ownedCardRepository = JsonOwnedCardRepository(cardService: cardService, saveFolder: ownedCardFolder)
        
        self.ownedCardService = OwnedCardService(repository: ownedCardRepository)
        
        self.playerService = PlayerService(ownedCardService: self.ownedCardService)
    }
    
    public func loadAll() {
        Task {
            await self.cardService.loadAll()
            await self.ownedCardService.loadAll()
            await self.playerService.loadPlayer()
            
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
    
    public func getPlayer() -> Player? {
        return self.playerService.getPlayer()
    }
    
    public func getRarityColor(rarity: Int) -> UIColor {
        return self.rarity[rarity]
    }
    
    public func getType(type: Int) -> String {
        return self.type[type]
    }
    
    public func getPlayerService() -> PlayerService {
        return self.playerService
    }
    
    public func getCardPrice(rarity: Int) -> Int {
        return self.price[rarity]
    }
}
