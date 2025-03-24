//
//  IRepository.swift
//  PIKAME
//
//  Created by Matteo Rauch on 20/03/2025.
//

import Foundation

protocol IRepository {
    associatedtype Model
    associatedtype Identifier

    func create(_ model: Model) async -> Bool
    func read(by id: Identifier) async -> Model?
    func update(_ model: Model) async -> Model?
    func delete(by id: Identifier) async -> Bool
}
