//
//  JsonOwnedCardRepository.swift
//  PIKAME
//
//  Created by Matteo Rauch on 25/03/2025.
//

import Foundation



/// Si problème de perf a réecris car pour chaque opération on relit tout le fichier ce qui est pas opti
class JsonOwnedCardRepository: IOwnedCardRepository {
    private var cardService: CardService
    private var saveFolder: URL
    
    init(cardService: CardService, saveFolder: URL) {
        self.cardService = cardService
        self.saveFolder = saveFolder.appendingPathComponent("owned_cards/")
        
        do {
            if !FileManager.default.fileExists(atPath: self.saveFolder.path) {
                try FileManager.default.createDirectory(at: self.saveFolder, withIntermediateDirectories: true, attributes: nil)
            }
        }
        catch {
            print("Error while creating owned card folder: \(error)")
        }
    }
    
    func readAll() -> [OwnedCard] {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: saveFolder, includingPropertiesForKeys: nil)
            
            var ownedCards: [OwnedCard] = []
            
            for fileURL in fileURLs {
                let jsonData = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let dto = try decoder.decode(OwnedCardDTO.self, from: jsonData)
                let card = try OwnedCard.fromDTO(dto, using: cardService)
                ownedCards.append(card)
            }
            
            return ownedCards
        } catch {
            print("Error while reading owned cards: \(error)")
            return []
        }
    }
    
    func create(_ model: OwnedCard) async -> Bool {
        do {
            let fileURL = saveFolder.appendingPathComponent("\(model.getUniqueId()).json")
            
            let dto = model.toDTO()
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(dto)
            
            try jsonData.write(to: fileURL, options: .atomic)
            return true
        } catch {
            print("Error while creating owned card: \(error)")
            return false
        }
    }
    
    func read(by id: Int) async -> OwnedCard? {
        let fileURL = saveFolder.appendingPathComponent("\(id).json")
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let dto = try decoder.decode(OwnedCardDTO.self, from: jsonData)
            return try OwnedCard.fromDTO(dto, using: cardService)
        } catch {
            print("Error while reading owned card by id: \(error)")
            return nil
        }
    }
    
    func update(_ model: OwnedCard) async -> OwnedCard? {
        let fileURL = saveFolder.appendingPathComponent("\(model.getUniqueId()).json")
        
        do {
            let dto = model.toDTO()
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(dto)
            
            try jsonData.write(to: fileURL, options: .atomic)
            return model
        } catch {
            print("Error while updating owned card: \(error)")
            return nil
        }
    }
    
    func delete(by id: Int) async -> Bool {
        let fileURL = saveFolder.appendingPathComponent("\(id).json")
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            return true
        } catch {
            print("Error while deleting owned card: \(error)")
            return false
        }
    }
}

    
