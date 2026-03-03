import SwiftUI
import EuroPayKit

@main
struct EuroPayExampleApp: App {

    @StateObject private var appState = AppState()

    init() {
        // Read credentials from Info.plist — replace the placeholder values
        // in Info.plist with your real EuroPay API key and App ID.
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "EUPAY_API_KEY") as? String ?? ""
        let appId  = Bundle.main.object(forInfoDictionaryKey: "EUPAY_APP_ID") as? String ?? ""

        guard !apiKey.isEmpty, apiKey != "YOUR_EUPAY_API_KEY_HERE",
              !appId.isEmpty,  appId  != "YOUR_EUPAY_APP_ID_HERE" else {
            print("⚠️  EuroPay: Set EUPAY_API_KEY and EUPAY_APP_ID in Info.plist")
            return
        }

        EuroPayKit.configure(EuroPayConfig(
            apiKey: apiKey,
            appId: appId,
            returnScheme: "europayexample://europay-return",
            checkoutMode: .inAppSafari
        ))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .europayCheckoutReturnHandler()
        }
    }
}
