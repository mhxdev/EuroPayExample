import SwiftUI
import EUPayKit

@main
struct EUPayExampleApp: App {

    @StateObject private var appState = AppState()

    init() {
        // Read credentials from Info.plist — replace the placeholder values
        // in Info.plist with your real EUPay API key and App ID.
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "EUPAY_API_KEY") as? String ?? ""
        let appId  = Bundle.main.object(forInfoDictionaryKey: "EUPAY_APP_ID") as? String ?? ""

        guard !apiKey.isEmpty, apiKey != "YOUR_EUPAY_API_KEY_HERE",
              !appId.isEmpty,  appId  != "YOUR_EUPAY_APP_ID_HERE" else {
            print("⚠️  EUPay: Set EUPAY_API_KEY and EUPAY_APP_ID in Info.plist")
            return
        }

        EUPayKit.configure(EUPayConfig(
            apiKey: apiKey,
            appId: appId,
            returnScheme: "eupayexample://eupay-return",
            checkoutMode: .inAppSafari
        ))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .eupayCheckoutReturnHandler()
        }
    }
}
