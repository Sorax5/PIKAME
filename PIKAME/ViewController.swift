//
//  ViewController.swift
//  PIKAME
//
//  Created by Matteo Rauch on 20/03/2025.
//

import UIKit

class ViewController: UIViewController {
    
    private var cardService : CardService? = nil
    private var ownedCardService : OwnedCardService? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let localFolder : URL = Bundle.main.bundleURL
        let cardRepository = JsonCardRepository(folder: localFolder)
        cardService = CardService(repository: cardRepository)
        
        
        
        Task {
            await cardService?.loadAll()

            let ownedCardFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let ownedCardRepository = JsonOwnedCardRepository(cardService: cardService!, saveFolder: ownedCardFolder)

            self.ownedCardService = OwnedCardService(repository: ownedCardRepository)
            await self.ownedCardService?.loadAll()

            let ownedCardAmount = self.ownedCardService?.getAll().count
            print("Owned card amount: \(ownedCardAmount)")

            /*if let card = cardService?.getCard(by: UUID(uuidString: "C076B2A8-79DA-4EF5-A310-3D70A69EDE43")!) {
                let tryOwned = OwnedCard(card: card)
                self.ownedCardService?.create(ownedCard: tryOwned)
            }*/
        }

    }


}

