import SwiftUI
import SwiftData

@main
struct RestaurantDeciderApp: App {
    var body: some Scene {
        WindowGroup {
            HomePageView()
        }
        .modelContainer(for: Restaurant.self)
    }
}
