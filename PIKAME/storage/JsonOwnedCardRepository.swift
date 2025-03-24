//
//  JsonOwnedCardRepository.swift
//  PIKAME
//
//  Created by Matteo Rauch on 25/03/2025.
//

import Foundation

/// Si problème de perf a réecris car pour chaque opération on relit tout le fichier ce qui est pas opti
class JsonOwnedCardRepository : IOwnedCardRepository {
    private var cardService: CardService
    private var saveFile: URL
    
    init(cardService: CardService, saveFolder: URL) {
        self.cardService = cardService
        self.saveFile = saveFolder.appendingPathComponent("owned_cards.json")
    }
    
    func readAll() async -> [OwnedCard] {
        do {
            guard FileManager.default.fileExists(atPath: saveFile.path) else {
                print("Owned cards file not found")
                return []
            }
            
            let jsonData = try Data(contentsOf: saveFile)
            let decoder = JSONDecoder()
            let dtos = try decoder.decode([OwnedCardDTO].self, from: jsonData)
            
            return try dtos.map { dto in
                return try OwnedCard.fromDTO(dto, using: cardService)
            }
        }
        catch {
            print("Error while reading owned cards: \(error)")
            return []
        }
    }
    
    func create(_ model: OwnedCard) async -> Bool {
        do {
            var ownedCards = await readAll()
            ownedCards.append(model)
            
            let dtos = ownedCards.map { $0.toDTO() }
            try save(dtos)
            return true
        }
        catch{
            print("Error while creating owned card: \(error)")
            return false
        }
    }
    
    func read(by id: UUID) async -> OwnedCard? {
        let ownedCards = await readAll()
        return ownedCards.first { $0.getCard().uniqueId == id }
    }
    
    func update(_ model: OwnedCard) async -> OwnedCard? {
        do {
            var ownedCards = await readAll()
            if let index = ownedCards.firstIndex(where: { $0.getCard().uniqueId == model.getCard().uniqueId }) {
                ownedCards[index] = model
                let dtos = ownedCards.map { $0.toDTO() }
                try save(dtos)
                return model
            }
        } catch {
            print("Error while updating owned card: \(error)")
        }
        return nil
    }
    
    func delete(by id: UUID) async -> Bool {
        do {
            var ownedCards = await readAll()
            let newCards = ownedCards.filter { $0.getCard().uniqueId != id }
            if newCards.count == ownedCards.count { return false }

            let dtos = newCards.map { $0.toDTO() }
            try save(dtos)
            return true
        } catch {
            print("Error while deleting owned card: \(error)")
            return false
        }
    }
    
    private func save(_ dtos: [OwnedCardDTO]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(dtos)
        try jsonData.write(to: saveFile, options: .atomic)
        print("✅ Données sauvegardées dans \(saveFile.path)")
    }
}
    
