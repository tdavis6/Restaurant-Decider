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

struct restaurant: Identifiable, Codable {
    var id = UUID()
    var name: String = "Restaurant Name"
}



var colors: [Color] = [.blue, .cyan, .gray, .green, .indigo, .mint, .orange, .pink, .purple, .red, .yellow, .teal]

struct HomePageView: View {
    @State public var dinnerRestaurants: [restaurant] = []
    @State public var lunchRestaurants: [restaurant] = []
    @State public var breakfastRestaurants: [restaurant] = []
    @State public var customRestaurants: [restaurant] = []
    @State var selected: restaurant = restaurant(name:"Choose a button below")
    @State var id:Int = 0

    @State var allRestaurants: [restaurant] = []
    
    func combineArrays() {
        allRestaurants = []
        
        if !dinnerRestaurants.isEmpty {
            allRestaurants = allRestaurants + dinnerRestaurants
        }
        if !lunchRestaurants.isEmpty {
            allRestaurants = allRestaurants + lunchRestaurants
        }
        if !breakfastRestaurants.isEmpty {
            allRestaurants = allRestaurants + breakfastRestaurants
        }
        if !customRestaurants.isEmpty {
            allRestaurants = allRestaurants + customRestaurants
        }
    }
    
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
                    .font(.largeTitle.bold()).onAppear(perform:combineArrays)
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
                            let url = URL(string: "maps://?q=\(selected.name)")
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
                        }.onAppear(perform: combineArrays)
                        .buttonStyle(.borderedProminent)
                    }
                    if !lunchRestaurants.isEmpty {
                        Button("Lunch") {
                            withAnimation(.easeInOut(duration: transitionTime)) {
                                randomLunch()
                            }
                        }.onAppear(perform: combineArrays)
                        .buttonStyle(.borderedProminent)
                    }
                    if !dinnerRestaurants.isEmpty {
                        Button("Dinner") {
                            withAnimation(.easeInOut(duration: transitionTime)) {
                                randomDinner()
                            }
                        }.onAppear(perform: combineArrays)
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
                    editListsView(customRestaurants: self.$customRestaurants, dinnerRestaurants: self.$dinnerRestaurants, lunchRestaurants: self.$lunchRestaurants, breakfastRestaurants: self.$breakfastRestaurants, textInput: "")
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
    @Binding var customRestaurants: [restaurant]
    @Binding var dinnerRestaurants: [restaurant]
    @Binding var lunchRestaurants: [restaurant]
    @Binding var breakfastRestaurants: [restaurant]
    @State private var showingBreakfastPopover = false
    @State private var showingLunchPopover = false
    @State private var showingDinnerPopover = false
    @State private var showingCustomPopover = false
    @State var editMode: EditMode = .inactive
    @State var textInput:String
    enum FocusedField {
        case textInput
    }
    @FocusState private var focusedField: FocusedField?
    
    var body: some View{
        NavigationStack {
            List {
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
                        if editMode.isEditing {
                            Button("Add new restaurant") {
                                showingBreakfastPopover = true
                            }.popover(isPresented: $showingBreakfastPopover) {
                                Form {
                                    Text("Enter the Restaurant Name").font(.headline)
                                    TextField(
                                      "Restaurant name",
                                      text: $textInput,
                                      onCommit: {
                                          breakfastRestaurants.append(restaurant(name:textInput))
                                          showingBreakfastPopover = false
                                          textInput = ""
                                      }
                                    ).keyboardType(.default).autocorrectionDisabled()
                                        .focused($focusedField, equals: .textInput)
                                        .listRowSeparator(.hidden)
                                    }.onAppear {
                                        focusedField = .textInput
                                }
                            }
                    }
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
                        if editMode.isEditing {
                            Button("Add new restaurant") {
                            showingLunchPopover = true
                        }.popover(isPresented: $showingLunchPopover) {
                            Form {
                                Text("Enter the Restaurant Name").font(.headline)
                                TextField(
                                  "Restaurant name",
                                  text: $textInput,
                                  onCommit: {
                                      lunchRestaurants.append(restaurant(name:textInput))
                                      showingLunchPopover = false
                                      textInput = ""
                                  }
                                ).keyboardType(.default).autocorrectionDisabled()
                                    .focused($focusedField, equals: .textInput)
                                    .listRowSeparator(.hidden)
                                }.onAppear {
                                    focusedField = .textInput
                            }
                        }
                    }
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
                        if editMode.isEditing {
                            Button("Add new restaurant") {
                            showingDinnerPopover = true
                        }.popover(isPresented: $showingDinnerPopover) {
                            Form {
                                Text("Enter the Restaurant Name").font(.headline)
                                TextField(
                                  "Restaurant name",
                                  text: $textInput,
                                  onCommit: {
                                      dinnerRestaurants.append(restaurant(name:textInput))
                                      showingDinnerPopover = false
                                      textInput = ""
                                  }
                                ).keyboardType(.default).autocorrectionDisabled()
                                    .focused($focusedField, equals: .textInput)
                                    .listRowSeparator(.hidden)
                                }.onAppear {
                                    focusedField = .textInput
                            }
                        }
                    }
                    }
                    .headerProminence(.increased)
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
                        if editMode.isEditing {
                            Button("Add new restaurant") {
                                showingCustomPopover = true
                        }.popover(isPresented: $showingCustomPopover) {
                            Form {
                                Text("Enter the Restaurant Name").font(.headline)
                                TextField(
                                  "Restaurant name",
                                  text: $textInput,
                                  onCommit: {
                                      customRestaurants.append(restaurant(name:textInput))
                                      showingCustomPopover = false
                                      textInput = ""
                                  }
                                ).keyboardType(.default).autocorrectionDisabled()
                                    .focused($focusedField, equals: .textInput)
                                    .listRowSeparator(.hidden)
                                }.onAppear {
                                    focusedField = .textInput
                                }
                        }
                    }
                    }
                    .headerProminence(.increased)
            }.listStyle(.insetGrouped)
        }
        .toolbar {
            EditButton()
        }.environment(\.editMode, $editMode)
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
