import SwiftUI
import EUPayKit

struct PaywallView: View {

    @EnvironmentObject private var appState: AppState
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // App icon placeholder + headline
                header

                // Feature list
                featureBullets

                // Products
                if appState.isLoading && appState.products.isEmpty {
                    ProductListView(products: [], isLoading: true)
                } else {
                    ProductListView(products: appState.products, isLoading: false)

                    ForEach(appState.products) { product in
                        PurchaseButton(product: product) {
                            await handlePurchase(product)
                        }
                    }
                }

                // Restore
                Button("Restore Purchases") {
                    Task { await restore() }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .disabled(appState.isLoading)

                // Entitlement status
                EntitlementStatusView()
                    .padding(.top, 8)
            }
            .padding()
        }
        .alert("Purchase Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    // MARK: - Subviews

    private var header: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 20)
                .fill(.indigo.gradient)
                .frame(width: 80, height: 80)
                .overlay {
                    Image(systemName: "star.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.white)
                }

            Text("Unlock Premium")
                .font(.title.bold())

            Text("Get unlimited access to all features with a subscription powered by EUPay.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var featureBullets: some View {
        VStack(alignment: .leading, spacing: 12) {
            FeatureRow(icon: "checkmark.seal.fill", text: "Unlimited projects & exports")
            FeatureRow(icon: "bolt.fill",           text: "Priority processing & support")
            FeatureRow(icon: "lock.open.fill",      text: "All future features included")
        }
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Actions

    private func handlePurchase(_ product: EUPayProduct) async {
        do {
            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene }).first,
                  let rootVC = windowScene.windows.first?.rootViewController else {
                return
            }

            let service = EUPayService()
            let transaction = try await service.purchase(
                product: product,
                userId: appState.userId,
                presenting: rootVC
            )

            if transaction.status == .succeeded {
                appState.entitlements = await service.checkEntitlements(
                    userId: appState.userId
                )
                appState.refreshProStatus()
            }
        } catch let error as EUPayError {
            switch error {
            case .userCancelled:
                break // User dismissed — no alert needed
            case .regionNotSupported:
                errorMessage = "EUPay is only available in the EU App Store. Use Apple In-App Purchase for other regions."
                showError = true
            default:
                errorMessage = error.localizedDescription
                showError = true
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    private func restore() async {
        let service = EUPayService()
        appState.entitlements = await service.checkEntitlements(userId: appState.userId)
        appState.refreshProStatus()
    }
}

// MARK: - Feature row

private struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.indigo)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
        }
    }
}
