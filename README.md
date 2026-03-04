# EuroPay iOS Example App

A complete reference implementation showing how to integrate [EuroPayKit](https://github.com/mhxdev/EuroPayKit) into a SwiftUI iOS app for EU alternative in-app purchases under the Digital Markets Act.

## What it demonstrates

- **SDK configuration** — setting up EuroPayKit at app launch with API key and App ID
- **Product fetching** — loading your product catalog from the EuroPay backend
- **Purchase flow** — EU region check, DMA disclosure, Stripe Checkout, and entitlement verification
- **Entitlement management** — checking access, restoring purchases, offline Keychain caching
- **Paywall UI** — ready-to-customize paywall with product list, purchase buttons, and status display

## Prerequisites

- Xcode 15+ with iOS 16 SDK
- A EuroPay account at [europay.dev](https://europay.dev)
- At least one product created in the EuroPay dashboard
- A connected Stripe account (BYOS)

## Setup

1. Clone this repo:
   ```bash
   git clone https://github.com/mhxdev/EuroPayExample.git
   cd EuroPayExample
   ```

2. Open in Xcode:
   ```bash
   open EuroPayExample.xcodeproj
   ```
   Xcode will automatically resolve the EuroPayKit Swift Package dependency.

3. Add your credentials in `EuroPayExample/Info.plist`:
   ```xml
   <key>EUROPAY_API_KEY</key>
   <string>europay_live_your_key_here</string>
   <key>EUROPAY_APP_ID</key>
   <string>your_app_id_here</string>
   ```
   You can find both values in the [EuroPay Dashboard](https://europay.dev/dashboard/apps).

4. Build and run on a simulator or device.

## Key integration points

### 1. Configure the SDK at launch

```swift
// EuroPayExampleApp.swift
import EuroPayKit

@main
struct MyApp: App {
    init() {
        EuroPayKit.configure(EuroPayConfig(
            apiKey: "europay_live_...",
            appId: "your_app_id",
            returnScheme: "myapp://europay-return",
            checkoutMode: .inAppSafari
        ))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .euroPayCheckoutReturnHandler()
        }
    }
}
```

### 2. Fetch products

```swift
let products = try await EuroPayKit.shared!.fetchProducts()
// Returns [EuroPayProduct] with name, formattedPrice, productType, interval
```

### 3. Start a purchase

```swift
let transaction = try await EuroPayKit.shared!.purchase(
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
await EuroPayKit.shared!.refreshEntitlements(userId: userId)

// Quick local check
if EuroPayKit.shared!.hasAccess(to: "com.myapp.premium") {
    showPremiumContent()
}
```

## Project structure

```
EuroPayExample/
├── App/
│   ├── EuroPayExampleApp.swift   — SDK configuration & app entry point
│   └── ContentView.swift       — Tab view (Home / Settings)
├── Views/
│   ├── PaywallView.swift       — Main paywall with products & purchase
│   ├── ProductListView.swift   — Product list with loading skeletons
│   ├── PurchaseButton.swift    — Purchase CTA with loading & success states
│   └── EntitlementStatusView.swift — Pro/Free status badge
├── Models/
│   └── AppState.swift          — Observable app state (products, entitlements)
└── Services/
    └── EuroPayService.swift      — Thin wrapper around EuroPayKit calls
```

## Resources

- [EuroPay Documentation](https://europay.dev/docs) — full integration guide, API reference, DMA compliance
- [EuroPayKit SDK](https://github.com/mhxdev/EuroPayKit) — iOS SDK source and documentation
- [EuroPay Dashboard](https://europay.dev/dashboard) — manage apps, products, and API keys

## License

MIT — see [LICENSE](LICENSE).
