//
//  BoosterResultViewController.swift
//  PIKAME
//
//  Created by Matteo Rauch on 01/04/2025.
//

import UIKit

class BoosterResultViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var resultCollection: UICollectionView!
    
    public var cards: Array<Card> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibCell = UINib(nibName: "CardViewCell", bundle: nil)
        self.resultCollection.register(nibCell, forCellWithReuseIdentifier: "resultCard")
        
        self.resultCollection.delegate = self
        self.resultCollection.dataSource = self
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resultCard", for: indexPath) as! CardViewCell
        let card = self.cards[indexPath.item]
        cell.load(card: card)
        
        return cell
    }
}
