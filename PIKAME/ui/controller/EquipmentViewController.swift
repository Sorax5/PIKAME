//
//  EquipmentViewController.swift
//  PIKAME
//
//  Created by Matteo Rauch on 08/04/2025.
//

import UIKit

class EquipmentViewController: UIViewController {

    @IBOutlet weak var object: UIView!
    @IBOutlet weak var secondHero: UIView!
    @IBOutlet weak var firstHero: UIView!
    
    private var player: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.player = Application.INSTANCE.getPlayer()!
        
        let firstHeroTap = UITapGestureRecognizer(target: self, action: #selector(firtHeroTap(_:)))
        self.firstHero.addGestureRecognizer(firstHeroTap)
        self.firstHero.isUserInteractionEnabled = true
        
        let secondHeroTap = UITapGestureRecognizer(target: self, action: #selector(secondHeroTap(_:)))
        self.secondHero.addGestureRecognizer(secondHeroTap)
        self.secondHero.isUserInteractionEnabled = true
        
        let objectTap = UITapGestureRecognizer(target: self, action: #selector(objectTap(_:)))
        self.object.addGestureRecognizer(objectTap)
        self.object.isUserInteractionEnabled = true
        
        updateLoadedCard()
    }
    
    @objc func firtHeroTap(_ sender: UITapGestureRecognizer)
    {
        print("La vue a été tapée !")
    }
    
    @objc func secondHeroTap(_ sender: UITapGestureRecognizer)
    {
        print("La vue a été tapée !")
    }
    
    @objc func objectTap(_ sender: UITapGestureRecognizer)
    {
        print("La vue a été tapée !")
    }
    
    private func updateLoadedCard() {
        guard let player = self.player else { return }
        
        if let firstHero = player.firstHero {
            let nib = UINib(nibName: "CardViewCell", bundle: nil)
            
            if let cell = nib.instantiate(withOwner: nil, options: nil).first as? CardViewCell {
                cell.load(card: firstHero)
                self.firstHero.addSubview(cell)
            }
        }
        
        if let secondHero = player.secondHero {
            let nib = UINib(nibName: "CardViewCell", bundle: nil)
            
            if let cell = nib.instantiate(withOwner: nil, options: nil).first as? CardViewCell {
                cell.load(card: secondHero)
                self.secondHero.addSubview(cell)
            }
        }
        
        if let object = player.object {
            let nib = UINib(nibName: "CardViewCell", bundle: nil)
            
            if let cell = nib.instantiate(withOwner: nil, options: nil).first as? CardViewCell {
                cell.load(card: object)
                self.object.addSubview(cell)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
