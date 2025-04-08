//
//  CardDecorator.swift
//  PIKAME
//
//  Created by Matteo Rauch on 27/03/2025.
//

import Foundation

/// Design pattern de décorator afin de simplifier l'api permet de garder les mêmes fonction pour une card et une ownedCard
protocol CardDecorator {
    func getUniqueId() -> Int
    func getName() -> String
    func getDescription() -> String
    func getType() -> Int
    func getValue() -> Double
    func getRarity() -> Int
    func getImg() -> Data
}
