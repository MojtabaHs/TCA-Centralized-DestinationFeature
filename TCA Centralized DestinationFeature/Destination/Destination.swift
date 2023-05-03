import ComposableArchitecture

/// Most of the time we end up having multiple `navigationLink`s works exactly the same.
/// So why don't we have a centralized `DestinationFeature` to handle all navigations of the app?
/// Its as simple as implementing a reducer that does nothing but scoping state and actions and child like:

struct Destination: ReducerProtocol {
    var body: some ReducerProtocol<State, Action> {
        Scope(state: /State.featureA, action: /Action.featureA, child: FeatureA.init)
        Scope(state: /State.featureB, action: /Action.featureB, child: FeatureB.init)
        Scope(state: /State.featureC, action: /Action.featureC, child: FeatureC.init)
    }
}

/// And here is the `State`:

extension Destination {
    enum State: Equatable {
        case featureA(FeatureA.State)
        case featureB(FeatureB.State)
        case featureC(FeatureC.State)
    }
}

/// And here is the `Action`:

extension Destination {
    enum Action: Equatable {
        indirect case featureA(FeatureA.Action)
        indirect case featureB(FeatureB.Action)
        indirect case featureC(FeatureC.Action)
    }
}
