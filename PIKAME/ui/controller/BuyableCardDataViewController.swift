//
//  OwnedCardDataViewController.swift
//  PIKAME
//
//  Created by Matteo Rauch on 28/03/2025.
//

import UIKit

/// Dans le cas ou c'est une carte qui as été selectionné de manière aléatoire et qu'on veux l'acheter
class BuyableCardDataViewController: UIViewController {
    var onDismiss: ((Card) -> Void)?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var buyButton: UIButton!
    
    private var card : Card?
    private var player: Player?
    private var ownedCardService : OwnedCardService?
    
    private var moneyObserver: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ownedCardService = Application.INSTANCE.getOwnedCardService()
        
        self.player = Application.INSTANCE.getPlayer()
            
        if let ownedCard = card {
            name.text = ownedCard.getName()
            desc.text = ownedCard.getDescription()
            type.text = Application.INSTANCE.getType(type: ownedCard.getType())
 
            let imgUi = UIImage(data: ownedCard.getImg(), scale: UIScreen.main.scale)
            image.image = imgUi
            background.backgroundColor = Application.INSTANCE.getRarityColor(rarity: ownedCard.getRarity())
            
            updateButton()
            
            self.moneyObserver = player?.observe(\.money, options: [.old, .new]) { [weak self] player, change in
                self?.updateButton()
            }
        }
    }
    
    private func updateButton(){
        guard let player = self.player else { return }
        guard let ownedCard = self.card else {return}
        
        let cost = Application.INSTANCE.getCardPrice(rarity: ownedCard.getRarity())
        
        buyButton.setTitle("Acheter : \(cost) PikaCoin", for: .normal)
        
        if player.money < cost {
            buyButton.isEnabled = false
            buyButton.backgroundColor = .red
        }
        else {
            buyButton.isEnabled = true
            buyButton.backgroundColor = .systemBlue
        }
        
        buyButton.layer.cornerRadius = 10
        buyButton.layer.masksToBounds = true
    }
    
    public func load(card: Card){
        self.card = card
    }
    

    @IBAction func OnBuyCard(_ sender: Any) {
        ownedCardService!.addCard(card: self.card!)
        self.player?.money -= Application.INSTANCE.getCardPrice(rarity: card!.getRarity())
        
        self.onDismiss?(self.card!)
        
        if let nv = self.navigationController {
            nv.popViewController(animated: true)
        }
    }
    
}
