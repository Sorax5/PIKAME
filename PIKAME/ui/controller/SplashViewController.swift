//
//  SplashViewController.swift
//  PIKAME
//
//  Created by Matteo Rauch on 28/03/2025.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Application.INSTANCE.OnDataLoaded.append {
            self.onDataLoad()
        }
        
        Application.INSTANCE.loadAll()
        loading!.startAnimating()
    }
    
    private func onDataLoad(){
        self.loading.stopAnimating()
        self.performSegue(withIdentifier: "SplashToMain", sender: self)
    }
}
