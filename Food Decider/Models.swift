//
//  Restaurant.swift
//  Food Decider
//
//  Created by Tyler Davis on 11/28/24.
//


import SwiftData

@Model
class Restaurant: Identifiable {
    @Attribute(.unique) var id = UUID()
    var name: String
    var meal: MealType

    init(name: String, meal: MealType) {
        self.name = name
        self.meal = meal
    }
}

enum MealType: String, CaseIterable, Codable, Identifiable {
    case breakfast
    case lunch
    case dinner
    case custom

    var id: String { rawValue }
}
