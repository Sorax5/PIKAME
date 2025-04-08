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
