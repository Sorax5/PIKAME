//
//  PlayerService.swift
//  PIKAME
//
//  Created by Matteo Rauch on 04/04/2025.
//

import Foundation

typealias OnplayerLoadAction = (Player?) -> Void

class PlayerService {
    private var player: Player?
    private var OwnedCardService: OwnedCardService?
    
    public var OnPlayerLoaded : [OnplayerLoadAction] = []
    
    init(ownedCardService: OwnedCardService) {
        self.player = nil
        self.OwnedCardService = ownedCardService
    }
    
    public func getPlayer() -> Player? {
        return player
    }
    
    public func loadPlayer() async {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "player") {
            do {
                let decoder = JSONDecoder()
                let dto = try decoder.decode(PlayerDTO.self, from: data)
                
                player = Player(dto: dto)
                
                if let firstHeroId = dto.firstHero, let firstHeroCard = OwnedCardService?.getOwnedCard(by: firstHeroId) {
                    player?.firstHero = firstHeroCard
                }
                
                if let secondHeroId = dto.secondHero, let secondHeroCard = OwnedCardService?.getOwnedCard(by: secondHeroId) {
                    player?.secondHero = secondHeroCard
                }
                
                if let objectID = dto.object, let objectCard = OwnedCardService?.getOwnedCard(by: objectID) {
                    player?.object = objectCard
                }
                
            } catch {
                print("Error loading player: \(error)")
            }
        } else {
            player = Player()
            player?.money = 0
        }
        
        player?.money = 50
        
        OnPlayerLoaded.forEach {
            $0(player)
        }
    }
    
    public func savePlayer() {
        guard let player = player else { return }
        
        let defaults = UserDefaults.standard
        let dto = PlayerDTO(money: player.money, firstHero: player.firstHero?.getUniqueId(), secondHero: player.secondHero?.getUniqueId(), object: player.object?.getUniqueId())
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(dto)
            defaults.set(data, forKey: "player")
        }
        catch {
            print("Error saving player: \(error)")
        }
    }
    
    
}
