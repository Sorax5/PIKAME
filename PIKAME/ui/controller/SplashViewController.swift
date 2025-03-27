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
            self.loading.stopAnimating()
            // segue names : SplashToMain
            self.performSegue(withIdentifier: "SplashToMain", sender: self)
        }
        
        Application.INSTANCE.loadAll()
        loading!.startAnimating()
        print("dzdzdd")
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
