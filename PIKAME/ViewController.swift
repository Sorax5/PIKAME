//
//  ViewController.swift
//  PIKAME
//
//  Created by Matteo Rauch on 20/03/2025.
//

import UIKit

class ViewController: UIViewController {
    
    private var cardService : CardService? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let localFolder : URL = Bundle.main.bundleURL
        let cardRepository = JsonCardRepository(folder: localFolder)
        cardService = CardService(repository: cardRepository)
        
        let card = Card(uniqueId: UUID.init(), name: "Matteo", description: "Rauch", type: 1, value: 1.0, img: "img", rarity: 1)
        
        Task {
            do {
                try await cardService?.create(card: card)
                print("✅ Carte créée")
            }
            catch {
                print("❌ Erreur lors de la création de la carte : \(error)")
            }
        }
        
        cardService?.loadAll()
    
    }


}

