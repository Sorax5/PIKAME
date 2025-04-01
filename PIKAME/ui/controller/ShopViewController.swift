//
//  ShopViewController.swift
//  PIKAME
//
//  Created by Matteo Rauch on 29/03/2025.
//

import UIKit

class ShopViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var buyableCardsCollection: UICollectionView!
    
    private var ownedCardService: OwnedCardService?
    private var cardService : CardService?
    private var buyableCards: [OwnedCard] = []
    
    private var boosterCards: Array<Card> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ownedCardService = Application.INSTANCE.getOwnedCardService()
        self.cardService = Application.INSTANCE.getCardService()
        
        buyableCardsCollection.dataSource = self
        buyableCardsCollection.delegate = self
        buyableCardsCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        chooseRandomCard()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.buyableCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .systemBlue
        
        let card = self.buyableCards[indexPath.row]
        let imgUI = UIImage(data: card.getImg(), scale: UIScreen.main.scale)
        let imgView = UIImageView(image: imgUI)
        imgView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        cell.addSubview(imgView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = self.buyableCards[indexPath.row]
        self.performSegue(withIdentifier: "DetailsBuyCard", sender: card)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ownedCard = sender as? OwnedCard {
            if let vc = segue.destination as? BuyableCardDataViewController {
                vc.load(card: ownedCard.getCard())
            }
        }
        
        if let boosterView = segue.destination as? BoosterViewController {
            boosterView.cards = self.boosterCards
            self.boosterCards = []
        }
    }

    @IBAction func OnRerollButtonClick(_ sender: Any) {
        chooseRandomCard()
    }
    
    @IBAction func OnBoosterButtonClick(_ sender: Any) {
        self.boosterCards = self.cardService!.openBooster()
        
        for choosedCard in self.boosterCards {
            self.ownedCardService!.addCard(card: choosedCard)
        }
    }
    
    private func chooseRandomCard(){
        self.buyableCards = []
        let ownedCards = self.ownedCardService!.getAll()
        
        if ownedCards.count < 5 {
            self.buyableCards.append(contentsOf: ownedCards)
            return
        }
        
        for _ in 0...5 {
            let randomIndex = Int.random(in: 0..<ownedCards.count)
            self.buyableCards.append(ownedCards[randomIndex])
        }
        
        self.buyableCardsCollection.reloadData()
    }
}
