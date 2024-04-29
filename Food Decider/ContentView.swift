//
//  ContentView.swift
//  Food Decider
//
//  Created by Tyler Davis on 4/27/24.
//

import SwiftUI

var transitionTime:Double = 0.75

var dinnerRestaurants: [String] = ["The Stand", "Wahoo's", "BJ's", "Board and Brew", "Moreno's","Chipotle","Shake Shack","Islands","Cheesecake Factory","In N Out","Chick Fil A","Blaze Pizza","Smashburger","MOD Pizza","California Pizza Kitchen","Flame Broiler","Raising Canes","Ruby's Diner","Gramm00's","Manga Bene","Panda Express","Bad to the Bone","OC Diner","The Ranch"]
var lunchRestaurants: [String] = ["The Stand", "Wahoo's", "BJ's", "Board and Brew","Chipotle","Shake Shack","Islands","In N Out","Chick Fil A","Blaze Pizza","Smashburger","MOD Pizza","California Pizza Kitchen","Flame Broiler","Raising Canes","Ruby's Diner","Bad to the Bone"]
var breakfastRestaurants: [String] = ["Bravo Burger", "Corky's","Latte Da","San Juan Hills Country Club","The Original Pancake House"]
var customRestaurants: [String] = ["Restaurant 1","Restaurant 2"]

let allRestaurants = dinnerRestaurants

var colors: [Color] = [.blue, .cyan, .gray, .green, .indigo, .mint, .orange, .pink, .purple, .red, .yellow, .teal]

struct HomePageView: View {
    @State private var selected:String = "The Stand"
    @State private var id:Int = 0
    @State private var meal:String = "any"
    
    func randomDinner() {
        selected = dinnerRestaurants.randomElement() ?? "The Stand"
        id += 1
    }

    func randomLunch() {
        selected = lunchRestaurants.randomElement() ?? "The Stand"
        id += 1
    }

    func randomBreakfast() {
        selected = breakfastRestaurants.randomElement() ?? "The Stand"
        id += 1
    }

    func randomAny() {
        selected = allRestaurants.randomElement() ?? "The Stand"
        id += 1
    }
    
    func randomCustom() {
        selected = customRestaurants.randomElement() ?? "The Stand"
        id += 1
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Why not try…")
                    .font(.largeTitle.bold())
                Spacer()
                VStack{
                    Circle()
                        .fill(colors.randomElement() ?? .blue)
                        .padding()
                        .overlay(
                            Image(systemName: "fork.knife.circle.fill"))
                        .font(.system(size: 250))
                        .foregroundColor(.white)
                    Text("\(selected)!")
                        .font(.title)
                }
                .transition(.slide)
                .id(id)
                HStack{
                    Button("Directions") {
                        withAnimation(.easeInOut(duration: transitionTime)) {
                            let url = URL(string: "maps://?q=\(selected)")
                            if UIApplication.shared.canOpenURL(url!) {
                                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                }
                Spacer()
                HStack{
                    Button("Breakfast") {
                        withAnimation(.easeInOut(duration: transitionTime)) {
                            meal = "breakfast"
                            randomBreakfast()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Lunch") {
                        withAnimation(.easeInOut(duration: transitionTime)) {
                            meal = "lunch"
                            randomLunch()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Dinner") {
                        withAnimation(.easeInOut(duration: transitionTime)) {
                            meal = "dinner"
                            randomDinner()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Any") {
                        withAnimation(.easeInOut(duration: transitionTime)) {
                            meal = "any"
                            randomAny()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                if customRestaurants .contains("The Stand") {
                    Button("Custom List") {
                        withAnimation(.easeInOut(duration: transitionTime)) {
                            meal = "custom"
                            randomCustom()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                Spacer()
                NavigationLink(destination: {
                    EditListsView()
                }, label: {
                    Text("Edit Lists")
                })
                .buttonStyle(.bordered)
                .padding()
            }
        }
    }
}

struct EditListsView: View {
    var body: some View{
        NavigationStack {
            List {
                Section(
                    header: Text("Custom List")) {
                        ForEach(customRestaurants, id: \.self) {restaurant in
                            Text(restaurant.capitalized)
                        }
                        .onDelete(perform: { indexSet in
                            customRestaurants.remove(atOffsets: indexSet)
                        })
                        .onMove(perform: { indices, newOffset in
                            customRestaurants.move(fromOffsets: indices, toOffset: newOffset)
                        })
                    }
                Section(
                    header: Text("Breakfast Restaurants")) {
                        ForEach(breakfastRestaurants, id: \.self) {restaurant in
                            Text(restaurant.capitalized)
                        }
                        .onDelete(perform: { indexSet in
                            breakfastRestaurants.remove(atOffsets: indexSet)
                        })
                        .onMove(perform: { indices, newOffset in
                            customRestaurants.move(fromOffsets: indices, toOffset: newOffset)
                        })
                    }
                Section(
                    header: Text("Lunch Restaurants")) {
                        ForEach(lunchRestaurants, id: \.self) {restaurant in
                            Text(restaurant.capitalized)
                        }
                        .onDelete(perform: { indexSet in
                            lunchRestaurants.remove(atOffsets: indexSet)
                        })
                        .onMove(perform: { indices, newOffset in
                            customRestaurants.move(fromOffsets: indices, toOffset: newOffset)
                        })
                    }
                Section(
                    header: Text("Dinner Restaurants")) {
                        ForEach(dinnerRestaurants, id: \.self) {restaurant in
                            Text(restaurant.capitalized)
                        }
                        .onDelete(perform: { indexSet in
                            dinnerRestaurants.remove(atOffsets: indexSet)
                        })
                        
                        .onMove(perform: { indices, newOffset in
                            customRestaurants.move(fromOffsets: indices, toOffset: newOffset)
                        })
                    }
            }
        }
        .toolbar {
                    EditButton()
                }
        .navigationTitle("List Editor")
    }
}

#Preview {
    HomePageView()
}
