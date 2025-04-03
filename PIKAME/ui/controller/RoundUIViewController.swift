//
//  RoundUIViewController.swift
//  PIKAME
//
//  Created by Matteo Rauch on 01/04/2025.
//

import UIKit

class RoundUIViewController: UICollectionViewCell {
}

/* https://stackoverflow.com/questions/34215320/use-storyboard-to-mask-uiview-and-give-rounded-corners*/


extension UIView {
    
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
}
