import SwiftUI
import SwiftData

struct HomePageView: View {
    @Environment(\.modelContext) private var context
    @Query var restaurants: [Restaurant]

    @State private var selectedRestaurant: Restaurant?
    @State private var id = 0

    private let colors: [Color] = [.red, .green, .blue, .yellow, .purple, .brown, .cyan, .gray, .indigo, .mint, .orange, .teal]

    func randomRestaurant(for meal: MealType) -> Restaurant? {
        return restaurants.filter { $0.meal == meal }.randomElement()
    }

    func randomAnyRestaurant() -> Restaurant? {
        return restaurants.randomElement()
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Why not try…")
                    .font(.largeTitle.bold())

                Spacer()

                // Logo or fallback
                VStack {
                    if let restaurant = selectedRestaurant {
                        dynamicLogoView(for: restaurant)
                    } else {
                        fallbackSymbolView()
                    }

                    Text(selectedRestaurant?.name ?? "Choose a button below!")
                        .font(.title)
                }
                .id(id)
                .padding()

                // Directions Button
                HStack {
                    Button("Directions") {
                        openDirections()
                    }
                    .buttonStyle(.bordered)
                    .disabled(selectedRestaurant == nil)
                }
                .padding()

                Spacer()

                // Meal Buttons and "Any" Button
                HStack {
                    ForEach(MealType.allCases) { meal in
                        if restaurants.contains(where: { $0.meal == meal }) {
                            Button(meal.rawValue.capitalized) {
                                withAnimation {
                                    selectedRestaurant = randomRestaurant(for: meal)
                                    id += 1
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }

                    if !restaurants.isEmpty {
                        Button("Any") {
                            withAnimation {
                                selectedRestaurant = randomAnyRestaurant()
                                id += 1
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }

                Spacer()

                NavigationLink(destination: EditListsView()) {
                    Text("Edit Lists")
                }
                .buttonStyle(.bordered)
                .padding()

                NavigationLink(destination: AboutView()) {
                    Text("About")
                }
                .font(.footnote)
                .foregroundColor(.gray)
            }
            .padding()
        }
    }

    private func openDirections() {
        guard let selected = selectedRestaurant,
              let encodedName = selected.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "maps://?q=\(encodedName)") else { return }

        UIApplication.shared.open(url)
    }

    // Dynamic logo view: initials inside a circle
    @ViewBuilder
    private func dynamicLogoView(for restaurant: Restaurant) -> some View {
        ZStack {
            Circle()
                .fill(colors.randomElement() ?? .blue)
                .frame(width: 150, height: 150)
            Text(initials(for: restaurant.name))
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
        }
        .shadow(radius: 10)
    }

    // Fallback SF Symbol View
    @ViewBuilder
    private func fallbackSymbolView() -> some View {
        Image(systemName: "fork.knife")
            .font(.system(size: 150))
            .foregroundColor(colors.randomElement() ?? .blue)
    }

    // Extract initials from a name
    private func initials(for name: String) -> String {
        let components = name.split(separator: " ").map { String($0.prefix(1)) }
        return components.prefix(2).joined()
    }
}

#Preview {
    HomePageView()
        .modelContainer(for: Restaurant.self, inMemory: true)
}
