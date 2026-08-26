import SwiftUI
import WitnessCore

/// The single calm Atlas choice surface: one service, two billing
/// durations, identical access. Never a tier grid.
struct AtlasAccessSheet: View {
    @ObservedObject var commerce: CommerceModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Text("ATLAS")
                    .font(AtlasType.display(30, weight: .semibold))
                    .accessibilityAddTraits(.isHeader)

                Text("Atlas is the living library of Witness: every released field season, the complete archive beyond the free window, narration, extended field notes, corrections, and a monthly field dispatch — for as long as membership is active.")
                    .font(.callout)
                    .lineSpacing(4)

                AccessStateNotice(
                    text: "The Atlas library is in production and membership is not yet on sale. It opens only once its ongoing deliverables are real.",
                    identifier: "access.atlas.production.notice"
                )

                if commerce.atlasIsActive {
                    AccessStateNotice(
                        text: "Atlas is active. \(commerce.atlasStatusLine).",
                        identifier: "access.atlas.active"
                    )
                } else {
                    durationChoices
                }

                PurchasePhaseNotice(purchasePhase: commerce.purchasePhase, restorePhase: commerce.restorePhase)

                Text("Both durations unlock exactly the same Atlas. Renewal is automatic until cancelled in your Apple subscription settings; access ordinarily continues through the paid period after cancelling. When Atlas ends, the free ritual, your private records, and any separately purchased Field Season remain yours.")
                    .font(.footnote)
                    .foregroundStyle(AtlasTheme.inkMuted)
                    .lineSpacing(3)

                AccessQuietRow(title: "RESTORE PURCHASES", identifier: "access.atlas.restore") {
                    Task { await commerce.restore() }
                }
                ManageSubscriptionRow(identifier: "access.atlas.manage")
            }
            .padding(22)
            .foregroundStyle(AtlasTheme.ink)
        }
        .background(AtlasPaper().ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task { await commerce.startIfNeeded() }
        .onDisappear { commerce.clearTransientPhases() }
    }

    @ViewBuilder
    private var durationChoices: some View {
        switch commerce.productsState {
        case .loading:
            HStack(spacing: 10) {
                ProgressView()
                Text("Checking the store…")
                    .font(AtlasType.technical(11, weight: .medium))
                    .foregroundStyle(AtlasTheme.inkMuted)
            }
            .frame(minHeight: 52)
            .accessibilityIdentifier("access.atlas.loading")
        case .unavailable(let message):
            AccessStateNotice(text: message, identifier: "access.atlas.unavailable")
            AccessQuietRow(title: "TRY AGAIN", identifier: "access.atlas.retry") {
                Task { await commerce.refresh() }
            }
        case .ready:
            VStack(spacing: 12) {
                if let sixMonth = commerce.atlasSixMonthProduct {
                    durationButton(
                        product: sixMonth,
                        caption: "Renews every 6 months",
                        badge: nil,
                        identifier: "access.atlas.sixmonth"
                    )
                }
                if let annual = commerce.atlasAnnualProduct {
                    durationButton(
                        product: annual,
                        caption: "Renews annually",
                        badge: commerce.annualIsBetterMonthlyValue ? "Best value" : nil,
                        identifier: "access.atlas.annual"
                    )
                }
                if commerce.atlasSixMonthProduct == nil && commerce.atlasAnnualProduct == nil {
                    AccessStateNotice(
                        text: "Atlas is not available in this build.",
                        identifier: "access.atlas.missing"
                    )
                }
            }
        }
    }

    private func durationButton(
        product: CommerceProduct,
        caption: String,
        badge: String?,
        identifier: String
    ) -> some View {
        Button {
            Task { await commerce.purchase(productID: product.id) }
        } label: {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 8) {
                        Text(product.localizedTitle)
                            .font(AtlasType.technical(12, weight: .bold))
                            .tracking(0.8)
                        if let badge {
                            Text(badge.uppercased())
                                .font(AtlasType.technical(8, weight: .bold))
                                .tracking(1)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .overlay(Rectangle().stroke(AtlasTheme.sepia, lineWidth: 1))
                                .foregroundStyle(AtlasTheme.sepia)
                        }
                    }
                    Text(caption)
                        .font(AtlasType.technical(10, weight: .medium))
                        .foregroundStyle(AtlasTheme.inkMuted)
                }
                Spacer()
                if commerce.purchasePhase == .purchasing(productID: product.id) {
                    ProgressView()
                } else {
                    Text(product.localizedPrice)
                        .font(AtlasType.technical(13, weight: .semibold))
                }
            }
            .foregroundStyle(AtlasTheme.ink)
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(AtlasTheme.paperFresh)
            .overlay(Rectangle().stroke(AtlasTheme.ruleEdge, lineWidth: 1))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isPurchasing)
        .accessibilityIdentifier(identifier)
        .accessibilityLabel("\(product.localizedTitle), \(product.localizedPrice), \(caption)\(badge.map { ", \($0)" } ?? "")")
        .accessibilityAddTraits(.isButton)
    }

    private var isPurchasing: Bool {
        if case .purchasing = commerce.purchasePhase { return true }
        return false
    }
}

/// Opens Apple's subscription management. Provider-neutral: a plain URL
/// route rather than an SDK call from the view layer.
struct ManageSubscriptionRow: View {
    @Environment(\.openURL) private var openURL
    let identifier: String

    var body: some View {
        AccessQuietRow(title: "MANAGE SUBSCRIPTION", identifier: identifier) {
            if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
                openURL(url)
            }
        }
    }
}
