import SwiftUI
import WitnessCore

/// Cabinet v2 (docs/CABINET_V2_BRIEF.md): WITNESSED and HELPING are the
/// personal collection — large image-led rows with name and dates. ARCHIVE
/// keeps every featured day and remains the Witness+ surface (D-016).
struct ArchiveView: View {
    @ObservedObject var model: AppModel
    @ObservedObject private var entitlements = PlusEntitlements.shared
    @State private var segment = "WITNESSED"
    @State private var isPaywallPresented = false
    private let segments = ["WITNESSED", "HELPING", "ARCHIVE"]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("CABINET")
                    .font(AtlasType.display(32, weight: .semibold))
                Spacer()
                Text(countLabel)
                    .font(AtlasType.technical(10, weight: .bold)).tracking(1.1)
                    .foregroundStyle(AtlasTheme.sepia)
            }
            segmentRow
            content
        }
        .padding(22)
        .foregroundStyle(AtlasTheme.ink)
        .background(AtlasPaper().ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $isPaywallPresented) { WitnessPlusPaywall() }
    }

    private var witnessedRows: [(species: SpeciesRecord, witnessedAt: Date, helping: HelpingRecord?)] {
        model.witnessedCollection
    }

    private var helpingRows: [(species: SpeciesRecord, witnessedAt: Date, helping: HelpingRecord?)] {
        witnessedRows.filter { $0.helping != nil }
    }

    private var countLabel: String {
        switch segment {
        case "HELPING": "\(helpingRows.count) SPECIES"
        case "ARCHIVE": "\(model.featuredPlates.count) PLATES"
        default: "\(witnessedRows.count) WITNESSED"
        }
    }

    @ViewBuilder
    private var content: some View {
        switch segment {
        case "ARCHIVE":
            archiveGrid
        case "HELPING":
            collectionList(
                rows: helpingRows,
                emptyTitle: "NO SPECIES MARKED YET",
                emptyBody: "Open a witnessed animal and tap “I’m helping this species” to follow its protection efforts here."
            )
        default:
            collectionList(
                rows: witnessedRows,
                emptyTitle: "NO WITNESSES YET",
                emptyBody: "Witness today’s species and it will take its place in your cabinet."
            )
        }
    }

    private func collectionList(
        rows: [(species: SpeciesRecord, witnessedAt: Date, helping: HelpingRecord?)],
        emptyTitle: String,
        emptyBody: String
    ) -> some View {
        Group {
            if rows.isEmpty {
                VStack(spacing: 10) {
                    Spacer()
                    Text(emptyTitle)
                        .font(AtlasType.technical(11, weight: .bold)).tracking(1.1)
                        .foregroundStyle(AtlasTheme.inkMuted)
                    Text(emptyBody)
                        .font(.footnote).foregroundStyle(AtlasTheme.inkMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(rows, id: \.species.id) { row in
                            NavigationLink {
                                CollectionDetailView(species: row.species, witnessedAt: row.witnessedAt, model: model)
                            } label: {
                                CollectionRow(species: row.species, witnessedAt: row.witnessedAt, helping: row.helping)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.bottom, 12)
                }
                .scrollIndicators(.hidden)
            }
        }
    }

    private var archiveGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(model.featuredPlates) { plate in
                    if model.isPlateUnlocked(plate, hasPlus: entitlements.hasPlus) {
                        NavigationLink { SpecimenDetailView(species: plate.species) } label: {
                            ArchiveCard(plate: plate, isToday: plate.localDay == model.featuredPlates.first?.localDay, isLocked: false)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Button { isPaywallPresented = true } label: {
                            ArchiveCard(plate: plate, isToday: false, isLocked: true)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.bottom, 12)
        }
        .scrollIndicators(.hidden)
    }

    private var segmentRow: some View {
        HStack(spacing: 8) {
            ForEach(segments, id: \.self) { item in
                Button(item) { segment = item }
                    .font(AtlasType.technical(9, weight: .bold)).tracking(1)
                    .foregroundStyle(segment == item ? AtlasTheme.paper : AtlasTheme.sepia)
                    .padding(.horizontal, 11).frame(minHeight: 34)
                    .background(segment == item ? AtlasTheme.ink : .clear)
                    .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(segment == item ? .isSelected : [])
            }
        }
    }
}

/// Opal-style collection row: large plate image, name, and record dates.
private struct CollectionRow: View {
    let species: SpeciesRecord
    let witnessedAt: Date
    let helping: HelpingRecord?

    var body: some View {
        HStack(spacing: 16) {
            Group {
                if let asset = species.gallery?.first, let image = UIImage(named: asset) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    SpecimenPlate(species: species, showsLeaderLabels: false)
                        .padding(6)
                }
            }
            .frame(width: 110, height: 110)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(AtlasTheme.ruleSoft, lineWidth: 1))

            VStack(alignment: .leading, spacing: 5) {
                Text("WITNESSED · \(witnessedAt.formatted(.dateTime.month(.abbreviated).day()).uppercased())")
                    .font(AtlasType.technical(9, weight: .bold)).tracking(1.1)
                    .foregroundStyle(AtlasTheme.sepia)
                Text(species.commonName)
                    .font(AtlasType.display(23, weight: .semibold))
                    .lineLimit(2).minimumScaleFactor(0.8)
                if let helping {
                    Text("HELPING SINCE · \(helping.startedAt.formatted(.dateTime.month(.abbreviated).day()).uppercased())")
                        .font(AtlasType.technical(9, weight: .bold)).tracking(1.0)
                        .foregroundStyle(AtlasTheme.accentSage)
                } else {
                    Text(species.conservationStatus.displayName.uppercased())
                        .font(AtlasType.technical(9, weight: .medium)).tracking(1.0)
                        .foregroundStyle(AtlasTheme.inkMuted)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(helping == nil ? AtlasTheme.paperFresh : AtlasTheme.accentSage.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(helping == nil ? AtlasTheme.ruleSoft : AtlasTheme.accentSage.opacity(0.45), lineWidth: 1))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
    }

    private var accessibilityText: String {
        var label = "\(species.commonName), witnessed \(witnessedAt.formatted(date: .abbreviated, time: .omitted))"
        if let helping {
            label += ", helping since \(helping.startedAt.formatted(date: .abbreviated, time: .omitted))"
        }
        return label
    }
}

private struct ArchiveCard: View {
    let plate: FeaturedPlate
    let isToday: Bool
    let isLocked: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            ZStack(alignment: .topTrailing) {
                Group {
                    if let asset = plate.species.gallery?.first, let image = UIImage(named: asset) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 120)
                            .clipped()
                    } else {
                        SpecimenPlate(species: plate.species, showsLeaderLabels: false).frame(height: 120)
                    }
                }
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
            .clipShape(RoundedRectangle(cornerRadius: 14))
            Text(plate.species.commonName.uppercased())
                .font(AtlasType.technical(10, weight: .bold)).tracking(0.9)
                .lineLimit(1)
                .opacity(isLocked ? 0.6 : 1)
            Text(plate.localDay)
                .font(AtlasType.display(12, italic: true)).foregroundStyle(AtlasTheme.inkMuted)
        }
        .padding(11)
        .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
        .accessibilityLabel("\(plate.species.commonName), featured \(plate.localDay)\(isLocked ? ", requires Witness Plus" : "")")
    }
}
