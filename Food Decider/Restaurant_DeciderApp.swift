//
//  Restaurant_DeciderApp.swift
//  Restaurant Decider
//
//  Created by Tyler Davis on 4/27/24.
//

import SwiftUI

@main
struct Restaurant_DeciderApp: App {
    var body: some Scene {
        WindowGroup {
            HomePageView()
        }
        .modelContainer(for: restaurantStore.self)
    }
}
