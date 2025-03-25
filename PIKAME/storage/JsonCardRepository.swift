//
//  JsonCardRepository.swift
//  PIKAME
//
//  Created by Matteo Rauch on 20/03/2025.
//

import Foundation

/// Cet class as été crée avec l'aide de l'IA
class JsonCardRepository : ICardRepository {
    private var folder : URL
    
    init(folder: URL) {
        self.folder = folder
    }
        
    func readAll() async -> [Card] {
        do {
            guard let bundleFolder = Bundle.main.url(forResource: "cards", withExtension: "bundle") else {
                print("Impossible de trouver le dossier dans le bundle.")
                return []
            }

            let files = try FileManager.default.contentsOfDirectory(at: bundleFolder, includingPropertiesForKeys: nil, options: [])

            let jsonFiles = files.filter { $0.pathExtension == "json" }

            let decoder = JSONDecoder()

            return try jsonFiles.compactMap { url in
                let data = try Data(contentsOf: url)
                return try decoder.decode(Card.self, from: data)
            }
        } catch {
            print("Erreur lors de la lecture des fichiers dans le bundle : \(error)")
            return []
        }
    }
    
    func create(_ model: Card) async -> Bool {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(model)
        // print string content
        print(String(data: data, encoding: .utf8)!)
        let file = getFile(for: model)
        try! data.write(to: file)
        return true
    }
    
    func read(by id: UUID) async -> Card? {
        let file = getFile(for: id)
        guard let data = try? Data(contentsOf: file) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try! decoder.decode(Card.self, from: data)
    }
    
    func update(_ model: Card) async -> Card? {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(model)
        let file = getFile(for: model)
        try! data.write(to: file)
        return model
    }
    
    func delete(by id: UUID) async -> Bool {
        let file = getFile(for: id)
        try? FileManager.default.removeItem(at: file)
        return true
    }
    
    func getFile(for model: Card) -> URL {
        return getFile(for: model.uniqueId)
    }
        
    func getFile(for id: UUID) -> URL {
        return folder.appendingPathComponent("\(id.uuidString).json")
    }
    
}
    
