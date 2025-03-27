//
//  CardDecorator.swift
//  PIKAME
//
//  Created by Matteo Rauch on 27/03/2025.
//

import Foundation

protocol CardDecorator {
    func getUniqueId() -> UUID
    func getName() -> String
    func getDescription() -> String
    func getType() -> Int
    func getValue() -> Double
    func getRarity() -> Int
    func getImg() -> String
}
