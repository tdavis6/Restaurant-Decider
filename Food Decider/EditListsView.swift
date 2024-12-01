//
//  EditListsView.swift
//  Food Decider
//
//  Created by Tyler Davis on 11/28/24.
//


import SwiftUI
import SwiftData

struct EditListsView: View {
    @Environment(\.modelContext) private var context
    @Query var restaurants: [Restaurant]

    @State private var newRestaurantName: String = ""
    @State private var selectedMeal: MealType = .breakfast
    @State private var editMode: EditMode = .inactive

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

            // List of Restaurants
            List {
                ForEach(MealType.allCases) { meal in
                    Section(header: Text(meal.rawValue.capitalized)) {
                        ForEach(restaurants.filter { $0.meal == meal }) { restaurant in
                            Text(restaurant.name)
                        }
                        .onDelete { indexSet in
                            deleteRestaurants(at: indexSet, for: meal)
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
        .navigationTitle("Edit Restaurants")
    }

    // MARK: - Add Restaurant
    func addRestaurant() {
        guard !newRestaurantName.isEmpty else { return }
        let newRestaurant = Restaurant(name: newRestaurantName, meal: selectedMeal)
        context.insert(newRestaurant)
        newRestaurantName = ""
    }

    // MARK: - Delete Restaurants
    func deleteRestaurants(at offsets: IndexSet, for meal: MealType) {
        let filtered = restaurants.filter { $0.meal == meal }
        for index in offsets {
            context.delete(filtered[index])
        }
    }
}

#Preview {
    NavigationStack {
        EditListsView()
            .modelContainer(for: Restaurant.self, inMemory: true)
    }
}
