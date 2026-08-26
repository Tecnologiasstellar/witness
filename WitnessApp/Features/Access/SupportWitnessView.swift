import SwiftUI
import WitnessCore

/// A quiet, repeatable one-time tip. No entitlement, no badge, no rank,
/// no charity claim — and never placed beside the ritual itself.
struct SupportWitnessView: View {
    @ObservedObject var commerce: CommerceModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Text("SUPPORT WITNESS")
                    .font(AtlasType.display(30, weight: .semibold))
                    .accessibilityAddTraits(.isHeader)

                Text("A one-time tip to the person making Witness. It helps fund research, fact-checking, illustration, narration, accessibility, hosting, and continued operation of the app.")
                    .font(.callout)
                    .lineSpacing(4)

                Text("A tip unlocks nothing and changes nothing about your standing here. It is not a donation to a conservation organization and is not tax-deductible.")
                    .font(.footnote)
                    .foregroundStyle(AtlasTheme.inkMuted)
                    .lineSpacing(3)

                tipArea

                PurchasePhaseNotice(purchasePhase: commerce.purchasePhase, restorePhase: commerce.restorePhase)
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
    private var tipArea: some View {
        switch commerce.productsState {
        case .loading:
            HStack(spacing: 10) {
                ProgressView()
                Text("Checking the store…")
                    .font(AtlasType.technical(11, weight: .medium))
                    .foregroundStyle(AtlasTheme.inkMuted)
            }
            .frame(minHeight: 52)
            .accessibilityIdentifier("access.support.loading")
        case .unavailable(let message):
            AccessStateNotice(text: message, identifier: "access.support.unavailable")
            AccessQuietRow(title: "TRY AGAIN", identifier: "access.support.retry") {
                Task { await commerce.refresh() }
            }
        case .ready:
            if let product = commerce.supportProduct {
                AccessPrimaryButton(
                    title: "LEAVE A ONE-TIME TIP",
                    subtitle: product.localizedPrice,
                    isBusy: commerce.purchasePhase == .purchasing(productID: product.id),
                    isEnabled: true,
                    identifier: "access.support.tip"
                ) {
                    Task { await commerce.purchase(productID: product.id) }
                }
            } else {
                AccessStateNotice(
                    text: "Support is not available in this build.",
                    identifier: "access.support.missing"
                )
            }
        }
    }
}
