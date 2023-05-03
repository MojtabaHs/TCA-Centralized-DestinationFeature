Most of the time we end up having multiple `navigationLink`s works exactly the same. So why don't we have a centralized `DestinationFeature` to handle all navigations of the app?

Its as simple as implementing a reducer that does nothing but scoping state and actions and child like: 
```
public struct Destination: ReducerProtocol {
  public var body: some ReducerProtocol<State, Action> {
    Scope(state: /State.featureA, action: /Action.featureA, child: FeatureA.init)
    Scope(state: /State.featureB, action: /Action.featureB, child: FeatureB.init)
    Scope(state: /State.featureC, action: /Action.featureC, child: FeatureC.init)
  }
}
```
And here is the `State`:
```
public extension Destination {
  enum State: Equatable {
    case featureA(FeatureA.State)
    case featureB(FeatureB.State)
    case featureC(FeatureC.State)
  }
}
```
And here is the `Action`:
```
public extension Destination {
  enum Action: Equatable {
    indirect case featureA(FeatureA.Action)
    indirect case featureB(FeatureB.Action)
    indirect case featureC(FeatureC.Action)
  }
}
```
And the a coordinator to wire things up:
```
extension Destination {
  struct Coordinator: View {
    let store: StoreOf<Destination>
    var body: some View {
      SwitchStore(store) {
        CaseLet(
           state: /Destination.State.featureA,
           action: Destination.Action.featureA,
           then: FeatureAView.init(store:) // <- This is the view for the featureA with an initializer that takes store
        )

        CaseLet(
          state: /Destination.State.featureB,
          action: Destination.Action.featureB,
          then: FeatureBView.init(store:)
        )

        CaseLet(
          state: /Destination.State.featureC,
          action: Destination.Action.featureC,
          then: FeatureCView.init(store:)
        )
      }
    }
  }
}
```

The rest is exactly like we already know:
1- Define a `@PresentationState` in the state of the source feature:
```
  @PresentationState var destination: Destination.State?
```
2- Define a `PresentationAction<Destination.Action>` in the source feature
```
  case destination(PresentationAction<Destination.Action>)
```
3- And embed the domain in the source reducer:
```
  Reduce(...)
    .ifLet(\.$destination, action: /Action.destination, then: Destination.shared.callAsFunction )
```

> Note: You can make the `destinationFeature` `shared` simply like:
> ```
> let destination = Destination()
> 
> extension Destination {
>  static let shared = Self()
>  func callAsFunction() -> Self { self }
> }
> ```

Of course we need to set the destination on the proper action:
```
case .onTap:
  state.destination = .featureB(.init(/*Pass Needed Data Here*/)))
  return .none
```
And Of course we need to have a `DestinationLinkStore` inside a navigation-capable container like the `NavigationView`:
```
  DestinationLinkStore(
    store.scope(state: \.$destination, action: Feature.Action.destination),
    destination: Destination.Coordinator.init
  )
```

> `DestinationLinkStore` is a simple helper for binding navigationLink and store:
> ```
> struct DestinationLinkStore<State, Action, Destination: > View>: View {
> let store: Store<PresentationState<State>, PresentationAction<Action>>
>  let destination: (_ destinationStore: Store<State, Action>) -> Destination
>
> public init(
>   _ store: Store<PresentationState<State>, PresentationAction<Action>>,
>   destination: @escaping (_ destinationStore: Store<State, Action>) -> Destination
> ) {
>   self.store = store
>   self.destination = destination
> }
>
>  public var body: some View {
>    NavigationLinkStore(store, onTap: { }, destination: destination, label: { }).hidden()
>  }
> }
> ```

The **Pros** of this method are:
- This method extracts all the navigation logic into one place **without** concerning the child's action or states.
- It works below iOS 16.
- It is deep-link ready.
- You can generate the entire stack tree (even in the preview)
- You can jump back to anywhere in the stack (for example the root)
- It does NOT need to be a `navigation style` and it can be modal, sheet and etc.

And the cons are:
- Apple is deprecating the `navigationLink` because it has some bugs in the vanilla SwiftUI (But we need it for iOS below 16)
- There are some boilerplate codes
- It seems only works on `.stack` style of the navigation
- There are repetitive codes like this to have in every source view
```
DestinationLinkStore(
  store.scope(state: \.$destination, action: Feature.Action.destination),
  destination: Destination.Coordinator.init
)
```

What do you think?

Here is a descsssion about this: [Centralized DestinationFeature ('aka' Coordinator or NavigationRouter) withOUT iOS 16 navigationStack](https://github.com/pointfreeco/swift-composable-architecture/discussions/2076)
