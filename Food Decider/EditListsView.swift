import SwiftUI
import SwiftData

struct EditListsView: View {
    @Environment(\.modelContext) private var context
    @Query var restaurants: [Restaurant]

    @State private var newRestaurantName: String = ""
    @State private var selectedMeal: MealType = .breakfast
    @State private var editMode: EditMode = .inactive

    // Define the focusable fields
    enum Field: Hashable {
        case newRestaurantName
        case editRestaurantName(Restaurant)
    }

    // Focus state property
    @FocusState private var focusedField: Field?

    var body: some View {
        VStack {
            // Add Restaurant Section
            VStack(spacing: 8) {
                Text("Add a Restaurant")
                    .font(.title3.weight(.bold))
                    .foregroundColor(.blue)

                TextField("Restaurant name", text: $newRestaurantName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .focused($focusedField, equals: .newRestaurantName) // Bind focus state

                HStack {
                    Menu("Meal: \(selectedMeal.rawValue.capitalized)") {
                        ForEach(MealType.allCases) { meal in
                            Button(meal.rawValue.capitalized) {
                                selectedMeal = meal
                            }
                        }
                    }
                    .menuStyle(.button)

                    Button("Add") {
                        addRestaurant()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newRestaurantName.isEmpty)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .cornerRadius(10)
            .padding()

            // List of Restaurants with Inline Editing and Reordering
            List {
                ForEach(MealType.allCases) { meal in
                    Section(header: Text(meal.rawValue.capitalized)) {
                        ForEach(restaurants.filter { $0.meal == meal }) { restaurant in
                            HStack {
                                TextField(
                                    "Edit name",
                                    text: Binding(
                                        get: { restaurant.name },
                                        set: { newName in
                                            updateRestaurant(restaurant, with: newName)
                                        }
                                    )
                                )
                                .font(.body)
                                .foregroundColor(.primary)
                                .textFieldStyle(.plain)
                                .focused($focusedField, equals: .editRestaurantName(restaurant)) // Bind focus state
                            }
                        }
                        .onDelete { indexSet in
                            deleteRestaurants(at: indexSet, for: meal)
                        }
                        .onMove { source, destination in
                            moveRestaurants(from: source, to: destination, for: meal)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .toolbar {
                EditButton()
            }
            .environment(\.editMode, $editMode)
        }
        .onTapGesture {
            focusedField = nil // Dismiss the keyboard when background is tapped
        }
        .navigationTitle("Edit Restaurants")
    }

    // MARK: - Add Restaurant
    private func addRestaurant() {
        guard !newRestaurantName.isEmpty else { return }
        let newRestaurant = Restaurant(name: newRestaurantName, meal: selectedMeal)
        
        withAnimation(.easeInOut(duration: 0.3)) {
            context.insert(newRestaurant)
        }
        
        newRestaurantName = ""
    }

    // MARK: - Update Restaurant
    private func updateRestaurant(_ restaurant: Restaurant, with newName: String) {
        restaurant.name = newName // Directly update the model
    }

    // MARK: - Delete Restaurants
    private func deleteRestaurants(at offsets: IndexSet, for meal: MealType) {
        let filtered = restaurants.filter { $0.meal == meal }
        withAnimation(.easeInOut(duration: 0.3)) {
            for index in offsets {
                context.delete(filtered[index])
            }
        }
    }

    // MARK: - Move Restaurants
    private func moveRestaurants(from source: IndexSet, to destination: Int, for meal: MealType) {
        var filtered = restaurants.filter { $0.meal == meal }
        filtered.move(fromOffsets: source, toOffset: destination)

        // No need to delete and recreate; SwiftData handles persistence
        for (_, restaurant) in filtered.enumerated() {
            context.insert(restaurant)
        }
    }
}

#Preview {
    NavigationStack {
        EditListsView()
            .modelContainer(for: Restaurant.self, inMemory: true)
    }
}
