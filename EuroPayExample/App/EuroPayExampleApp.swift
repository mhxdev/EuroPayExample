import SwiftUI
import EuroPayKit

@main
struct EuroPayExampleApp: App {

    @StateObject private var appState = AppState()

    init() {
        // Read credentials from Info.plist — replace the placeholder values
        // in Info.plist with your real EuroPay API key and App ID.
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "EUROPAY_API_KEY") as? String ?? ""
        let appId  = Bundle.main.object(forInfoDictionaryKey: "EUROPAY_APP_ID") as? String ?? ""

        guard !apiKey.isEmpty, apiKey != "YOUR_EUROPAY_API_KEY_HERE",
              !appId.isEmpty,  appId  != "YOUR_EUROPAY_APP_ID_HERE" else {
            print("⚠️  EuroPay: Set EUROPAY_API_KEY and EUROPAY_APP_ID in Info.plist")
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
                .euroPayCheckoutReturnHandler()
        }
    }
}
