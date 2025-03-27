//
//  OwnedCardsCollectionViewController.swift
//  PIKAME
//
//  Created by Matteo Rauch on 27/03/2025.
//

import UIKit

class OwnedCardsCollectionViewController: UICollectionViewController {
    
    private var ownedCardService : OwnedCardService?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ownedCardService = Application.INSTANCE.getOwnedCardService()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ownedCardService!.getAll().count
    }
}
