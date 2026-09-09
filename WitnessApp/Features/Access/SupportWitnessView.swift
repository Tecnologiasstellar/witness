import SwiftUI
import WitnessCore

/// A quiet, repeatable one-time tip. No entitlement, no badge, no rank,
/// no charity claim — and never placed beside the ritual itself.
struct SupportWitnessView: View {
    @ObservedObject var commerce: CommerceModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                AccessCover(eyebrow: "SUPPORT WITNESS", title: "Made by One Person", asset: "amur-leopard-detail-01")
                VStack(alignment: .leading, spacing: 22) {
                    Text("A one-time tip to the person making Witness. It funds research, illustration, narration, and keeps the app running. It unlocks nothing.")
                        .font(AtlasType.display(21, weight: .regular))
                        .lineSpacing(6)

                    tipArea
                    PurchasePhaseNotice(purchasePhase: commerce.purchasePhase, restorePhase: commerce.restorePhase)

                    // The work the tip funds, shown as work: three studies from
                    // the drawing table, not a benefits list.
                    VStack(spacing: 14) {
                        PlateCollageStrip(
                            assets: ["vaquita-detail-01", "amur-leopard-detail-01", "whooping-crane-detail-01"],
                            height: 104
                        )
                        Text("RESEARCH · ILLUSTRATION · NARRATION · ACCESSIBILITY")
                            .font(AtlasType.technical(11, weight: .bold))
                            .tracking(1.3)
                            .foregroundStyle(AtlasTheme.sepia)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)

                    Text("A tip changes nothing about your standing here. It goes to the making of Witness, not to a conservation organization, and carries no tax benefit.")
                        .font(AtlasType.display(16, weight: .regular))
                        .foregroundStyle(AtlasTheme.inkMuted)
                        .lineSpacing(5)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Your Witness remains free.")
                            .font(AtlasType.display(17, weight: .regular, italic: true))
                            .foregroundStyle(AtlasTheme.inkMuted)
                        Text("A tip is never expected here. It is always felt.")
                            .font(AtlasType.display(17, weight: .regular, italic: true))
                            .foregroundStyle(AtlasTheme.inkMuted)
                        Text("— Alberto, who makes Witness")
                            .font(AtlasType.display(16, weight: .regular, italic: true))
                            .foregroundStyle(AtlasTheme.sepia)
                    }
                    .padding(.top, 6)
                    .accessibilityElement(children: .combine)
                }
                .padding(22)
            }
            .foregroundStyle(AtlasTheme.ink)
        }
        .background(AtlasPaper().ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
        .toolbarBackground(.hidden, for: .navigationBar)
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
