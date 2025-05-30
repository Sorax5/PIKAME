//
//  OwnedCardDataViewController.swift
//  PIKAME
//
//  Created by Matteo Rauch on 28/03/2025.
//

import UIKit

/// Affiche les données de la carte qu'on possède
class OwnedCardDataViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var effect: UILabel!
    
    @IBOutlet weak var background: UIView!
    private var card : OwnedCard?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        if let ownedCard = card {
            name.text = ownedCard.getName()
            desc.text = ownedCard.getDescription()
            type.text = Application.INSTANCE.getType(type: ownedCard.getType())
 
            let imgUi = UIImage(data: ownedCard.getImg(), scale: UIScreen.main.scale)
            image.image = imgUi
            level.text = "Niveau : " + String(ownedCard.level)
            background.backgroundColor = Application.INSTANCE.getRarityColor(rarity: ownedCard.getRarity())
            
            if ownedCard.getType() == 1 {
                effect.text = "Inflige " + String(ownedCard.getDamage()) + " de dégâts par seconde."
            }
            else {
                effect.text = "Ajoute " + String(ownedCard.getDamage()) + " de dégâts par clic."
            }
        }
    }
    
    public func load(card: OwnedCard){
        self.card = card
    }
}
