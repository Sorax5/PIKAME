//
//  IOwnedCardRepository.swift
//  PIKAME
//
//  Created by Matteo Rauch on 25/03/2025.
//

import Foundation

/// Gère le CRUD de OwnedCard avec comme identifiant de carte un Int
protocol IOwnedCardRepository : IRepository where T == OwnedCard, I == Int{
    /// permet de récupérer la liste de toutes les cartes en mémoire
    func readAll() async -> [OwnedCard]
}
