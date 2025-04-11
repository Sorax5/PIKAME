//
//  InFightViewController.swift
//  PIKAME
//
//  Created by Joris Dubois on 01/04/2025.
//

import UIKit

class InFightViewController: UIViewController {

    // Iboutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var dpsLabel: UILabel!
    @IBOutlet weak var hpBar: UIProgressView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    // Equipements
    @IBOutlet weak var firsthero: UIView!
    @IBOutlet weak var object: UIView!
    @IBOutlet weak var secondHero: UIView!
    
    // Observers
    private var onFirstHeroChange: NSKeyValueObservation?
    private var onSecondHeroChange: NSKeyValueObservation?
    private var onObjectChange: NSKeyValueObservation?
    
    var player: Player = Application.INSTANCE.getPlayer()!
    var ownedCardService: OwnedCardService = Application.INSTANCE.getOwnedCardService()
    
    var enemies: Array<EnemyDTO> = []
    var currentLevel = 0
    var inFight : Bool = false
    var timer : Timer?
    var maxcountdown: Double = 15
    var countdown : Double = 15
    var hp : Double = 0
    var maxhp : Double = 0
    var clickDamage : Int = 1
    var dpsDamage : Int = 0
    var maxlevel : Int = 0
    
    /*
        Pour rajouter plus de contenu au jeu, on renomme les monstres qu'on boucle.
        Si par exemple on a que deux images de monstres : "Slime" et "Loup"
        Le tableau suivant permettra de les renommer.
        "Slime", puis "Loup", puis on boucle donc "Slime le retour", "Loup le retour", "Slime adulte", ...
        1er argument = prefix, 2e argument = suffix
     */
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
    
    /**
            Fonction de calcul des points de vie des monstres selon le niveau. On peut ajuster aisément la difficulté en augmentant / réduisant le 1.25
     */
    func getHp(niveau: Int) -> Int {
        return Int(30.0 * pow(1.25, Double(niveau)))
    }
    
    /**
            Recupere les objets / heros équipés et en calcule les dégats totaux par clics / seconde
     */
    func getClickDamage() -> Int {
        var additionnalDamage = 0
        if let heros = player.object {
            additionnalDamage = heros.getDamage()
        }
        return 1+additionnalDamage
    }
    
    func getDpsDamage() -> Int {
        var damage = 0
        if let firstHero = player.firstHero {
            damage += firstHero.getDamage()
        }
        if let secondHero = player.secondHero {
            damage += secondHero.getDamage()
        }
        return damage
    }
    
    /**
            Lis les informations du fichier enemies.json, contenant la liste des noms d'ennemis + la référence d'asset de leur image
     */
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
    
    /**
            Charge en vue le niveau mis en paramètre.
     */
    func loadLevel(niveau: Int) {
        currentLevel = niveau
        let qualif = qualificatif[(niveau/enemies.count) % qualificatif.count] // pour avoir le bon qualificatif à partir du niveau.
        hp = Double(getHp(niveau: niveau))
        maxhp = hp
        nameLabel.text = qualif[0] + enemies[niveau % enemies.count].name + qualif[1]
        infoLabel.text = "Niveau \(niveau+1)"
        image.image = UIImage(named: enemies[niveau % enemies.count].image)
        
        updateLabels()
    }

    override func viewWillDisappear(_ animated: Bool) {
        // Evite d'avoir un combat qui se déroule quand le joueur ne regarde pas la vue.
        endFight()
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
            currentLevel = player.level
            maxlevel = enemies.count * qualificatif.count - 1
        } else {
            print("Échec du chargement des ennemis")
        }

        // Ajout des events de clics
        firsthero.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickFirstHero(_:))))
        secondHero.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickSecondHero(_:))))
        object.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickObject(_:))))
        
        // Ajouts des observeurs
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
        
        // Update si une carte est déjà équipée.
        if let firstHero = player.firstHero{
            self.loadcard(ownedCard: firstHero, view: self.firsthero)
        }
        
        if let secondHero = player.secondHero{
            self.loadcard(ownedCard: secondHero, view: self.secondHero)
        }
        
        if let object = player.object{
            self.loadcard(ownedCard: object, view: self.object)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadLevel(niveau: currentLevel)
    }

    /**
            Gestion du swipe pour changer le niveau actuel.
     */
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if continueButton.isEnabled {return}
        if inFight {return}
        
        switch gesture.direction {
        case .left:
            if currentLevel == player.level {
                currentLevel = 0
            }else{
                currentLevel += 1
            }
            loadLevel(niveau: currentLevel)
        case .right:
            if currentLevel == 0 {
                currentLevel = player.level
            }else{
                currentLevel -= 1
            }
            loadLevel(niveau: currentLevel)
        default:
            break
        }
    }
    
    /**
            Animation lorsque le monstre se fait toucher, on réduit et réaggrandit l'image + on baisse et réaugmente son opacité.
     */
    func animateHit(){
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.allowUserInteraction], // delay:0 et .allowUserInteraction permettent de ne pas empecher le clic malgré l'animation de dégats.
                           animations: {
                               self.image.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                               self.image.alpha = 0.7
                           },
                           completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction]) {
                                   self.image.transform = CGAffineTransform.identity
                                   self.image.alpha = 1.0
                               }
                           })
    }
    
    
    /**
            Est appelé lorsqu'un monstre est cliqué.
     */
    @IBAction func MonsterClick(_ sender: UITapGestureRecognizer) {
        if continueButton.isEnabled {return}
        
        if inFight {
            hp -= Double(clickDamage)
            updateLabels()
        } else {
            // Commence le combat
            inFight = true
            clickDamage = getClickDamage()
            dpsDamage = getDpsDamage()
            countdown = maxcountdown
            // L'intervalle est mis à 0,01 pour que l'affichage du timer soit plus précis et update plus souvent les dégats par seconde.
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        }
        animateHit()
    }
    
    func updateLabels(){
        hpLabel.text = "\(Int(hp)) / \(Int(maxhp))"
        dpsLabel.text = "\(dpsDamage) dégâts / seconde"
        hpBar.progress = Float(hp) / Float(maxhp)
        
        if hp < 1 {
            endFight()
        }
    }
    
    func endFight(){
        if !inFight {return}
        timer?.invalidate()
        continueButton.isHidden = false
        continueButton.isEnabled = true
        inFight = false
        
        if hp < 1 {
            hp = 0
            hpBar.progress = 0
            
            print("pipi")
            infoLabel.text = "Gagné ! + \(3 + currentLevel) ⭐️ !"
            
            player.money += 3 + currentLevel
            
            if currentLevel == player.level { // niveau max du joueur battu
                if currentLevel != maxlevel { // il reste un niveau à proposer
                    player.level += 1 // level up !
                    currentLevel = player.level
                    Application.INSTANCE.getPlayerService().savePlayer()
                }
            }
        } else {
            infoLabel.text = "Perdu ! :("
        }
        
    }
    
    @objc func updateCountdown() {
        countdown -= 0.01
        hp -= Double(dpsDamage) / 100 // degats passifs, divisé par 100 car update 100x par seconde.
        updateLabels()
        if hp < 1 || countdown <= 0 {
            endFight()
        }else{
            infoLabel.text = "\(String(format: "%.2f", countdown)) secondes restantes !"
        }
    }
    
    @IBAction func continueClick(_ sender: Any) {
        continueButton.isEnabled = false
        continueButton.isHidden = true
        loadLevel(niveau: currentLevel)
    }
    
    
    @objc func onClickFirstHero(_ sender: UITapGestureRecognizer){
        if inFight {return}
        self.performSegue(withIdentifier: "OnEquipmentChoose", sender: 0)
    }
    
    @objc func onClickSecondHero(_ sender: UITapGestureRecognizer){
        if inFight {return}
        self.performSegue(withIdentifier: "OnEquipmentChoose", sender: 1)
    }
    
    @objc func onClickObject(_ sender: UITapGestureRecognizer){
        if inFight {return}
        self.performSegue(withIdentifier: "OnEquipmentChoose", sender: 2)
    }
    
    // Ajoute la carte sélectionnée à la vue
    private func loadcard(ownedCard: OwnedCard,view: UIView){
        let nib = UINib(nibName: "OwnedCardViewCell", bundle: nil)
        if let cell = nib.instantiate(withOwner: nil, options: nil).first as? OwnedCardViewCell {
            cell.load(card: ownedCard)
            view.addSubview(cell)
        }
    }
    // Retire l'ancienne carte sélectionnée de la vue
    private func removeCard(view: UIView){
        for subview in view.subviews {
            if let cardView = subview as? OwnedCardViewCell{
                cardView.removeFromSuperview()
            }
        }
    }
    
    // Gestion de la transition.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChooseEquipmentCollectionViewController {
            if let reason = sender as? Int {
                if reason >= 0 && reason <= 1 {
                    var cards = ownedCardService.filterByType(type: 1)
                    if let firstHero = player.firstHero {
                        cards.removeAll { $0 == firstHero }
                    }
                    if let secondHero = player.secondHero {
                        cards.removeAll { $0 == secondHero }
                    }
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
