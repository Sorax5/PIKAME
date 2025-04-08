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
    
    var player: Player = Application.INSTANCE.getPlayer()!
    
    var enemies: Array<EnemyDTO> = []
    var level = 0
    
    var inFight : Bool = false
    var timer : Timer?
    var countdown : Double = 15
    var hp : Int = 0
    var maxhp : Int = 0
    var clickDamage : Int = 1
    var dpsDamage : Int = 0
    
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
    
    func getClickDamage() -> Int {
        var additionnalDamage = 0
        if let heros = player.object {
           additionnalDamage = Int(heros.getValue())
        }
        return 1+additionnalDamage
    }
    
    func getDpsDamage() -> Int {
        var damage = 0
        if let secondHero = player.secondHero {
            damage += Int(secondHero.getValue())
        }
        if let firstHero = player.firstHero {
            damage += Int(firstHero.getValue())
        }
        return damage
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
        hp = getHp(niveau: niveau)
        maxhp = hp
        nameLabel.text = qualif[0] + enemies[niveau % enemies.count].name + qualif[1]
        infoLabel.text = "Niveau \(niveau+1)"
        image.image = UIImage(named: enemies[niveau % enemies.count].image)
        updateLabels()
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
        if inFight {return}
        
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
    @IBAction func click(_ sender: UITapGestureRecognizer) {
        print("truc")
    }
    
    @IBAction func MonsterClick(_ sender: UITapGestureRecognizer) {
        print("coucou")
        if inFight {
            hit()
        } else {
            inFight = true
            startCountdown()
        }
    }
    
    func initBattle(){
        clickDamage = getClickDamage()
        dpsDamage = getDpsDamage()
    }
    
    func hit(){
        hp -= clickDamage
        updateLabels()
    }
    
    func updateLabels(){
        hpLabel.text = "\(hp) / \(maxhp)"
        dpsLabel.text = "\(dpsDamage) dégats / seconde"
        hpBar.progress = Float(hp) / Float(maxhp)
        
        if hp <= 0 {
            infoLabel.text = "Gagné !"
            endFight()
        }
    }
    
    func endFight(){
        timer?.invalidate()
        inFight = false
        loadLevel(niveau: level)
        Application.INSTANCE.getPlayer()?.money += 3 + level
    }
    
    func startCountdown() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }

    @objc func updateCountdown() {
        countdown -= 0.01
        updateLabels()
        infoLabel.text = "\(String(format: "%.2f", countdown)) secondes restantes !"
        
        if countdown < 0 {
            infoLabel.text = "Perdu ! :("
            endFight()
        }
    }
    
}
