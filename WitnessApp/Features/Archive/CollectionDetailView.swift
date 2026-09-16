import SwiftUI
import WitnessCore

/// The species dossier: the whole record for one animal — status, vitals,
/// range, the full sourced story, every plate in its series, the credible
/// action, protection programs, and sources.
///
/// One screen serves both entrances. From the cabinet it carries the
/// personal record (witnessed, helping); from the archive it carries the
/// week the species was featured. A past week should read the way it read
/// when it was current — that is what Atlas membership buys.
///
/// Access is decided before this view exists (`ArchiveAccessPolicy`, applied
/// at the archive grid). Nothing inside is gated; the dossier never learns
/// about commerce.
struct CollectionDetailView: View {
    let species: SpeciesRecord
    /// nil when reached from the archive rather than the witnessed cabinet.
    var witnessedAt: Date? = nil
    /// The ISO week this species was featured; nil from the cabinet.
    var featuredPeriod: String? = nil
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
                    if let stats = species.stats {
                        StatsGrid(stats: stats)
                    }
                    // The plates are interleaved rather than stacked, the way
                    // the weekly card reads: art, then the text it belongs to.
                    if let context = species.gallery?.dropFirst().first, UIImage(named: context) != nil {
                        ContextImage(assetName: context, caption: species.generalizedRange)
                    }
                    if let regions = species.habitatRegions, !regions.isEmpty {
                        GeneralizedRangeMap(regions: regions)
                    }
                    currentStatus
                    if let detail = species.gallery?.dropFirst(2).first, UIImage(named: detail) != nil {
                        DetailImage(assetName: detail, caption: "FIELD STUDY · \(species.commonName.uppercased())")
                    }
                    FieldNotes(species: species)
                    if let behavior = species.gallery?.dropFirst(3).first, UIImage(named: behavior) != nil {
                        ContextImage(assetName: behavior, caption: "Field observation")
                    }
                    noteBlock(title: "DID YOU KNOW", section: species.insight)
                    noteBlock(title: "LIFE CYCLE", section: species.reproduction)
                    if let scale = species.gallery?.dropFirst(4).first, UIImage(named: scale) != nil {
                        DetailImage(assetName: scale, caption: "SCALE STUDY · BESIDE A HUMAN FIGURE")
                    }
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
                    // The dossier scrolls a long way under this control, so the
                    // scrim alone left captions half-legible behind it. Material
                    // is the native idiom for a control floating over content.
                    .background(.ultraThinMaterial, in: Capsule())
                    .background(AtlasTheme.heroScrim.opacity(0.55), in: Capsule())
            }
            .buttonStyle(.plain)
            .padding(.leading, 12).padding(.top, 4)
        }
        .task {
            liveCount = await WitnessCounts.fetch(speciesID: species.id)
        }
        .task {
            let entrance = witnessedAt != nil ? "collection" : "archive"
            Task.detached {
                await WitnessSync.shared.logEvent(
                    "dossier_opened",
                    metadata: ["species": species.id, "entrance": entrance]
                )
            }
        }
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
                    .accessibilityLabel("\(species.media.depictionType) of \(species.commonName)")
            } else {
                SpecimenPlate(species: species)
                    .frame(height: 330)
            }
            LinearGradient(
                colors: [AtlasTheme.heroScrim.opacity(0.95), AtlasTheme.heroScrim.opacity(0.55), .clear],
                startPoint: .bottom, endPoint: .top
            )
            .frame(height: 170)
            .frame(maxWidth: .infinity, alignment: .bottom)

            VStack(alignment: .leading, spacing: 6) {
                StatusChip(status: species.conservationStatus)
                Text(species.commonName.uppercased())
                    .font(AtlasType.display(32, weight: .semibold))
                    // A long name at AX5 on an SE would otherwise clip.
                    .minimumScaleFactor(0.7)
                    .lineLimit(2)
                    .accessibilityIdentifier("dossier.speciesName")
                Text(species.scientificName)
                    .font(AtlasType.display(15, italic: true))
            }
            .foregroundStyle(AtlasTheme.heroInk)
            .padding(.horizontal, 24).padding(.bottom, 18)
        }
    }

    /// Each line is independent, and the block disappears entirely rather
    /// than leaving a 30pt hole on an archive species with no personal record.
    @ViewBuilder
    private var recordLine: some View {
        let showsCount = (liveCount ?? 0) > 0
        if featuredPeriod != nil || witnessedAt != nil || helping != nil || showsCount {
            VStack(alignment: .leading, spacing: 6) {
                if let featuredPeriod {
                    Text("FEATURED · \(featuredPeriod)")
                        .font(AtlasType.technical(11, weight: .bold)).tracking(1.2)
                        .foregroundStyle(AtlasTheme.sepia)
                }
                if let witnessedAt {
                    Text("WITNESSED · \(dateLabel(witnessedAt))")
                        .font(AtlasType.technical(11, weight: .bold)).tracking(1.2)
                        .foregroundStyle(AtlasTheme.sepia)
                }
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
    }

    /// A sourced aside. Renders nothing at all when the record has none —
    /// never a placeholder standing in for absent material.
    @ViewBuilder
    private func noteBlock(title: String, section: StorySection?) -> some View {
        if let section {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(AtlasType.technical(10, weight: .bold)).tracking(1.25)
                    .foregroundStyle(AtlasTheme.sepia)
                Text(section.text)
                    .font(AtlasType.display(19))
                    .lineSpacing(6)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AtlasTheme.paperFresh)
            .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
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

            // Every record carries one credible action, so every dossier has
            // a door even when no protection programs are on file (§5.1).
            actionBlock

            if let programs = species.programs, !programs.isEmpty {
                ForEach(programs) { program in
                    ProgramCard(program: program)
                }
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

            SharePlateButton(species: species)
        }
    }

    private var actionBlock: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("ONE CREDIBLE ACTION")
                .font(AtlasType.technical(10, weight: .bold)).tracking(1.25)
                .foregroundStyle(AtlasTheme.sepia)
            Text(species.action.title)
                .font(AtlasType.display(23, weight: .semibold))
            Text(species.action.summary)
                .font(.body).foregroundStyle(AtlasTheme.inkMuted).lineSpacing(4)
            Text("\(species.action.effort.uppercased()) · \(species.action.geographicApplicability.uppercased())")
                .font(AtlasType.technical(10, weight: .bold)).tracking(1.0)
                .foregroundStyle(AtlasTheme.sepia)
            if let url = URL(string: species.action.destinationURL) {
                Link(destination: url) {
                    HStack {
                        Text("OPEN \(species.action.destinationOrganization.uppercased())")
                            .font(AtlasType.technical(10, weight: .bold)).tracking(1.05)
                        Spacer()
                        AtlasIconView(icon: .returnMark, size: 14, color: AtlasTheme.sepia)
                    }
                    .foregroundStyle(AtlasTheme.sepia)
                    .padding(.horizontal, 14)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
                }
                .accessibilityHint("Opens an official source outside Witness")
            }
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
            Text("Record last fact-checked \(species.editorial.lastFactChecked). Artwork: \(species.media.depictionType.lowercased()).")
                .font(.caption).foregroundStyle(AtlasTheme.inkMuted).lineSpacing(3)
            if species.media.requiredAttribution != "None", !species.media.requiredAttribution.isEmpty {
                Text(species.media.requiredAttribution)
                    .font(.caption).foregroundStyle(AtlasTheme.inkMuted).lineSpacing(3)
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
            Text("VERIFIED \(program.lastVerified)")
                .font(AtlasType.technical(9, weight: .medium)).tracking(1.0)
                .foregroundStyle(AtlasTheme.inkMuted)
        }
        .padding(16)
        .background(AtlasTheme.paperFresh)
        .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
    }
}
