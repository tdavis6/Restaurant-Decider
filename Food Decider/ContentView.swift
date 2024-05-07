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

struct restaurant: Identifiable {
    var id = UUID()
    var name: String = "Restaurant Name"
}

var dinnerRestaurants = [restaurant(name: String())]
var lunchRestaurants = [restaurant(name: String())]
var breakfastRestaurants = [restaurant(name: String())]
var customRestaurants = [restaurant(name: String())]

var colors: [Color] = [.blue, .cyan, .gray, .green, .indigo, .mint, .orange, .pink, .purple, .red, .yellow, .teal]

struct HomePageView: View {
    @State var selected: restaurant = restaurant(name:"Choose a button below")
    @State var id:Int = 0

    @State var allRestaurants = dinnerRestaurants
    
    func randomDinner() {
        selected = dinnerRestaurants.randomElement() ?? restaurant(name: "Choose a button below")
        id += 1
    }

    func randomLunch() {
        selected = lunchRestaurants.randomElement() ?? restaurant(name: "Choose a button below")
        id += 1
    }

    func randomBreakfast() {
        selected = breakfastRestaurants.randomElement() ?? restaurant(name: "Choose a button below")
        id += 1
    }
    
    func randomCustom() {
        selected = customRestaurants.randomElement() ?? restaurant(name: "Choose a button below")
        id += 1
    }
    
    func randomAny() {
        selected = allRestaurants.randomElement() ?? restaurant(name: "Choose a button below")
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
                                                LinearGradient(stops: [
                                                    Gradient.Stop(color: .clear, location: 0.4),
                                                    Gradient.Stop(color: .black, location: 0.0),
                                                ], startPoint: .bottom, endPoint: .top)
                                            )
                                    }
                                default:
                                    ProgressView()
                                }
                            }
                    .frame(width: 320, height: 320)
                    .clipShape(.circle)
                    .padding()
                    Text("\(selected.name)!")
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
                    if !breakfastRestaurants.isEmpty {
                        Button("Breakfast") {
                            withAnimation(.easeInOut(duration: transitionTime)) {
                                randomBreakfast()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    if !breakfastRestaurants.isEmpty {
                        Button("Lunch") {
                            withAnimation(.easeInOut(duration: transitionTime)) {
                                randomLunch()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    if !dinnerRestaurants.isEmpty {
                        Button("Dinner") {
                            withAnimation(.easeInOut(duration: transitionTime)) {
                                randomDinner()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    if !allRestaurants.isEmpty {
                        Button("Any") {
                            withAnimation(.easeInOut(duration: transitionTime)) {
                                randomAny()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
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
    struct restaurantList: View {
        var body: some View {
            Text("Task data goes here")
        }
    }
    var body: some View{
        NavigationStack {
            List {
                Section(
                    header: Text("Custom Restaurants")) {
                        ForEach(customRestaurants, id: \.name) {restaurant in
                            Text(restaurant.name.capitalized)
                        }
                        .onDelete(perform: { indexSet in
                            customRestaurants.remove(atOffsets: indexSet)
                        })
                        .onMove(perform: { indices, newOffset in
                            customRestaurants.move(fromOffsets: indices, toOffset: newOffset)
                        })
                    }
                    .headerProminence(.increased)
                Section(
                    header: Text("Dinner Restaurants")) {
                        ForEach(dinnerRestaurants, id: \.name) {restaurant in
                            Text(restaurant.name.capitalized)
                        }
                        .onDelete(perform: { indexSet in
                            dinnerRestaurants.remove(atOffsets: indexSet)
                        })
                        .onMove(perform: { indices, newOffset in
                            dinnerRestaurants.move(fromOffsets: indices, toOffset: newOffset)
                        })
                    }
                    .headerProminence(.increased)
                Section(
                    header: Text("Lunch Restaurants")) {
                        ForEach(lunchRestaurants, id: \.name) {restaurant in
                            Text(restaurant.name.capitalized)
                        }
                        .onDelete(perform: { indexSet in
                            lunchRestaurants.remove(atOffsets: indexSet)
                        })
                        .onMove(perform: { indices, newOffset in
                            lunchRestaurants.move(fromOffsets: indices, toOffset: newOffset)
                        })
                    }
                    .headerProminence(.increased)
                Section(
                    header: Text("Breakfast Restaurants")) {
                        ForEach(breakfastRestaurants, id: \.name) {restaurant in
                            Text(restaurant.name.capitalized)
                        }
                        .onDelete(perform: { indexSet in
                            breakfastRestaurants.remove(atOffsets: indexSet)
                        })
                        .onMove(perform: { indices, newOffset in
                            breakfastRestaurants.move(fromOffsets: indices, toOffset: newOffset)
                        })
                    }
                    .headerProminence(.increased)
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
                .padding(.top)
            Text("[Request a Feature](https://github.com/tdavis6/Restaurant-Decider/issues/new?assignees=tdavis6&labels=enhancement&projects=&template=feature_request.md&title=%5BFEATURE%5D)")
                .padding()
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
