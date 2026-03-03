# EUPay iOS Example App

A complete reference implementation showing how to integrate [EUPayKit](https://github.com/mhxdev/EUPayKit) into a SwiftUI iOS app for EU alternative in-app purchases under the Digital Markets Act.

## What it demonstrates

- **SDK configuration** — setting up EUPayKit at app launch with API key and App ID
- **Product fetching** — loading your product catalog from the EUPay backend
- **Purchase flow** — EU region check, DMA disclosure, Stripe Checkout, and entitlement verification
- **Entitlement management** — checking access, restoring purchases, offline Keychain caching
- **Paywall UI** — ready-to-customize paywall with product list, purchase buttons, and status display

## Prerequisites

- Xcode 15+ with iOS 16 SDK
- An EUPay account at [europay.dev](https://europay.dev)
- At least one product created in the EUPay dashboard
- A connected Stripe account (BYOS)

## Setup

1. Clone this repo:
   ```bash
   git clone https://github.com/mhxdev/EUPayExample.git
   cd EUPayExample
   ```

2. Open in Xcode:
   ```bash
   open EUPayExample.xcodeproj
   ```
   Xcode will automatically resolve the EUPayKit Swift Package dependency.

3. Add your credentials in `EUPayExample/Info.plist`:
   ```xml
   <key>EUPAY_API_KEY</key>
   <string>eupay_live_your_key_here</string>
   <key>EUPAY_APP_ID</key>
   <string>your_app_id_here</string>
   ```
   You can find both values in the [EUPay Dashboard](https://europay.dev/dashboard/apps).

4. Build and run on a simulator or device.

## Key integration points

### 1. Configure the SDK at launch

```swift
// EUPayExampleApp.swift
import EUPayKit

@main
struct MyApp: App {
    init() {
        EUPayKit.configure(EUPayConfig(
            apiKey: "eupay_live_...",
            appId: "your_app_id",
            returnScheme: "myapp://eupay-return",
            checkoutMode: .inAppSafari
        ))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .eupayCheckoutReturnHandler()
        }
    }
}
```

### 2. Fetch products

```swift
let products = try await EUPayKit.shared!.fetchProducts()
// Returns [EUPayProduct] with name, formattedPrice, productType, interval
```

### 3. Start a purchase

```swift
let transaction = try await EUPayKit.shared!.purchase(
    product: product,
    userId: userId,
    presenting: viewController
)

if transaction.status == .succeeded {
    // Entitlement is now active — unlock premium content
}
```

### 4. Check entitlements

```swift
// Refresh from server (with Keychain fallback)
await EUPayKit.shared!.refreshEntitlements(userId: userId)

// Quick local check
if EUPayKit.shared!.hasAccess(to: "com.myapp.premium") {
    showPremiumContent()
}
```

## Project structure

```
EUPayExample/
├── App/
│   ├── EUPayExampleApp.swift   — SDK configuration & app entry point
│   └── ContentView.swift       — Tab view (Home / Settings)
├── Views/
│   ├── PaywallView.swift       — Main paywall with products & purchase
│   ├── ProductListView.swift   — Product list with loading skeletons
│   ├── PurchaseButton.swift    — Purchase CTA with loading & success states
│   └── EntitlementStatusView.swift — Pro/Free status badge
├── Models/
│   └── AppState.swift          — Observable app state (products, entitlements)
└── Services/
    └── EUPayService.swift      — Thin wrapper around EUPayKit calls
```

## Resources

- [EUPay Documentation](https://europay.dev/docs) — full integration guide, API reference, DMA compliance
- [EUPayKit SDK](https://github.com/mhxdev/EUPayKit) — iOS SDK source and documentation
- [EUPay Dashboard](https://europay.dev/dashboard) — manage apps, products, and API keys

## License

MIT — see [LICENSE](LICENSE).
