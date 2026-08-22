import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("INDEX")
                        .font(AtlasType.display(34, weight: .semibold))
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
        }
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
