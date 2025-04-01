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
    
    private var card: Card?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func load(card: Card){
        self.card = card
        name.text = card.getName()
        value.text = String(card.getValue())
        
        let imgUI = UIImage(data: card.getImg(), scale: UIScreen.main.scale)
        image.image = imgUI
    }
    
    public func getCard() -> Card?{
        return card
    }

}
