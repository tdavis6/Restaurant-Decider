import SwiftUI
import SwiftData

struct HomePageView: View {
    @Environment(\.modelContext) private var context
    @Query var restaurants: [Restaurant]

    @State private var selectedRestaurant: Restaurant?
    @State private var id = 0

    func randomRestaurant(for meal: MealType) -> Restaurant? {
        return restaurants.filter { $0.meal == meal }.randomElement()
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Why not try…")
                    .font(.largeTitle.bold())

                Spacer()

                VStack {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 150))
                        .foregroundColor(.blue)
                    Text(selectedRestaurant?.name ?? "Choose a button below!")
                        .font(.title)
                }
                .id(id)
                .padding()

                HStack {
                    Button("Directions") {
                        openDirections()
                    }
                    .buttonStyle(.bordered)
                    .disabled(selectedRestaurant == nil)
                }
                .padding()

                Spacer()

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

    // MARK: - Open Directions
    private func openDirections() {
        guard let selected = selectedRestaurant,
              let encodedName = selected.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "maps://?q=\(encodedName)") else { return }

        UIApplication.shared.open(url)
    }
}

#Preview {
    HomePageView()
        .modelContainer(for: Restaurant.self, inMemory: true)
}
