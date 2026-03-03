import SwiftUI
import EUPayKit

struct ProductListView: View {

    let products: [EUPayProduct]
    let isLoading: Bool

    var body: some View {
        VStack(spacing: 12) {
            if isLoading {
                // Loading skeletons
                ForEach(0..<2, id: \.self) { _ in
                    skeletonRow
                }
            } else if products.isEmpty {
                Text("No products available")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                ForEach(products) { product in
                    productRow(product)
                }
            }
        }
    }

    // MARK: - Product row

    @ViewBuilder
    private func productRow(_ product: EUPayProduct) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)

                if let description = product.description {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(product.formattedPrice)
                    .font(.subheadline.bold())

                typeBadge(product)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private func typeBadge(_ product: EUPayProduct) -> some View {
        let label: String
        switch product.productType {
        case .subscription:
            if let interval = product.interval {
                label = interval == "month" ? "Monthly" : "Yearly"
            } else {
                label = "Subscription"
            }
        case .oneTime:
            label = "One-time"
        }

        Text(label)
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(
                product.productType == .subscription
                    ? Color.indigo.opacity(0.15)
                    : Color.green.opacity(0.15),
                in: Capsule()
            )
            .foregroundStyle(product.productType == .subscription ? .indigo : .green)
    }

    // MARK: - Skeleton

    private var skeletonRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray4))
                    .frame(width: 120, height: 16)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(width: 180, height: 12)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray4))
                .frame(width: 60, height: 16)
        }
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
        .redacted(reason: .placeholder)
    }
}
