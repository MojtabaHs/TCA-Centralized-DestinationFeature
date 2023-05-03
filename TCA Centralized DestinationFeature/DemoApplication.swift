//  Created by Seyed Mojtaba Hosseini Zeidabadi.
//
//  GitHub: https://github.com/MojtabaHs
//  LinkedIn: https://www.linkedin.com/in/mojtabahosseini
//  StackOverflow: https://stackoverflow.com/users/5623035/mojtaba-hosseini

import SwiftUI

@main
struct DemoApplication: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ZStack {
                    FeatureAView(store: .init(initialState: .init(), reducer: FeatureA()))
                }
            }
            .navigationViewStyle(.stack)
        }
    }
}
