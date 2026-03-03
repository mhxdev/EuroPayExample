import SwiftUI
import EUPayKit

struct PurchaseButton: View {

    let product: EUPayProduct
    let onPurchase: () async -> Void

    @State private var isPurchasing = false
    @State private var showSuccess = false

    var body: some View {
        Button {
            Task {
                isPurchasing = true
                await onPurchase()
                isPurchasing = false

                // Brief checkmark animation on success
                withAnimation(.spring(response: 0.4)) {
                    showSuccess = true
                }
                try? await Task.sleep(for: .seconds(1.5))
                withAnimation { showSuccess = false }
            }
        } label: {
            HStack(spacing: 8) {
                if isPurchasing {
                    ProgressView()
                        .tint(.white)
                } else if showSuccess {
                    Image(systemName: "checkmark.circle.fill")
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Text(buttonLabel)
                }
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(showSuccess ? .green : .indigo, in: RoundedRectangle(cornerRadius: 14))
        }
        .disabled(isPurchasing)
    }

    /// e.g. "Subscribe — €9.99/month" or "Buy — €29.99"
    private var buttonLabel: String {
        let price = product.formattedPrice

        switch product.productType {
        case .subscription:
            let interval = product.interval ?? "month"
            let suffix = interval == "year" ? "/year" : "/month"
            return "Subscribe — \(price)\(suffix)"
        case .oneTime:
            return "Buy — \(price)"
        }
    }
}
