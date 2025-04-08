//
//  ChooseEquipmentCollectionViewController.swift
//  PIKAME
//
//  Created by Matteo Rauch on 08/04/2025.
//

import UIKit

private let reuseIdentifier = "Cell"

class ChooseEquipmentCollectionViewController: UICollectionViewController {
    
    private var cards: [OwnedCard] = []
    private var reason: Int = 0
    
    private var player: Player = Application.INSTANCE.getPlayer()!

    override func viewDidLoad() {
        super.viewDidLoad()

        let nibCell = UINib(nibName: "OwnedCardViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "ownedcard")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func load(reason: Int, cards: [OwnedCard]){
        self.reason = reason
        self.cards = cards
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ownedcard", for: indexPath) as! OwnedCardViewCell
        let card = cards[indexPath.row]
        cell.load(card: card)
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCardClick)))
    
        return cell
    }
    
    @objc func onCardClick(sender: UITapGestureRecognizer){
        if let cell = sender.view as? OwnedCardViewCell {
            if reason == 0 {
                player.firstHero = cell.getCard()
            }
            else if reason == 1 {
                player.secondHero = cell.getCard()
            }
            else if reason == 2 {
                player.object = cell.getCard()
            }
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
