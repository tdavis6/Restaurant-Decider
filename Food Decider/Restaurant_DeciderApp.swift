import SwiftUI
import SwiftData

@main
struct Restaurant_DeciderApp: App {
    var body: some Scene {
        WindowGroup {
            HomePageView()
                .modelContainer(for: Restaurant.self)
        }
    }
}
