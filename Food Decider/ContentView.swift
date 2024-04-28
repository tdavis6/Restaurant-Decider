//
//  ContentView.swift
//  Food Decider
//
//  Created by Tyler Davis on 4/27/24.
//

import SwiftUI

var transitionTime:Double = 0.75

var dinnerRestaurants:Set = ["The Stand", "Wahoo's", "BJ's", "Board and Brew", "Moreno's","Chipotle","Shake Shack","Islands","Cheesecake Factory","In N Out","Chick Fil A","Blaze Pizza","Smashburger","MOD Pizza","California Pizza Kitchen","Flame Broiler","Raising Canes","Ruby's Diner","Gramm00's","Manga Bene","Panda Express"]
var lunchRestaurants:Set = ["The Stand", "Wahoo's", "BJ's", "Board and Brew","Chipotle","Shake Shack","Islands","In N Out","Chick Fil A","Blaze Pizza","Smashburger","MOD Pizza","California Pizza Kitchen","Flame Broiler","Raising Canes","Ruby's Diner"]
var breakfastRestaurants:Set = ["Bravo Burger", "Corky's","Latte Da","San Juan Hills Country Club","The Original Pancake House"]

struct ContentView: View {
    let allRestaurants = dinnerRestaurants.union(lunchRestaurants).union(breakfastRestaurants)
    var colors: [Color] = [.blue, .cyan, .gray, .green, .indigo, .mint, .orange, .pink, .purple, .red, .yellow, .teal]
    
    private var defaultRestaurant:String = "The Stand"
    @State private var selected:String = "The Stand"
    @State private var id:Int = 1
    @State private var meal:String = "all"
    var body: some View {
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
            Button("Directions") {
                withAnimation(.easeInOut(duration: transitionTime)) {
                    let url = URL(string: "maps://?q=\(selected)")
                    if UIApplication.shared.canOpenURL(url!) {
                          UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    }
                }
            }
            .buttonStyle(.bordered)
            Spacer()
            HStack{
                Button("Breakfast") {
                    withAnimation(.easeInOut(duration: transitionTime)) {
                        meal = "breakfast"
                        selected = breakfastRestaurants.randomElement() ?? defaultRestaurant
                        id += 1
                    }
                }
                .buttonStyle(.borderedProminent)
                Button("Lunch") {
                    withAnimation(.easeInOut(duration: transitionTime)) {
                        meal = "lunch"
                        selected = lunchRestaurants.randomElement() ?? defaultRestaurant
                        id += 1
                    }
                }
                .buttonStyle(.borderedProminent)
                Button("Dinner") {
                    withAnimation(.easeInOut(duration: transitionTime)) {
                        meal = "dinner"
                        selected = dinnerRestaurants.randomElement() ?? defaultRestaurant
                        id += 1
                    }
                }
                .buttonStyle(.borderedProminent)
                Button("Any") {
                    withAnimation(.easeInOut(duration: transitionTime)) {
                        meal = "all"
                        selected = allRestaurants.randomElement() ?? defaultRestaurant
                        id += 1
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
