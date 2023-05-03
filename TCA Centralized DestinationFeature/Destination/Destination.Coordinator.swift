import SwiftUI
import ComposableArchitecture

/// The a coordinator to wire things up:
extension Destination {
    struct Coordinator: View {
        let store: StoreOf<Destination>
        var body: some View {
            SwitchStore(store) {
                CaseLet(
                    state: /Destination.State.featureA,
                    action: Destination.Action.featureA,
                    then: FeatureAView.init
                )

                CaseLet(
                    state: /Destination.State.featureB,
                    action: Destination.Action.featureB,
                    then: FeatureBView.init
                )

                CaseLet(
                    state: /Destination.State.featureC,
                    action: Destination.Action.featureC,
                    then: FeatureCView.init
                )
            }
        }
    }
}
