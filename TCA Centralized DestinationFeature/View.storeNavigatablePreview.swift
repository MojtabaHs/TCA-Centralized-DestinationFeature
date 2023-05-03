import SwiftUI

extension View {
    /// Wraps the preview inside a `NavigationView` and a `ZStack` for enabling the navigation
    @ViewBuilder
    func storeNavigatablePreview() -> some View {
        NavigationView { ZStack { self } }
            .navigationViewStyle(.stack)
    }
}
