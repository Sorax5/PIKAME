//
//  OwnedCardsCollectionViewController.swift
//  PIKAME
//
//  Created by Matteo Rauch on 27/03/2025.
//

import UIKit

let cellName = "OwnedCardViewCell"

/// Permet d'afficher la liste de carte que l'utilisateur possède
class OwnedCardsCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    private var ownedCardService : OwnedCardService?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ownedCardService = Application.INSTANCE.getOwnedCardService()
        
        let nibCell = UINib(nibName: cellName, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: cellName)
        
        errorLabel.isHidden = true
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        errorLabel.isHidden = ownedCardService!.getAll().count != 0
        
        self.collectionView.reloadData()
    }
    
    /// Maximum de carte possédé
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ownedCardService!.getAll().count
    }
    
    /// Ajoute une action quand on clique sur la cell de la carte
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! OwnedCardViewCell
        if let card = ownedCardService!.getByIndex(index: indexPath){
            cell.load(card: card)
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCardClick)))
        }
        return cell
    }
    
    /// fais une transition vers la vue ou on a les détails de la carte
    @objc func onCardClick(sender: UITapGestureRecognizer){
        if let cell = sender.view as? OwnedCardViewCell {
            let ownedCard = cell.getCard()
            self.performSegue(withIdentifier: "OwnedCardCollectionToOwnedCardData", sender: ownedCard)
        }
    }
    
    /// transfere la carte a voir  en détails
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ownedCard = sender as? OwnedCard {
            if let vc = segue.destination as? OwnedCardDataViewController {
                vc.load(card: ownedCard)
            }
        }
    }
    
    private func onOwnedCardAdded(card: OwnedCard) {
        self.collectionView.reloadData()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
            
}
