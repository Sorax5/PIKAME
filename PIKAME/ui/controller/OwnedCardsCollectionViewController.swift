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
        
        let nibCell = UINib(nibName: "OwnedCardCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "ownedcard")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ownedCardService!.getAll().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ownedcard", for: indexPath) as! OwnedCardCollectionViewCell
        if let card = ownedCardService!.getByIndex(index: indexPath){
            cell.load(card: card)
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCardClick)))
        }
    
        return cell

    }
    
    @objc func onCardClick(sender: UITapGestureRecognizer){
        if let cell = sender.view as? OwnedCardCollectionViewCell {
            let ownedCard = cell.getCard()
            self.performSegue(withIdentifier: "OwnedCardCollectionToOwnedCardData", sender: ownedCard)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ownedCard = sender as? OwnedCard {
            if let vc = segue.destination as? OwnedCardDataViewController {
                vc.load(card: ownedCard)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
            
}
