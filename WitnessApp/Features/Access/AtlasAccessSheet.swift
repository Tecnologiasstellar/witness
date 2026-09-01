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

                // The library shown, not described: a fan of real plates
                // from the archive, with one caption carrying the meaning.
                VStack(spacing: 14) {
                    PlateCollageStrip()
                    Text("THE LIVING LIBRARY · GROWING WEEKLY")
                        .font(AtlasType.technical(9, weight: .bold))
                        .tracking(1.4)
                        .foregroundStyle(AtlasTheme.sepia)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 2)

                Text("Every featured week beyond the free window, and every released field season — narrated — for as long as membership is active.")
                    .font(.callout)
                    .lineSpacing(4)

                holdings
                    .accessibilityIdentifier("access.atlas.production.notice")

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

    /// §9.2's concrete deliverables, as an inventory instead of a paragraph.
    private var holdings: some View {
        VStack(alignment: .leading, spacing: 0) {
            holdingRow(mark: "✦", title: "THE WEEKLY ARCHIVE", detail: "every featured plate beyond the free window")
            holdingRow(mark: "01", title: "FIELD SEASON ONE", detail: "complete and narrated, included while active")
            holdingRow(mark: "＋", title: "NEW SEASONS", detail: "join the library as they are published")
            holdingRow(mark: "♪", title: "NARRATION", detail: "every chapter read aloud, for the field")
        }
    }

    private func holdingRow(mark: String, title: String, detail: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(mark)
                .font(AtlasType.display(15, weight: .medium))
                .foregroundStyle(AtlasTheme.sepia)
                .frame(minWidth: 22, alignment: .leading)
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(AtlasType.technical(10, weight: .bold))
                    .tracking(1.1)
                Text(detail)
                    .font(AtlasType.display(14, weight: .regular, italic: true))
                    .foregroundStyle(AtlasTheme.inkMuted)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
        .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
        .accessibilityElement(children: .combine)
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
                        caption: caption("Renews every 6 months", for: sixMonth),
                        badge: nil,
                        identifier: "access.atlas.sixmonth"
                    )
                }
                if let annual = commerce.atlasAnnualProduct {
                    durationButton(
                        product: annual,
                        caption: caption("Renews annually", for: annual),
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

    /// The plain arithmetic, from live store decimals only — never invented.
    private func caption(_ base: String, for product: CommerceProduct) -> String {
        guard let perMonth = product.pricePerMonth, let code = product.currencyCode else { return base }
        let formatted = perMonth.formatted(.currency(code: code).precision(.fractionLength(2)))
        return "\(base) · about \(formatted) a month"
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
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(product.localizedTitle)
                            .font(AtlasType.technical(12, weight: .bold))
                            .tracking(1.0)
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
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                if commerce.purchasePhase == .purchasing(productID: product.id) {
                    ProgressView()
                } else {
                    Text(product.localizedPrice)
                        .font(AtlasType.display(21, weight: .semibold))
                }
            }
            .foregroundStyle(AtlasTheme.ink)
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 64)
            .background(AtlasTheme.paperFresh)
            .overlay(
                Rectangle()
                    .strokeBorder(AtlasTheme.ruleSoft, lineWidth: 1)
                    .padding(3)
            )
            .overlay(Rectangle().stroke(AtlasTheme.ruleEdge, lineWidth: 1))
            .contentShape(Rectangle())
        }
        .buttonStyle(AtlasPressStyle())
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
