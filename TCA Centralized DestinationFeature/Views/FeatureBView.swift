import SwiftUI
import ComposableArchitecture

struct FeatureBView: View {
    typealias Feature = FeatureB

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
        .navigationTitle("View -B-")

        /// And Of course we need to have a `DestinationLinkStore` inside a navigation-capable container like the `NavigationView`:

        DestinationLinkStore(
            store.scope(state: \.$destination, action: Feature.Action.destination),
            destination: Destination.Coordinator.init
        )
    }
}

struct FeatureB_Previews: PreviewProvider {
    static var previews: some View {
        FeatureBView(
            store: .init(
                initialState: .init(),
                reducer: FeatureB()
            )
        )
        .storeNavigatablePreview()
    }
}
