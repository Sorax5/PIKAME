//
//  OwnedCardDataViewController.swift
//  PIKAME
//
//  Created by Matteo Rauch on 28/03/2025.
//

import UIKit

class BuyableCardDataViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var background: UIView!
    
    private var card : Card?
    private var ownedCardService : OwnedCardService?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ownedCardService = Application.INSTANCE.getOwnedCardService()
    
        
        if let ownedCard = card {
            name.text = ownedCard.getName()
            desc.text = ownedCard.getDescription()
            type.text = Application.INSTANCE.getType(type: ownedCard.getType())
            value.text = String(ownedCard.getValue())
            
            let imgUi = UIImage(data: ownedCard.getImg(), scale: UIScreen.main.scale)
            image.image = imgUi
            background.backgroundColor = Application.INSTANCE.getRarityColor(rarity: ownedCard.getRarity())
        }
    }
    
    public func load(card: Card){
        self.card = card
    }
    

    @IBAction func OnBuyCard(_ sender: Any) {
        ownedCardService!.addCard(card: self.card!)
        self.dismiss(animated: true, completion: nil)
    }
}
