import SwiftUI
import EUPayKit

struct EntitlementStatusView: View {

    @EnvironmentObject private var appState: AppState

    var body: some View {
        if let active = appState.entitlements.first(where: { $0.isActive }) {
            activeCard(active)
        } else {
            freeCard
        }
    }

    // MARK: - Active entitlement

    @ViewBuilder
    private func activeCard(_ entitlement: EUPayEntitlement) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .font(.title2)
                .foregroundStyle(.green)

            VStack(alignment: .leading, spacing: 2) {
                Text("Pro Active")
                    .font(.subheadline.bold())
                    .foregroundStyle(.green)

                if let end = entitlement.currentPeriodEnd {
                    Text("Renews \(end, style: .date)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if entitlement.cancelAtPeriodEnd {
                    Text("Cancels at period end")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }

            Spacer()
        }
        .padding()
        .background(.green.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Free plan

    private var freeCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.crop.circle")
                .font(.title2)
                .foregroundStyle(.gray)

            VStack(alignment: .leading, spacing: 2) {
                Text("Free Plan")
                    .font(.subheadline.bold())
                    .foregroundStyle(.gray)

                Text("Upgrade to unlock all features")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
    }
}
