//
//  ICardRepository.swift
//  PIKAME
//
//  Created by Matteo Rauch on 20/03/2025.
//

import Foundation

/// Gère le CRUD des cartes, chaque cartes est identifié a partir d'un INT
/// Dans le cas de Card on utilise que read et readAll parce que les card sont des "constantes"
/// permet si jamais un jour on veux que l'utilisateur puisse crée ses propres cartes on a les autres fonctions dispo
protocol ICardRepository : IRepository where T == Card, I == Int {
    func readAll() async -> [Card]
}
