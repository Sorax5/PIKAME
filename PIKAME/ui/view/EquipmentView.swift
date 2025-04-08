//
//  EquipmentView.swift
//  PIKAME
//
//  Created by Matteo Rauch on 08/04/2025.
//

import UIKit

class EquipmentView: UIView {
    
    @IBOutlet weak var firsthero: UIView!
    @IBOutlet weak var object: UIView!
    @IBOutlet weak var secondHero: UIView!
    
    private var onFirstHeroChange: NSKeyValueObservation?
    private var onSecondHeroChange: NSKeyValueObservation?
    private var onObjectChange: NSKeyValueObservation?
    
    private var player: Player!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        funsetupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        funsetupUI()
    }
    
    private func funsetupUI(){
        self.player = Application.INSTANCE.getPlayer()!
        
        self.firsthero.addGestureRecognizer(UITapGestureRecognizer(target: self.firsthero, action: #selector(onClickFirstHero(_:))))
        
        self.secondHero.addGestureRecognizer(UITapGestureRecognizer(target: self.secondHero, action: #selector(onClickSecondHero(_:))))
        
        self.object.addGestureRecognizer(UITapGestureRecognizer(target: self.object, action: #selector(onClickObject(_:))))
        
        self.onFirstHeroChange = player.observe(\.firstHero, options: [.new, .old]) { (card, change) in
            if change.newValue == nil {
                self.removeCard(view: self.firsthero)
            }
            else{
                self.loadcard(ownedCard: change.newValue!!, view: self.firsthero)
            }
            
        }
        
        self.onSecondHeroChange = player.observe(\.secondHero, options: [.new, .old]) { (card, change) in
            if change.newValue == nil {
                self.removeCard(view: self.secondHero)
            }
            else{
                self.loadcard(ownedCard: change.newValue!!, view: self.secondHero)
            }
        }
        
        self.onObjectChange = player.observe(\.object, options: [.new, .old]) { (card, change) in
            if change.newValue == nil {
                self.removeCard(view: self.object)
            }
            else{
                self.loadcard(ownedCard: change.newValue!!, view: self.object)
            }
        }
    }
    
    @objc func onClickFirstHero(_ sender: UITapGestureRecognizer){
        
    }
    
    @objc func onClickSecondHero(_ sender: UITapGestureRecognizer){
        
    }
    
    @objc func onClickObject(_ sender: UITapGestureRecognizer){
        
    }
    
    private func loadcard(ownedCard: OwnedCard,view: UIView){
        let nib = UINib(nibName: "CardViewCell", bundle: nil)
        
        if let cell = nib.instantiate(withOwner: nil, options: nil).first as? CardViewCell {
            cell.load(card: ownedCard)
            view.addSubview(cell)
        }
    }
    
    private func removeCard(view: UIView){
        for subview in view.subviews {
            if let cardView = subview as? CardViewCell{
                cardView.removeFromSuperview()
            }
        }
    }

}
