//
//  ShopViewController.swift
//  PIKAME
//
//  Created by Matteo Rauch on 29/03/2025.
//

import UIKit

class ShopViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let boosterPrice = 10
    
    @IBOutlet weak var buyableCardsCollection: UICollectionView!
    
    private var ownedCardService: OwnedCardService?
    private var cardService : CardService?
    private var buyableCards: [OwnedCard] = []
    
    @IBOutlet weak var buyBoosterButton: UIButton!
    @IBOutlet weak var argentLabel: UILabel!
    private var boosterCards: Array<Card> = []
    
    private var moneyObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ownedCardService = Application.INSTANCE.getOwnedCardService()
        self.cardService = Application.INSTANCE.getCardService()
        
        let player = Application.INSTANCE.getPlayer()
        self.updateMoney(player: player!)
        self.updateBooster(player: player!)
        self.moneyObserver = player?.observe(\.money, options: [.old, .new]) { [weak self] player, change in
            self?.updateMoney(player: player)
            self?.updateBooster(player: player)
        }
        
        let nibCell = UINib(nibName: "CardViewCell", bundle: nil)
        buyableCardsCollection.register(nibCell, forCellWithReuseIdentifier: "Cell")
        
        buyableCardsCollection.dataSource = self
        buyableCardsCollection.delegate = self
        
        buyableCardsCollection.backgroundColor = .none
        
        
        
        chooseRandomCard()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.buyableCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CardViewCell
        let card = self.buyableCards[indexPath.row]
        cell.load(card: card)
        
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCardClick)))
        return cell
    }
    
    @objc func onCardClick(sender: UITapGestureRecognizer){
        if let cell = sender.view as? CardViewCell {
            let ownedCard = cell.getCard()
            self.performSegue(withIdentifier: "DetailsBuyCard", sender: ownedCard)
        }
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
        let player = Application.INSTANCE.getPlayer()
        if player!.money < self.boosterPrice {
            return
        }
        
        player!.money -= self.boosterPrice
        
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
    
    private func updateMoney(player: Player){
        self.argentLabel.text = String(player.money) + " Pikacoin"
    }
    
    private func updateBooster(player: Player){
        if player.money < boosterPrice {
            buyBoosterButton.isEnabled = false
            buyBoosterButton.backgroundColor = .red
        }
        else {
            buyBoosterButton.isEnabled = true
            buyBoosterButton.backgroundColor = .systemBlue
        }
        
        buyBoosterButton.titleLabel?.text = "Acheter un booster pour " + String(boosterPrice) + " Pikacoin"
        
    }
}
