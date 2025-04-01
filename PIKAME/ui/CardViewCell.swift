//
//  CardViewCell.swift
//  PIKAME
//
//  Created by Matteo Rauch on 01/04/2025.
//

import UIKit

class CardViewCell: UICollectionViewCell {

    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var background: RoundUIViewController!
    
    private var card: CardDecorator?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func load(card: CardDecorator){
        self.card = card
        if let currentCard = self.card {
            name.text = currentCard.getName()
            value.text = String(currentCard.getValue())
            
            let imgUI = UIImage(data: currentCard.getImg(), scale: UIScreen.main.scale)
            image.image = imgUI
            
            background.backgroundColor = Application.INSTANCE.getRarityColor(rarity: currentCard.getRarity())
        }
    }
    
    public func getCard() -> CardDecorator?{
        return card
    }
}
