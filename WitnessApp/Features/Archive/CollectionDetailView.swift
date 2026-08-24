import SwiftUI
import WitnessCore

/// Cabinet v2 detail (docs/CABINET_V2_BRIEF.md): a witnessed animal's page —
/// status, range, protection efforts, and the I'M HELPING commitment.
struct CollectionDetailView: View {
    let species: SpeciesRecord
    let witnessedAt: Date
    @ObservedObject var model: AppModel
    @Environment(\.dismiss) private var dismiss
    @State private var liveCount: Int?

    private var helping: HelpingRecord? { model.helpingRecord(for: species.id) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                hero
                VStack(alignment: .leading, spacing: 30) {
                    recordLine
                    if let regions = species.habitatRegions, !regions.isEmpty {
                        GeneralizedRangeMap(regions: regions)
                    }
                    currentStatus
                    helpSection
                    sourcesFooter
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
        }
        .scrollIndicators(.hidden)
        .background(AtlasPaper().ignoresSafeArea())
        .foregroundStyle(AtlasTheme.ink)
        .toolbar(.hidden, for: .navigationBar)
        // The nav bar is hidden, which also disables the system back gesture —
        // so the BACK control floats over the scroll and never leaves.
        .overlay(alignment: .topLeading) {
            Button { dismiss() } label: {
                Text("BACK")
                    .font(AtlasType.technical(10, weight: .bold)).tracking(1.2)
                    .foregroundStyle(AtlasTheme.heroInk)
                    .padding(.horizontal, 14).frame(minHeight: 40)
                    .background(AtlasTheme.heroScrim.opacity(0.45), in: Capsule())
            }
            .buttonStyle(.plain)
            .padding(.leading, 12).padding(.top, 4)
        }
        .task { liveCount = await WitnessCounts.fetch(speciesID: species.id) }
    }

    private var hero: some View {
        ZStack(alignment: .bottomLeading) {
            if let asset = species.gallery?.first, let image = UIImage(named: asset) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 330)
                    .clipped()
            } else {
                SpecimenPlate(species: species, showsLeaderLabels: false)
                    .frame(height: 330)
            }
            LinearGradient(
                colors: [AtlasTheme.heroScrim.opacity(0.85), .clear],
                startPoint: .bottom, endPoint: .top
            )
            .frame(height: 170)
            .frame(maxWidth: .infinity, alignment: .bottom)

            VStack(alignment: .leading, spacing: 6) {
                StatusChip(status: species.conservationStatus)
                Text(species.commonName.uppercased())
                    .font(AtlasType.display(32, weight: .semibold))
                Text(species.scientificName)
                    .font(AtlasType.display(15, italic: true)).opacity(0.85)
            }
            .foregroundStyle(AtlasTheme.heroInk)
            .padding(.horizontal, 24).padding(.bottom, 18)
        }
    }

    private var recordLine: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("WITNESSED · \(dateLabel(witnessedAt))")
                .font(AtlasType.technical(11, weight: .bold)).tracking(1.2)
                .foregroundStyle(AtlasTheme.sepia)
            if let helping {
                Text("HELPING SINCE · \(dateLabel(helping.startedAt))")
                    .font(AtlasType.technical(11, weight: .bold)).tracking(1.2)
                    .foregroundStyle(AtlasTheme.accentSage)
            }
            if let liveCount, liveCount > 0 {
                Text("\(liveCount.formatted(.number.grouping(.automatic))) WITNESSES WORLDWIDE")
                    .font(AtlasType.technical(11, weight: .medium)).tracking(1.1)
            }
        }
    }

    private var currentStatus: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("CURRENT STATUS")
                .font(AtlasType.technical(10, weight: .bold)).tracking(1.25)
                .foregroundStyle(AtlasTheme.sepia)
            Text("\(species.conservationStatus.displayName). \(species.hook)")
                .font(AtlasType.display(19))
                .lineSpacing(6)
            if let stats = species.stats {
                if let population = stats.populationEstimate, let asOf = stats.populationAsOf {
                    Text("REMAINING · \(population.uppercased()) · \(asOf.uppercased())")
                        .font(AtlasType.technical(11, weight: .bold)).tracking(1.0)
                        .foregroundStyle(AtlasTheme.sepia)
                }
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                    ForEach(stats.threats, id: \.self) { threat in
                        Text(threat.uppercased())
                            .font(AtlasType.technical(10, weight: .bold)).tracking(0.8)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.8)
                            .padding(.horizontal, 8).padding(.vertical, 10)
                            .frame(maxWidth: .infinity, minHeight: 46)
                            .background(RoundedRectangle(cornerRadius: 12).fill(AtlasTheme.earth.opacity(0.12)))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(AtlasTheme.earth.opacity(0.45), lineWidth: 1))
                    }
                }
            }
        }
    }

    private var helpSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            AtlasDivider()
            Text("HELP & PROTECTION")
                .font(AtlasType.technical(10, weight: .bold)).tracking(1.25)
                .foregroundStyle(AtlasTheme.sepia)

            if let programs = species.programs, !programs.isEmpty {
                ForEach(programs) { program in
                    ProgramCard(program: program)
                }
            } else {
                Text("Verified protection programs for this species are being reviewed and will appear here.")
                    .font(.footnote).foregroundStyle(AtlasTheme.inkMuted)
            }

            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                Task { await model.startHelping(speciesID: species.id) }
            } label: {
                HStack(spacing: 10) {
                    AtlasIconView(icon: .fieldMark, size: 16, color: AtlasTheme.paper)
                    Text(helping == nil ? "I’M HELPING THIS SPECIES" : "HELPING · SINCE \(dateLabel(helping!.startedAt))")
                        .font(AtlasType.technical(11, weight: .bold)).tracking(1.3)
                }
                .foregroundStyle(AtlasTheme.paper)
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(helping == nil ? AtlasTheme.ink : AtlasTheme.accentSage)
            }
            .buttonStyle(.plain)
            .disabled(helping != nil)
            .accessibilityIdentifier("cabinet.helpingButton")

            Text("Helping means you follow this species and engage with its protection efforts. Witness records your commitment; it does not verify outcomes.")
                .font(.caption).foregroundStyle(AtlasTheme.inkMuted).lineSpacing(3)
        }
    }

    private var sourcesFooter: some View {
        VStack(alignment: .leading, spacing: 8) {
            AtlasDivider()
            Text("SOURCES & VERIFICATION")
                .font(AtlasType.technical(10, weight: .bold)).tracking(1.25)
                .foregroundStyle(AtlasTheme.sepia)
            ForEach(species.sources) { source in
                if let url = URL(string: source.url) {
                    Link(destination: url) {
                        Text("\(source.organization) · \(source.title)")
                            .font(.footnote).foregroundStyle(AtlasTheme.ink)
                            .multilineTextAlignment(.leading)
                            .frame(minHeight: 30, alignment: .leading)
                    }
                }
            }
        }
    }

    private func dateLabel(_ date: Date) -> String {
        date.formatted(.dateTime.month(.abbreviated).day().year()).uppercased()
    }
}

private struct ProgramCard: View {
    let program: ConservationProgram

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(program.organization.uppercased())
                    .font(AtlasType.technical(9, weight: .bold)).tracking(1.1)
                    .foregroundStyle(AtlasTheme.sepia)
                Spacer()
                if program.kind == .sponsor {
                    Text("SPONSOR")
                        .font(AtlasType.technical(8, weight: .bold)).tracking(1.1)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Capsule().stroke(AtlasTheme.sepia, lineWidth: 1))
                        .foregroundStyle(AtlasTheme.sepia)
                }
            }
            Text(program.title)
                .font(AtlasType.display(20, weight: .semibold))
            Text(program.summary)
                .font(.subheadline).foregroundStyle(AtlasTheme.inkMuted).lineSpacing(4)
            if let url = URL(string: program.url) {
                Link(destination: url) {
                    HStack {
                        Text("VIEW INITIATIVE")
                            .font(AtlasType.technical(10, weight: .bold)).tracking(1.05)
                        Spacer()
                        AtlasIconView(icon: .returnMark, size: 14, color: AtlasTheme.sepia)
                    }
                    .foregroundStyle(AtlasTheme.sepia)
                    .padding(.horizontal, 14)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
                }
                .accessibilityHint("Opens \(program.organization) outside Witness")
            }
        }
        .padding(16)
        .background(AtlasTheme.paperFresh)
        .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
    }
}
