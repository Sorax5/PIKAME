//
//  UICard.swift
//  PIKAME
//
//  Created by Joris Dubois on 26/03/2025.
//

import UIKit

class UICard: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var valueLabel:UILabel!
    @IBOutlet weak var image:UIImageView!
    @IBOutlet weak var typeLabel:UILabel!
    @IBOutlet weak var boundsView:UIView!
    
    @IBOutlet weak var background: UIView!
    var loadedData : CardDecorator?
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    

    func loadCard(data: CardDecorator){
        let viewFromXib = Bundle.main.loadNibNamed("UICard", owner: self, options:nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        
        loadedData = data
        
        nameLabel.text = data.getName()
        descriptionLabel.text = data.getDescription()
        valueLabel.text = String(data.getValue())
        
        typeLabel.text = Application.INSTANCE.getType(type: data.getType())
        
        
        self.background.backgroundColor = Application.INSTANCE.getRarityColor(rarity: data.getRarity())
        addSubview(viewFromXib)
    }
    
}
