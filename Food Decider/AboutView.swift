//
//  AboutView.swift
//  Food Decider
//
//  Created by Tyler Davis on 11/28/24.
//


import SwiftUI

struct AboutView: View {
    func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    func getBuildNumber() -> String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("App Version: v\(getAppVersion())")
                Text("Build Number: \(getBuildNumber())")
                    .padding()
                Text("[Report an Issue](https://github.com/tdavis6/Restaurant-Decider/issues/new?assignees=tdavis6&labels=bug&projects=&template=bug_report.md&title=%5BBUG%5D)")
                    .padding()
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
            .padding()
        }
    }
}

#Preview {
    AboutView()
}
