import SwiftUI
import ComposableArchitecture

struct FeatureCView: View {
    typealias Feature = FeatureC

    let store: StoreOf<Feature>
    @ObservedObject private var viewStore: ViewStoreOf<Feature>

    init(store: StoreOf<Feature>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }

    var body: some View {
        VStack {
            Button("A") { viewStore.send(.onTapA) }
            Button("B") { viewStore.send(.onTapB) }
            Button("C") { viewStore.send(.onTapC) }
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .navigationTitle("View -C-")

        /// And Of course we need to have a `DestinationLinkStore`
        /// - Note: It should be inside a navigation-capable container like the `NavigationView`
        ///         This application is already inside a `NavigationView`

        DestinationLinkStore(
            store.scope(state: \.$destination, action: Feature.Action.destination),
            destination: Destination.Coordinator.init
        )
    }
}

struct FeatureC_Previews: PreviewProvider {
    static var previews: some View {
        FeatureCView(
            store: .init(
                initialState: .init(),
                reducer: FeatureC()
            )
        )
        .storeNavigatablePreview()
    }
}
