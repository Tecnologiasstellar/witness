import SwiftUI
import WitnessCore

struct ArchiveView: View {
    @ObservedObject var model: AppModel
    @State private var filter = "ALL"
    private let filters = ["ALL", "WITNESSED", "MARINE"]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("CABINET")
                    .font(AtlasType.display(32, weight: .semibold))
                Spacer()
                Text("\(visibleSpecies.count) PLATE\(visibleSpecies.count == 1 ? "" : "S")")
                    .font(AtlasType.technical(10, weight: .bold)).tracking(1.1)
                    .foregroundStyle(AtlasTheme.sepia)
            }
            filterRow
            if visibleSpecies.isEmpty {
                Spacer()
                Text("NO PLATES MATCH THIS VIEW")
                    .font(AtlasType.technical(11, weight: .bold)).tracking(1.1)
                    .foregroundStyle(AtlasTheme.inkMuted)
                    .frame(maxWidth: .infinity)
                Spacer()
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(visibleSpecies) { species in
                        NavigationLink { SpecimenDetailView(species: species) } label: { CabinetCard(species: species, isToday: species.id == model.species?.id) }
                            .buttonStyle(.plain)
                    }
                }
                Spacer()
            }
        }
        .padding(22)
        .foregroundStyle(AtlasTheme.ink)
        .background(AtlasPaper().ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }

    private var visibleSpecies: [SpeciesRecord] {
        guard let species = model.species else { return [] }
        switch filter {
        case "WITNESSED": return model.isWitnessed ? [species] : []
        case "MARINE": return [species]
        default: return [species]
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
    let species: SpeciesRecord
    let isToday: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            ZStack(alignment: .topTrailing) {
                SpecimenPlate(species: species, showsLeaderLabels: false).frame(height: 88)
                if isToday {
                    Text("TODAY")
                        .font(AtlasType.technical(8, weight: .bold)).tracking(1)
                        .foregroundStyle(AtlasTheme.sepia).padding(7)
                }
            }
            Text(species.commonName.uppercased())
                .font(AtlasType.technical(10, weight: .bold)).tracking(0.9)
                .lineLimit(1)
            Text(species.scientificName)
                .font(AtlasType.display(12, italic: true)).foregroundStyle(AtlasTheme.inkMuted)
        }
        .padding(11)
        .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
        .accessibilityLabel("\(species.commonName), \(species.scientificName)\(isToday ? ", today’s plate" : "")")
    }
}
