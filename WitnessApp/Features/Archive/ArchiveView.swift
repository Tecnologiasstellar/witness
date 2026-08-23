import SwiftUI
import WitnessCore

struct ArchiveView: View {
    @ObservedObject var model: AppModel
    @ObservedObject private var entitlements = PlusEntitlements.shared
    @State private var filter = "ALL"
    @State private var isPaywallPresented = false
    private let filters = ["ALL", "WITNESSED"]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("CABINET")
                    .font(AtlasType.display(32, weight: .semibold))
                Spacer()
                Text("\(visiblePlates.count) PLATE\(visiblePlates.count == 1 ? "" : "S")")
                    .font(AtlasType.technical(10, weight: .bold)).tracking(1.1)
                    .foregroundStyle(AtlasTheme.sepia)
            }
            filterRow
            if visiblePlates.isEmpty {
                Spacer()
                Text("NO PLATES MATCH THIS VIEW")
                    .font(AtlasType.technical(11, weight: .bold)).tracking(1.1)
                    .foregroundStyle(AtlasTheme.inkMuted)
                    .frame(maxWidth: .infinity)
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(visiblePlates) { plate in
                            if model.isPlateUnlocked(plate, hasPlus: entitlements.hasPlus) {
                                NavigationLink { SpecimenDetailView(species: plate.species) } label: {
                                    CabinetCard(
                                        plate: plate,
                                        isToday: plate.localDay == todayDay,
                                        isLocked: false
                                    )
                                }
                                .buttonStyle(.plain)
                            } else {
                                Button { isPaywallPresented = true } label: {
                                    CabinetCard(plate: plate, isToday: false, isLocked: true)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .padding(22)
        .foregroundStyle(AtlasTheme.ink)
        .background(AtlasPaper().ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $isPaywallPresented) { WitnessPlusPaywall() }
    }

    private var todayDay: String? {
        model.featuredPlates.first?.localDay
    }

    private var visiblePlates: [FeaturedPlate] {
        let plates = model.featuredPlates
        switch filter {
        case "WITNESSED": return plates.filter { model.isPlateWitnessed($0) }
        default: return plates
        }
    }

    private var filterRow: some View {
        HStack(spacing: 8) {
            ForEach(filters, id: \.self) { item in
                Button(item) { filter = item }
                    .font(AtlasType.technical(9, weight: .bold)).tracking(1)
                    .foregroundStyle(filter == item ? AtlasTheme.paper : AtlasTheme.sepia)
                    .padding(.horizontal, 11).frame(minHeight: 34)
                    .background(filter == item ? AtlasTheme.ink : .clear)
                    .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(filter == item ? .isSelected : [])
            }
        }
    }
}

private struct CabinetCard: View {
    let plate: FeaturedPlate
    let isToday: Bool
    let isLocked: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            ZStack(alignment: .topTrailing) {
                SpecimenPlate(species: plate.species, showsLeaderLabels: false)
                    .frame(height: 88)
                    .opacity(isLocked ? 0.35 : 1)
                if isToday {
                    Text("TODAY")
                        .font(AtlasType.technical(8, weight: .bold)).tracking(1)
                        .foregroundStyle(AtlasTheme.sepia).padding(7)
                }
                if isLocked {
                    Text("WITNESS+")
                        .font(AtlasType.technical(8, weight: .bold)).tracking(1)
                        .foregroundStyle(AtlasTheme.sepia).padding(7)
                }
            }
            Text(plate.species.commonName.uppercased())
                .font(AtlasType.technical(10, weight: .bold)).tracking(0.9)
                .lineLimit(1)
                .opacity(isLocked ? 0.6 : 1)
            Text(plate.localDay)
                .font(AtlasType.display(12, italic: true)).foregroundStyle(AtlasTheme.inkMuted)
        }
        .padding(11)
        .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
        .accessibilityLabel(accessibilityText)
    }

    private var accessibilityText: String {
        var label = "\(plate.species.commonName), featured \(plate.localDay)"
        if isToday { label += ", today’s plate" }
        if isLocked { label += ", requires Witness Plus" }
        return label
    }
}
