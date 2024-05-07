//
//  ContentView.swift
//  Restaurant Decider
//
//  Created by Tyler Davis on 4/27/24.
//

import SwiftUI
import SwiftData

func getAppVersion() -> String {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return appVersion
        }
        return "Unknown"
    }

    func getBuildNumber() -> String {
        if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return buildNumber
        }
        return "Unknown"
    }

var transitionTime:Double = 0.75

var dinnerRestaurants = ["Restaurant 1","Restaurant 2", "Restaurant 3"]
var lunchRestaurants = ["Restaurant 1","Restaurant 2", "Restaurant 3"]
var breakfastRestaurants = ["Restaurant 1","Restaurant 2", "Restaurant 3"]
var customRestaurants = ["Restaurant 1","Restaurant 2", "Restaurant 3"]

let allRestaurants = dinnerRestaurants

var colors: [Color] = [.blue, .cyan, .gray, .green, .indigo, .mint, .orange, .pink, .purple, .red, .yellow, .teal]

struct HomePageView: View {
    @State private var selected: String = "Choose a button below"
    @State private var id:Int = 0
    @State private var meal:String = "any"

    let allRestaurants = dinnerRestaurants
    
    func randomDinner() {
        selected = dinnerRestaurants.randomElement() ?? "Choose a button below"
        id += 1
    }

    func randomLunch() {
        selected = lunchRestaurants.randomElement() ?? "Choose a button below"
        id += 1
    }

    func randomBreakfast() {
        selected = breakfastRestaurants.randomElement() ?? "Choose a button below"
        id += 1
    }
    
    func randomCustom() {
        selected = customRestaurants.randomElement() ?? "Choose a button below"
        id += 1
    }
    
    func randomAny() {
        selected = allRestaurants.randomElement() ?? "Choose a button below"
        id += 1
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Why not try…")
                    .font(.largeTitle.bold())
                Spacer()
                VStack{
                    AsyncImage(url: URL(string: "N/A")) { phase in
                                switch phase {
                                case .failure:
                                    Image(systemName: "fork.knife")
                                        .font(.system(size: 250))
                                        .foregroundColor(colors.randomElement() ?? .blue)
                                case .success(let image):
                                    ZStack{
                                        image
                                            .resizable()
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .background(
                                                LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .bottom, endPoint: .center)
                                            )
                                    }
                                default:
                                    ProgressView()
                                }
                            }
                    .frame(width: 320, height: 320)
                    .clipShape(.circle)
                    .padding()
                    Text("\(selected)!")
                        .font(.title)
                }
                .transition(.scale.combined(with: .blurReplace))
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
                            randomBreakfast()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Lunch") {
                        withAnimation(.easeInOut(duration: transitionTime)) {
                            randomLunch()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Dinner") {
                        withAnimation(.easeInOut(duration: transitionTime)) {
                            randomDinner()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Any") {
                        withAnimation(.easeInOut(duration: transitionTime)) {
                            randomAny()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                if !customRestaurants.isEmpty {
                    Button("Custom List") {
                        withAnimation(.easeInOut(duration: transitionTime)) {
                            randomCustom()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                Spacer()
                NavigationLink(destination: {
                    editListsView()
                }, label: {
                    Text("Edit Lists")
                })
                .buttonStyle(.bordered)
                .padding()
                
                NavigationLink(destination: {
                    aboutView()
                }, label: {
                    Text("About")
                })
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(0)
            }
        }
    }
}

struct editListsView: View {
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
                            breakfastRestaurants.move(fromOffsets: indices, toOffset: newOffset)
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
                            lunchRestaurants.move(fromOffsets: indices, toOffset: newOffset)
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
                            dinnerRestaurants.move(fromOffsets: indices, toOffset: newOffset)
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

struct aboutView: View {
    var body: some View{
        NavigationStack{
            Text("App Version: v\(getAppVersion())")
            Text("Build Number: \(getBuildNumber())")
                .padding()
            Text("[Report an Issue](https://github.com/tdavis6/Restaurant-Decider/issues/new?assignees=tdavis6&labels=bug&projects=&template=bug_report.md&title=%5BBUG%5D)")
            Text("[GitHub Repository](https://github.com/tdavis6/Restaurant-Decider)")
                .padding()
            Text("This application is licensed under the MIT License, found [here](https://github.com/tdavis6/Restaurant-Decider/blob/main/LICENSE).")
                .padding()
            Text("The app icon contains an icon from Material Design Icons, licensed under the Apache License 2.0, found [here](https://github.com/material-components/material-components/blob/develop/LICENSE).")
                .padding()
            Text("The restaurant icon that appears when the internet photo fails to resolve contains an icon from Apple's SF Symbols, licensing found [here](https://developer.apple.com/support/terms/).")
                .padding()
        }
    }
}
#Preview {
    HomePageView()
}
