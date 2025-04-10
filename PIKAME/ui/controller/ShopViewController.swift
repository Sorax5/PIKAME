//
//  ShopViewController.swift
//  PIKAME
//
//  Created by Matteo Rauch on 29/03/2025.
//

import UIKit

/// Gère le shop, les cartes que l'ont peut acheter et les booster
class ShopViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let boosterPrice = 10
    private let REROLL_PRICE = 15
    
    @IBOutlet weak var buyableCardsCollection: UICollectionView!
    
    private var ownedCardService: OwnedCardService?
    private var cardService : CardService?
    private var buyableCards: [OwnedCard] = []
    
    @IBOutlet weak var buyBoosterButton: UIButton!
    @IBOutlet weak var rerollButton: UIButton!
    @IBOutlet weak var argentLabel: UILabel!
    
    @IBAction func rembobiner (_ for: UIStoryboardSegue){
        print("c'est l'heure du rewind")
    }
    
    private var boosterCards: Array<Card> = []
    
    /// Permet de recharger l'ui quand les valeurs d'argent du joueur change
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
            self?.updateReroll(player: player)
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
    
    /// Transition vers un show pour vérifier les détails de la carte/acheter la carte
    @objc func onCardClick(sender: UITapGestureRecognizer){
        if let cell = sender.view as? CardViewCell {
            let ownedCard = cell.getCard()
            self.performSegue(withIdentifier: "DetailsBuyCard", sender: ownedCard)
        }
    }
    
    /// on envoie les données de la carte cliqué
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ownedCard = sender as? OwnedCard {
            if let vc = segue.destination as? BuyableCardDataViewController {
                vc.onDismiss = { data in
                    self.chooseRandomCard()
                }
                vc.load(card: ownedCard.getCard())
            }
        }
        
        if let boosterView = segue.destination as? BoosterViewController {
            boosterView.cards = self.boosterCards
            self.boosterCards = []
        }
    }

    @IBAction func OnRerollButtonClick(_ sender: Any) {
        let player = Application.INSTANCE.getPlayer()
        if player!.money < self.REROLL_PRICE {
            return
        }
        player!.money -= self.REROLL_PRICE
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
    
    /// prend aléatoirement des cartes
    private func chooseRandomCard() {
        self.buyableCards = []
        let ownedCards = self.ownedCardService!.getAll()

        if ownedCards.count < 2 {
            self.buyableCards.append(contentsOf: ownedCards)
            return
        }

        var availableIndices = Array(0..<ownedCards.count)

        for _ in 0..<3 {
            if availableIndices.isEmpty {
                break
            }

            let randomIndex = Int.random(in: 0..<availableIndices.count)
            let selectedIndex = availableIndices.remove(at: randomIndex)
            self.buyableCards.append(ownedCards[selectedIndex])
        }

        self.buyableCardsCollection.reloadData()
    }

    
    private func updateMoney(player: Player){
        self.argentLabel.text = String(player.money) + " Pikacoin ⭐️"
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
        
        buyBoosterButton.titleLabel?.text = "Acheter un booster pour " + String(boosterPrice) + " Pikacoin ⭐️"
    }
    
    private func updateReroll(player: Player){
        if player.money < REROLL_PRICE {
            rerollButton.isEnabled = false
            rerollButton.backgroundColor = .red
        }
        else {
            rerollButton.isEnabled = true
            rerollButton.backgroundColor = .systemBlue
        }
    }

}
