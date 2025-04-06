//
//  JsonCardRepository.swift
//  PIKAME
//
//  Created by Matteo Rauch on 20/03/2025.
//

import Foundation

/// Cet class as été crée avec l'aide de l'IA
class JsonCardRepository : ICardRepository {
    private var cardFolder : URL
    
    init(folder: URL) {
        self.cardFolder = folder
    }
        
    func readAll() async -> [Card] {
        do {
            
            guard let cardBundle = Bundle.main.url(forResource: "data.bundle/cards", withExtension: nil) else {
                print("Impossible de trouver le dossier data/cards dans le bundle.")
                return []
            }
            
            guard let imageBundle = Bundle.main.url(forResource: "data.bundle/images", withExtension: nil) else {
                print("Impossible de trouver le dossier data/images dans le bundle.")
                return []
            }

            let files = try FileManager.default.contentsOfDirectory(at: cardBundle, includingPropertiesForKeys: nil, options: [])
            let jsonFiles = files.filter { $0.pathExtension == "json" }

            let decoder = JSONDecoder()

            return try jsonFiles.compactMap { url in
                let data = try Data(contentsOf: url)
                let dto = try decoder.decode(CardDTO.self, from: data)
                let imagePath = imageBundle.appendingPathComponent(dto.img)
                let imageData = try Data(contentsOf: imagePath)
                return Card.fromDTO(dto: dto, imgData: imageData)
            }
        } catch {
            print("Erreur lors de la lecture des fichiers dans le bundle : \(error)")
            return []
        }
    }
    
    func create(_ model: Card) async -> Bool {
        return true
    }
    
    func read(by id: Int) async -> Card? {
        let file = getFile(for: id)
        guard let data = try? Data(contentsOf: file) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try! decoder.decode(Card.self, from: data)
    }
    
    func update(_ model: Card) async -> Card? {
        return nil
    }
    
    func delete(by id: Int) async -> Bool {
        return true
    }
    
    func getFile(for model: Card) -> URL {
        return getFile(for: model.getUniqueId())
    }
        
    func getFile(for id: Int) -> URL {
        return cardFolder.appendingPathComponent("\(id).json")
    }
    
}
    
