/// - Note: You can make the `destinationFeature` `shared` simply like:
let destination = Destination()

extension Destination {
    static let shared = Self()
    func callAsFunction() -> Self { self }
}
