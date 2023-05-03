import SwiftUI
import ComposableArchitecture

public struct DestinationLinkStore<State, Action, Destination: View>: View {
    let store: Store<PresentationState<State>, PresentationAction<Action>>
    let destination: (_ destinationStore: Store<State, Action>) -> Destination

    public init(
        _ store: Store<PresentationState<State>, PresentationAction<Action>>,
        destination: @escaping (_ destinationStore: Store<State, Action>) -> Destination
    ) {
        self.store = store
        self.destination = destination
    }

    public var body: some View {
        NavigationLinkStore(store, onTap: { }, destination: destination, label: { }).hidden()
    }
}
