//
//  IRepository.swift
//  PIKAME
//
//  Created by Matteo Rauch on 20/03/2025.
//

import Foundation

protocol IRepository<T,I> {
    associatedtype T
    associatedtype I

    func create(_ model: T) async -> Bool
    func read(by id: I) async -> T?
    func update(_ model: T) async -> T?
    func delete(by id: I) async -> Bool
}
