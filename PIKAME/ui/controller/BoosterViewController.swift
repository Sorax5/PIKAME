//
//  BoosterViewController.swift
//  PIKAME
//
//  Created by Matteo Rauch on 01/04/2025.
//

import UIKit

class BoosterViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var resultsButton: UIButton!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var currentCardLabel: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var image: UIImageView!
    
    public var cards: Array<Card> = []
    public var currentCardIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsButton.isHidden = true
        nextButton.isHidden = false
        
        let currentCard = self.cards[currentCardIndex]
        loadCard(card: currentCard)
    }
    
    public func loadCard(cards: Array<Card>){
        self.cards = cards
        
        let currentCard = self.cards[currentCardIndex]
        loadCard(card: currentCard)
    }
    
    @IBAction func OnNextClick(_ sender: Any) {
        currentCardIndex += 1
        let currentCard = self.cards[currentCardIndex]
        loadCard(card: currentCard)
        if currentCardIndex >= self.cards.count-1 {
            resultsButton.isHidden = false
            nextButton.isHidden = true
        }
    }
    
    private func loadCard(card: Card){
        name.text = card.getName()
        desc.text = card.getDescription()
        type.text = Application.INSTANCE.getType(type: card.getType())
        value.text = String(card.getValue())
        
        let imgUi = UIImage(data: card.getImg(), scale: UIScreen.main.scale)
        image.image = imgUi
        
        background.backgroundColor = Application.INSTANCE.getRarityColor(rarity: card.getRarity())
        
        
        
        self.currentCardLabel.text = "Carte numéro " + String(self.currentCardIndex + 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? BoosterResultViewController {
            view.cards = self.cards
        }
    }
}
