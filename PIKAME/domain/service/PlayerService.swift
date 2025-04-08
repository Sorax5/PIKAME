//
//  PlayerService.swift
//  PIKAME
//
//  Created by Matteo Rauch on 04/04/2025.
//

import Foundation

/// Callback appellé quand le joueur a terminé de charger ses données
typealias OnplayerLoadAction = (Player?) -> Void

/// S'occuper des actions en rapport avec le joueur,
/// n'utilise pas de Repository car pas eu le temps
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
    
    /// Charge les données du joueur de façons asynchrone
    /// On utilise les UserDefaults
    /// On récupère le json de player pour le déserializer en DTO
    /// On récupère les cardes équipé par le joueur pour simplifier l'accès.
    public func loadPlayer() async {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "player") {
            do {
                let decoder = JSONDecoder()
                var dto = try decoder.decode(PlayerDTO.self, from: data)
                dto.firstHero = 0
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
        }
        
        OnPlayerLoaded.forEach {
            $0(player)
        }
    }
    
    /// Sauvegarde le json du player dans les UserDefaults
    public func savePlayer() {
        guard let player = player else { return }
        
        let defaults = UserDefaults.standard
        var dto = PlayerDTO(money: player.money, level:player.level, firstHero: player.firstHero?.getUniqueId(), secondHero: player.secondHero?.getUniqueId(), object: player.object?.getUniqueId())
        
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
