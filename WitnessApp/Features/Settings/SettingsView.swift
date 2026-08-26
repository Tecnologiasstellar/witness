import SwiftUI
import WitnessCore

struct SettingsView: View {
    @ObservedObject var commerce: CommerceModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("INDEX")
                        .font(AtlasType.display(34, weight: .semibold))
                        .accessibilityAddTraits(.isHeader)
                    accessSection
                    indexSection("EXPERIENCE", ["FOLLOWS SYSTEM APPEARANCE", "REDUCED MOTION RESPECTED"])
                    indexSection("PRIVACY", ["NO ACCOUNT", "NO PUBLIC ACTIVITY", "REFLECTIONS STAY ON THIS DEVICE"])
                    indexSection("BUILD", ["WEEKEND ZERO · 0.1", "BUNDLED CONTENT · PROTOTYPE"])
                    Text("Witness does not turn attention, shares, or self-reported actions into conservation outcomes.")
                        .font(.footnote).foregroundStyle(AtlasTheme.inkMuted).lineSpacing(3)
                }
                .padding(22).foregroundStyle(AtlasTheme.ink)
            }
            .background(AtlasPaper().ignoresSafeArea())
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("CLOSE") { dismiss() }.font(AtlasType.technical(10, weight: .bold)) } }
            .task { await commerce.startIfNeeded() }
        }
    }

    /// The Access overview: current standing, the two deeper works, restore,
    /// manage, and the quiet Support row. Facts only — no tier grid, no
    /// provider terminology, no raw entitlement identifiers.
    private var accessSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            AccessSectionHeading(text: "ACCESS").padding(.bottom, 8)

            staticRow(title: "WITNESS", detail: "Free", identifier: "access.overview.free")

            NavigationLink {
                FieldSeasonPreviewView(commerce: commerce)
            } label: {
                navigationRowLabel(
                    title: "FIELD SEASON",
                    detail: commerce.ownsFieldSeason ? "Owned" : "View"
                )
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("access.overview.fieldseason")

            NavigationLink {
                AtlasAccessSheet(commerce: commerce)
            } label: {
                navigationRowLabel(title: "ATLAS", detail: commerce.atlasStatusLine)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("access.overview.atlas")

            AccessQuietRow(
                title: "RESTORE PURCHASES",
                detail: commerce.restorePhase == .restoring ? "…" : nil,
                identifier: "access.overview.restore"
            ) {
                Task { await commerce.restore() }
            }

            if commerce.atlasIsActive {
                ManageSubscriptionRow(identifier: "access.overview.manage")
            }

            NavigationLink {
                SupportWitnessView(commerce: commerce)
            } label: {
                navigationRowLabel(title: "SUPPORT WITNESS", detail: nil)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("access.overview.support")

            PurchasePhaseNotice(purchasePhase: commerce.purchasePhase, restorePhase: commerce.restorePhase)
                .padding(.top, 12)

            if let verifiedLine = commerce.accessVerifiedLine {
                Text(verifiedLine)
                    .font(AtlasType.technical(9, weight: .medium))
                    .foregroundStyle(AtlasTheme.inkMuted)
                    .padding(.top, 8)
                    .accessibilityIdentifier("access.overview.verified")
            }
        }
    }

    private func staticRow(title: String, detail: String, identifier: String) -> some View {
        HStack {
            Text(title).font(AtlasType.technical(11, weight: .medium)).tracking(0.7)
            Spacer()
            Text(detail).font(AtlasType.technical(11, weight: .medium)).foregroundStyle(AtlasTheme.sepia)
            Text("·").foregroundStyle(AtlasTheme.sepia)
        }
        .frame(minHeight: 44)
        .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier(identifier)
    }

    private func navigationRowLabel(title: String, detail: String?) -> some View {
        HStack {
            Text(title).font(AtlasType.technical(11, weight: .medium)).tracking(0.7)
            Spacer()
            if let detail {
                Text(detail).font(AtlasType.technical(11, weight: .medium)).foregroundStyle(AtlasTheme.sepia)
            }
            Text("›").foregroundStyle(AtlasTheme.sepia)
        }
        .foregroundStyle(AtlasTheme.ink)
        .frame(minHeight: 44)
        .contentShape(Rectangle())
        .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
    }

    private func indexSection(_ title: String, _ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title).font(AtlasType.technical(10, weight: .bold)).tracking(1.2).foregroundStyle(AtlasTheme.sepia).padding(.bottom, 8)
            ForEach(items, id: \.self) { item in
                HStack { Text(item).font(AtlasType.technical(11, weight: .medium)).tracking(0.7); Spacer(); Text("·").foregroundStyle(AtlasTheme.sepia) }
                    .frame(minHeight: 44)
                    .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
            }
        }
    }
}
