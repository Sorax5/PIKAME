//
//  IRepository.swift
//  PIKAME
//
//  Created by Matteo Rauch on 20/03/2025.
//

import Foundation

/// Représente un CRUD
protocol IRepository<T,I> {
    /// Model de données associé
    associatedtype T
    /// identifiant auquel le model de données est "identifié"
    associatedtype I

    /// Crée le model de donnée
    func create(_ model: T) async -> Bool
    
    /// Lis le modèle de donnée
    func read(by id: I) async -> T?
    
    /// Met a jour le modèle de donnée
    func update(_ model: T) async -> T?
    
    /// Supprime le modèle de donnée
    func delete(by id: I) async -> Bool
}
