import ComposableArchitecture

/// The Feature is exactly like we already know:

struct FeatureA: ReducerProtocol { }

/// 1- Define a `@PresentationState` in the state of the source feature:

extension FeatureA {
    struct State: Equatable {
        @PresentationState var destination: Destination.State?
    }
}

/// 2- Define a `PresentationAction<Destination.Action>` in the source feature

extension FeatureA {
    enum Action: Equatable {
        case destination(PresentationAction<Destination.Action>)

        case onTapA
        case onTapB
        case onTapC
    }
}

/// 3- And embed the domain in the source reducer:

extension FeatureA {
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
            case .destination: return .none

            /// Of course we need to set the destination on the proper action:
            case .onTapA: state.destination = .featureA(.init())
            case .onTapB: state.destination = .featureB(.init())
            case .onTapC: state.destination = .featureC(.init())
            }
            return .none
        }
        .ifLet(\.$destination, action: /Action.destination, then: Destination.shared.callAsFunction )
    }
}
