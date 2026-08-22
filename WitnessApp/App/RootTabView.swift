import SwiftUI

enum AtlasTab: String, CaseIterable, Hashable {
    case today, cabinet, notes

    var title: String {
        switch self {
        case .today: "TODAY"
        case .cabinet: "CABINET"
        case .notes: "NOTES"
        }
    }

    var icon: AtlasIcon {
        switch self {
        case .today: .dusk
        case .cabinet: .drawer
        case .notes: .nib
        }
    }
}

struct RootTabView: View {
    @ObservedObject var model: AppModel
    @State private var selection: AtlasTab = .today
    @State private var isIndexPresented = false
    @State private var isReflectionPresented = false

    var body: some View {
        ZStack {
            AtlasPaper()
            Group {
                switch selection {
                case .today:
                    NavigationStack {
                        TodayView(model: model, onOpenIndex: { isIndexPresented = true }, onOpenReflection: { isReflectionPresented = true }, onWitnessed: { selection = .notes })
                    }
                case .cabinet:
                    NavigationStack { ArchiveView(model: model) }
                case .notes:
                    NavigationStack { WitnessedView(model: model) }
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            AtlasTabBar(selection: $selection)
        }
        .sheet(isPresented: $isIndexPresented) { SettingsView() }
        .sheet(isPresented: $isReflectionPresented) { PrivateReflectionSheet(model: model) }
    }
}

private struct AtlasTabBar: View {
    @Binding var selection: AtlasTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AtlasTab.allCases, id: \.self) { tab in
                Button { selection = tab } label: {
                    VStack(spacing: 4) {
                        AtlasIconView(icon: tab.icon, size: 18)
                        Text(tab.title)
                            .font(AtlasType.technical(9, weight: .semibold))
                            .tracking(1.15)
                    }
                    .foregroundStyle(selection == tab ? AtlasTheme.ink : AtlasTheme.inkMuted)
                    .frame(maxWidth: .infinity, minHeight: 62)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("atlas.tab.\(tab.rawValue)")
                .accessibilityLabel(tab.title.capitalized)
                .accessibilityAddTraits(selection == tab ? .isSelected : [])
            }
        }
        .background(AtlasTheme.paper)
        .overlay(alignment: .top) {
            Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1)
        }
    }
}
