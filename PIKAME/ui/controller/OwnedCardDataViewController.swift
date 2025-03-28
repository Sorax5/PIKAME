//
//  OwnedCardDataViewController.swift
//  PIKAME
//
//  Created by Matteo Rauch on 28/03/2025.
//

import UIKit

class OwnedCardDataViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var value: UILabel!
    
    private var card : OwnedCard?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let ownedCard = card {
            name.text = ownedCard.getName()
            desc.text = ownedCard.getDescription()
            type.text = String(ownedCard.getType())
            value.text = String(ownedCard.getValue())
            image.image = UIImage(data: ownedCard.getImg())
        }
            
    }
    
    public func load(card: OwnedCard){
        self.card = card
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
