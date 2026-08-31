import SwiftUI
import WitnessCore

/// Preview and purchase surface for the first Field Season edition.
/// Permanent one-edition ownership; included while Atlas is active.
struct FieldSeasonPreviewView: View {
    @ObservedObject var commerce: CommerceModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Text("FIELD SEASON")
                    .font(AtlasType.display(30, weight: .semibold))
                    .accessibilityAddTraits(.isHeader)

                Text("A finite, authored edition about one ecological edge: its species, pressures, uncertainties, and possible forms of attention. Purchasing keeps this edition permanently — it is not a subscription.")
                    .font(.callout)
                    .lineSpacing(4)

                AccessSectionHeading(text: "THE EDITION CONTAINS")
                VStack(alignment: .leading, spacing: 8) {
                    deliverable("An opening field letter")
                    deliverable("Eight species chapters, each with its complete free record and a premium dossier")
                    deliverable("Two system interludes and a closing synthesis")
                    deliverable("The season plate, drawn for this edition")
                    deliverable("Every piece narrated — about eighty minutes of audio, with the full text on every page")
                    deliverable("A one-tap field album: the season as a keepsake PDF")
                }

                AccessStateNotice(
                    text: "This edition is complete: twelve pieces, every one shipped only after sources, rights, and review were finished. Corrections and accessibility updates arrive free.",
                    identifier: "access.fieldseason.production.notice"
                )

                AccessSectionHeading(text: "WHAT PERMANENT MEANS")
                Text("The purchased edition, its corrections, and its accessibility updates remain yours through your Apple account, restorable on this and future devices. It does not include future seasons, the Atlas library, or any claim of a conservation outcome. While an Atlas membership is active, this season is already included.")
                    .font(.footnote)
                    .foregroundStyle(AtlasTheme.inkMuted)
                    .lineSpacing(3)

                purchaseArea

                PurchasePhaseNotice(purchasePhase: commerce.purchasePhase, restorePhase: commerce.restorePhase)

                AccessQuietRow(title: "RESTORE PURCHASES", identifier: "access.fieldseason.restore") {
                    Task { await commerce.restore() }
                }

                Text("Your Witness remains free. The complete public record, sources, action, count, and your private reflections never require a purchase.")
                    .font(.footnote)
                    .foregroundStyle(AtlasTheme.inkMuted)
                    .lineSpacing(3)
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
    private var purchaseArea: some View {
        if commerce.ownsFieldSeason {
            AccessStateNotice(
                text: "Field Season is yours permanently.",
                identifier: "access.fieldseason.owned"
            )
            openEditionLink
        } else if commerce.atlasIsActive {
            AccessStateNotice(
                text: "Included with your active Atlas membership. If Atlas ever lapses, the season remains readable only with a separate permanent purchase.",
                identifier: "access.fieldseason.included"
            )
            openEditionLink
        } else {
            switch commerce.productsState {
            case .loading:
                HStack(spacing: 10) {
                    ProgressView()
                    Text("Checking the store…")
                        .font(AtlasType.technical(11, weight: .medium))
                        .foregroundStyle(AtlasTheme.inkMuted)
                }
                .frame(minHeight: 52)
                .accessibilityIdentifier("access.fieldseason.loading")
            case .unavailable(let message):
                AccessStateNotice(text: message, identifier: "access.fieldseason.unavailable")
                AccessQuietRow(title: "TRY AGAIN", identifier: "access.fieldseason.retry") {
                    Task { await commerce.refresh() }
                }
            case .ready:
                if let product = commerce.fieldSeasonProduct {
                    AccessPrimaryButton(
                        title: "KEEP FIELD SEASON PERMANENTLY",
                        subtitle: product.localizedPrice,
                        isBusy: commerce.purchasePhase == .purchasing(productID: product.id),
                        isEnabled: true,
                        identifier: "access.fieldseason.purchase"
                    ) {
                        Task { await commerce.purchase(productID: product.id) }
                    }
                } else {
                    AccessStateNotice(
                        text: "Field Season is not available in this build.",
                        identifier: "access.fieldseason.missing"
                    )
                }
            }
        }
    }

    private var openEditionLink: some View {
        NavigationLink {
            FieldSeasonView(commerce: commerce)
        } label: {
            HStack {
                Text("OPEN THE EDITION")
                    .font(AtlasType.technical(12, weight: .semibold))
                Spacer()
                Image(systemName: "chevron.right").font(.caption)
            }
            .foregroundStyle(AtlasTheme.sepia)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("access.fieldseason.open")
    }

    private func deliverable(_ text: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text("·").foregroundStyle(AtlasTheme.sepia)
            Text(text).font(.footnote).lineSpacing(2)
        }
    }
}
