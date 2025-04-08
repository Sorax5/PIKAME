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
    
    @IBOutlet weak var firsthero: UIView!
    @IBOutlet weak var object: UIView!
    @IBOutlet weak var secondHero: UIView!
    
    private var onFirstHeroChange: NSKeyValueObservation?
    private var onSecondHeroChange: NSKeyValueObservation?
    private var onObjectChange: NSKeyValueObservation?
    
    var player: Player = Application.INSTANCE.getPlayer()!
    var ownedCardService: OwnedCardService = Application.INSTANCE.getOwnedCardService()
    
    var enemies: Array<EnemyDTO> = []
    var level = 0
    
    @IBOutlet weak var continueButton: UIButton!
    var inFight : Bool = false
    var timer : Timer?
    var maxcountdown: Double = 15
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

    @IBAction func continueClick(_ sender: Any) {
        continueButton.isEnabled = false
        continueButton.isHidden = true
        
        inFight = false
        
        loadLevel(niveau: level)
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

        continueButton.isEnabled = false
        continueButton.isHidden = true
        
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
        
        funsetupUI()
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
    
    @IBAction func MonsterClick(_ sender: UITapGestureRecognizer) {
        if inFight {
            hit()
        } else {
            inFight = true
            startCountdown()
        }
        
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.allowUserInteraction],
                           animations: {
                               self.image.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                               self.image.alpha = 0.7
                           },
                           completion: { _ in
                               UIView.animate(withDuration: 0.1) {
                                   self.image.transform = CGAffineTransform.identity
                                   self.image.alpha = 1.0
                               }
                           })
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
            infoLabel.text = "Gagné ! + \(3 + level) ⭐️ !"
            Application.INSTANCE.getPlayer()?.money += 3 + level
            endFight()
        }
    }
    
    func endFight(){
        timer?.invalidate()
        continueButton.isHidden = false
        continueButton.isEnabled = true
    }
    
    func startCountdown() {
        countdown = maxcountdown
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
    
    private func funsetupUI(){
        self.player = Application.INSTANCE.getPlayer()!
        
        self.firsthero.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickFirstHero(_:))))
        
        self.secondHero.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickSecondHero(_:))))
        
        self.object.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickObject(_:))))
        
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
        self.performSegue(withIdentifier: "OnEquipmentChoose", sender: 0)
    }
    
    @objc func onClickSecondHero(_ sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "OnEquipmentChoose", sender: 1)
    }
    
    @objc func onClickObject(_ sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "OnEquipmentChoose", sender: 2)
    }
    
    private func loadcard(ownedCard: OwnedCard,view: UIView){
        let nib = UINib(nibName: "OwnedCardViewCell", bundle: nil)
        
        if let cell = nib.instantiate(withOwner: nil, options: nil).first as? OwnedCardViewCell {
            cell.load(card: ownedCard)
            view.addSubview(cell)
        }
    }
    
    private func removeCard(view: UIView){
        for subview in view.subviews {
            if let cardView = subview as? OwnedCardViewCell{
                cardView.removeFromSuperview()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChooseEquipmentCollectionViewController {
            if let reason = sender as? Int {
                if reason >= 0 && reason <= 1 {
                    let cards = ownedCardService.filterByType(type: 1)
                    vc.load(reason: reason, cards: cards)
                }
                else if reason >= 2 {
                    let cards = ownedCardService.filterByType(type: 0)
                    vc.load(reason: reason, cards: cards)
                }
                
            }
        }
    }
    
}
