import SwiftUI
import EuroPayKit

struct ContentView: View {

    @EnvironmentObject private var appState: AppState

    var body: some View {
        TabView {
            HomeTab()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            SettingsTab()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(.indigo)
        .task {
            await loadInitialData()
        }
    }

    // MARK: - Home

    @ViewBuilder
    private func HomeTab() -> some View {
        NavigationStack {
            Group {
                if appState.isPro {
                    ProContentView()
                } else {
                    PaywallView()
                }
            }
            .navigationTitle("EuroPay Example")
        }
    }

    // MARK: - Settings

    @ViewBuilder
    private func SettingsTab() -> some View {
        NavigationStack {
            List {
                Section("Account") {
                    LabeledContent("User ID") {
                        Text(appState.userId)
                            .font(.caption.monospaced())
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }

                    LabeledContent("Environment") {
                        Text(EuroPayKit.shared != nil ? "Configured" : "Not configured")
                            .foregroundStyle(EuroPayKit.shared != nil ? .green : .red)
                    }
                }

                Section("Subscription") {
                    EntitlementStatusView()

                    Button("Restore Purchases") {
                        Task { await restoreEntitlements() }
                    }
                    .disabled(appState.isLoading)
                }

                Section("About") {
                    LabeledContent("App Version", value: "1.0.0")
                    Link("EuroPay Documentation",
                         destination: URL(string: "https://europay.dev/docs")!)
                    Link("EuroPayKit SDK",
                         destination: URL(string: "https://github.com/mhxdev/EuroPayKit")!)
                }
            }
            .navigationTitle("Settings")
        }
    }

    // MARK: - Pro content (unlocked state)

    @ViewBuilder
    private func ProContentView() -> some View {
        VStack(spacing: 24) {
            Image(systemName: "crown.fill")
                .font(.system(size: 64))
                .foregroundStyle(.yellow)

            Text("Premium Unlocked")
                .font(.title.bold())

            Text("You have full access to all premium features.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            EntitlementStatusView()
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
        .padding()
    }

    // MARK: - Data loading

    private func loadInitialData() async {
        let service = EuroPayService()
        appState.isLoading = true
        defer { appState.isLoading = false }

        // Fetch products and entitlements concurrently
        async let productsTask: () = fetchProducts(service)
        async let entitlementsTask: () = restoreEntitlements()
        _ = await (productsTask, entitlementsTask)
    }

    private func fetchProducts(_ service: EuroPayService) async {
        do {
            appState.products = try await service.fetchProducts()
        } catch {
            print("Failed to fetch products: \(error)")
        }
    }

    private func restoreEntitlements() async {
        let service = EuroPayService()
        appState.entitlements = await service.checkEntitlements(userId: appState.userId)
        appState.refreshProStatus()
    }
}
