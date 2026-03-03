import Foundation
import EUPayKit

/// Observable app-wide state that drives the UI.
@MainActor
final class AppState: ObservableObject {

    // MARK: - Published state

    @Published var products: [EUPayProduct] = []
    @Published var entitlements: [EUPayEntitlement] = []
    @Published var isPro: Bool = false
    @Published var isLoading: Bool = false

    // MARK: - User identity

    /// Stable anonymous user ID persisted across launches.
    let userId: String

    // MARK: - Init

    init() {
        let key = "eupay_example_user_id"
        if let stored = UserDefaults.standard.string(forKey: key) {
            self.userId = stored
        } else {
            let id = UUID().uuidString
            UserDefaults.standard.set(id, forKey: key)
            self.userId = id
        }
    }

    // MARK: - Derived state

    /// Recomputes `isPro` from the current entitlements list.
    func refreshProStatus() {
        isPro = entitlements.contains { $0.isActive }
    }
}
