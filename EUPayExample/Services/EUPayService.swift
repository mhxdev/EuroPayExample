import Foundation
import EuroPayKit
import UIKit

/// Thin wrapper around EuroPayKit for the example app.
/// Each method maps 1-to-1 to an SDK call so the Views stay clean.
@MainActor
final class EuroPayService {

    private var sdk: EuroPayKit {
        guard let sdk = EuroPayKit.shared else {
            fatalError("EuroPayKit.configure() must be called before using EuroPayService.")
        }
        return sdk
    }

    // MARK: - Products

    /// Fetch active products for this app from the EuroPay backend.
    func fetchProducts() async throws -> [EuroPayProduct] {
        try await sdk.fetchProducts()
    }

    // MARK: - Entitlements

    /// Refresh entitlements from the server and return the latest list.
    /// Falls back to cached (Keychain) entitlements on network failure.
    func checkEntitlements(userId: String) async -> [EuroPayEntitlement] {
        await sdk.refreshEntitlements(userId: userId)
        return sdk.entitlements
    }

    /// Quick local check — no network call.
    func hasAccess(to appStoreProductId: String) -> Bool {
        sdk.hasAccess(to: appStoreProductId)
    }

    // MARK: - Purchase

    /// Start the full purchase flow:
    /// 1. EU region check  2. DMA disclosure  3. Stripe Checkout  4. Entitlement poll
    func purchase(
        product: EuroPayProduct,
        userId: String,
        presenting viewController: UIViewController
    ) async throws -> EuroPayTransaction {
        try await sdk.purchase(
            product: product,
            userId: userId,
            presenting: viewController
        )
    }

    // MARK: - Customer Portal

    /// Open Stripe Customer Portal so users can manage billing.
    func openCustomerPortal(
        userId: String,
        presenting viewController: UIViewController
    ) async throws {
        try await sdk.openCustomerPortal(
            userId: userId,
            presenting: viewController
        )
    }
}
