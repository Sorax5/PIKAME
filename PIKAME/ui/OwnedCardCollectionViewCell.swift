//
//  OwnedCardCollectionViewCell.swift
//  PIKAME
//
//  Created by Matteo Rauch on 28/03/2025.
//

import UIKit

class OwnedCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    private var card: OwnedCard?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func load(card: OwnedCard){
        self.card = card
        name.text = card.getName()
        desc.text = card.getDescription()
        
        let imgUI = UIImage(data: card.getImg(), scale: UIScreen.main.scale)
        
        image.image = imgUI
    }
    
    public func getCard() -> OwnedCard?{
        return card
    }

}
