//
//  InFightViewController.swift
//  PIKAME
//
//  Created by Joris Dubois on 01/04/2025.
//

import UIKit

class InFightViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var dpsLabel: UILabel!
    @IBOutlet weak var hpBar: UIProgressView!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var heros1: UIImageView!
    @IBOutlet weak var heros2: UIImageView!
    @IBOutlet weak var heros3: UIImageView!
    
    var enemies: Array<EnemyDTO> = []
    var level = 0
    
    var qualificatif : Array<Array<String>> = [
        ["",""],
        [""," le retour"],
        [""," Adulte"],
        ["Puissant ",""],
        ["Le Grand ",""],
        ["Le Général ",""],
        [""," Originel"],
        [""," Véritable"],
        [""," Absolue"],
        ["Le ","."]
    ]
    
    func getHp(niveau: Int) -> Int {
        return Int(30.0 * pow(1.07, Double(niveau)))
    }

    
    func loadEnemies() -> [EnemyDTO]? {
        guard let bundleURL = Bundle.main.url(forResource: "data", withExtension: "bundle"),
              let bundle = Bundle(url: bundleURL),
              let jsonURL = bundle.url(forResource: "enemies/enemies", withExtension: "json") else {
            print("Erreur : Impossible de trouver le fichier enemies.json")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: jsonURL)
            let decoder = JSONDecoder()
            let enemies = try decoder.decode([EnemyDTO].self, from: data)
            return enemies
        } catch {
            print("Erreur lors du décodage JSON : \(error)")
            return nil
        }
    }
    
    func loadLevel(niveau: Int) {
        let qualif = qualificatif[(niveau/enemies.count) % qualificatif.count]
        let hp = getHp(niveau: niveau)
        nameLabel.text = qualif[0] + enemies[niveau % enemies.count].name + qualif[1]
        hpLabel.text = "\(hp) / \(hp)"
        dpsLabel.text = "0 dégats / seconde"
        hpBar.progress = 1.0
        infoLabel.text = "Niveau \(niveau+1)"
        image.image = UIImage(named: enemies[niveau % enemies.count].image)
        
        //@IBOutlet weak var image: UIImageView!
        
        /*@IBOutlet weak var heros1: UIImageView!
        @IBOutlet weak var heros2: UIImageView!
        @IBOutlet weak var heros3: UIImageView!*/
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        if let data = loadEnemies() {
            enemies = data
            loadLevel(niveau: level)
            
        } else {
            print("Échec du chargement des ennemis")
        }
    }

    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            if level == enemies.count * qualificatif.count - 1 {
                level = 0
            }else{
                level += 1
            }
            loadLevel(niveau: level)
        case .right:
            if level == 0 {
                level = enemies.count * qualificatif.count - 1
            }else{
                level -= 1
            }
            loadLevel(niveau: level)
        default:
            break
        }
    }
    
}
