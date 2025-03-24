//
//  ICardRepository.swift
//  PIKAME
//
//  Created by Matteo Rauch on 20/03/2025.
//

import Foundation

protocol ICardRepository : IRepository {
    associatedtype Model = Card
    associatedtype Identifier = UUID
    func readAll() async -> [Model]
}
