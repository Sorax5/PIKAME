//
//  CardViewCell.swift
//  PIKAME
//
//  Created by Matteo Rauch on 01/04/2025.
//

import UIKit

class OwnedCardViewCell: UICollectionViewCell {

    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var background: UIView!
    
    private var card: OwnedCard?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func load(card: OwnedCard){
        self.card = card
        if let currentCard = self.card {
            name.text = currentCard.getName()
            name.text = currentCard.getName()
            value.text = String(currentCard.getValue())
            
            let imgUI = UIImage(data: currentCard.getImg(), scale: UIScreen.main.scale)
            image.image = imgUI
            
            background.backgroundColor = Application.INSTANCE.getRarityColor(rarity: currentCard.getRarity())
            
            level.text = String(card.level)
        }
    }
    
    public func getCard() -> OwnedCard?{
        return card
    }
}
