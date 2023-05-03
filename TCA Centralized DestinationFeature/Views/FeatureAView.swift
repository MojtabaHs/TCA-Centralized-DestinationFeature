import SwiftUI
import ComposableArchitecture

struct FeatureAView: View {
    typealias Feature = FeatureA

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
        .navigationTitle("View -A-")

        /// And Of course we need to have a `DestinationLinkStore` inside a navigation-capable container like the `NavigationView`:

        DestinationLinkStore(
            store.scope(state: \.$destination, action: Feature.Action.destination),
            destination: Destination.Coordinator.init
        )
    }
}

struct FeatureA_Previews: PreviewProvider {
    static var previews: some View {
        FeatureAView(
            store: .init(
                initialState: .init(),
                reducer: FeatureA()
            )
        )
        .storeNavigatablePreview()
    }
}
