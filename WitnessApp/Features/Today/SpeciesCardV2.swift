import MapKit
import SwiftUI
import UIKit
import WitnessCore

/// Card v2 (docs/CARD_V2_BRIEF.md): immersive hero, curiosity hook, scannable
/// stats, context imagery, generalized range map, deep dive, and the
/// ceremonial in-app witness climax. Rendered for records carrying v2 content.
struct SpeciesCardV2: View {
    let species: SpeciesRecord
    @ObservedObject var model: AppModel
    var topInset: CGFloat = 0
    let onOpenIndex: () -> Void
    let onOpenReflection: () -> Void
    var onOpenFieldSeason: (() -> Void)? = nil
    var onOpenAtlas: (() -> Void)? = nil
    // Plain values, not the commerce model: the free card only needs to
    // know what the reader already holds, never how to sell anything.
    var ownsFieldSeason = false
    var atlasIsActive = false

    var body: some View {
        VStack(spacing: 0) {
            HeroHeader(species: species, topInset: topInset, onOpenIndex: onOpenIndex)
            VStack(alignment: .leading, spacing: 34) {
                HookBlock(hook: species.hook)
                if let stats = species.stats {
                    StatsGrid(stats: stats)
                }
                if let context = species.gallery?.dropFirst().first, UIImage(named: context) != nil {
                    ContextImage(assetName: context, caption: species.generalizedRange)
                }
                if let regions = species.habitatRegions, !regions.isEmpty {
                    GeneralizedRangeMap(regions: regions)
                }
                DeepDive(species: species)
                if let detail = species.gallery?.dropFirst(2).first, UIImage(named: detail) != nil {
                    DetailImage(assetName: detail, caption: "FIELD STUDY · \(species.commonName.uppercased())")
                }
                if let behavior = species.gallery?.dropFirst(3).first, UIImage(named: behavior) != nil {
                    ContextImage(assetName: behavior, caption: "Field observation")
                }
                FieldNotes(species: species)
                if let scale = species.gallery?.dropFirst(4).first, UIImage(named: scale) != nil {
                    DetailImage(assetName: scale, caption: "SCALE STUDY · BESIDE A HUMAN FIGURE")
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 30)

            WitnessActionView(species: species, model: model, onOpenReflection: onOpenReflection)
                .padding(.horizontal, 24)
                .padding(.top, 40)

            if let onOpenFieldSeason, let onOpenAtlas {
                WorksModule(
                    species: species,
                    model: model,
                    ownsFieldSeason: ownsFieldSeason,
                    atlasIsActive: atlasIsActive,
                    onOpenFieldSeason: onOpenFieldSeason,
                    onOpenAtlas: onOpenAtlas
                )
                .padding(.horizontal, 24)
                .padding(.top, 34)
            }

            EvidenceFooter(species: species)
                .padding(.horizontal, 24)
                .padding(.top, 34)
                .padding(.bottom, 28)
        }
        .foregroundStyle(AtlasTheme.ink)
    }
}

// MARK: - Hero

private struct HeroHeader: View {
    let species: SpeciesRecord
    let topInset: CGFloat
    let onOpenIndex: () -> Void

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let hero = species.gallery?.first, let image = UIImage(named: hero) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 470)
                    .clipped()
                    .accessibilityLabel("\(species.media.depictionType) of \(species.commonName)")
            } else {
                SpecimenPlate(species: species, showsLeaderLabels: false)
                    .frame(height: 470)
            }

            LinearGradient(
                colors: [AtlasTheme.heroScrim.opacity(0.95), AtlasTheme.heroScrim.opacity(0.55), .clear],
                startPoint: .bottom, endPoint: .top
            )
            .frame(height: 240)
            .frame(maxWidth: .infinity, alignment: .bottom)

            VStack(alignment: .leading, spacing: 6) {
                StatusChip(status: species.conservationStatus)
                Text(species.commonName.uppercased())
                    .font(AtlasType.display(40, weight: .semibold))
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityIdentifier("today.speciesName")
                Text(species.scientificName)
                    .font(AtlasType.display(16, italic: true))
            }
            .foregroundStyle(AtlasTheme.heroInk)
            .padding(.horizontal, 24)
            .padding(.bottom, 22)
        }
        .overlay(alignment: .top) {
            HeroControls(species: species, onOpenIndex: onOpenIndex)
                .padding(.top, topInset)
        }
        .accessibilityElement(children: .contain)
    }
}

/// Hero controls anchored to the hero image (they scroll away with it),
/// pushed below the status bar by the passed safe-area inset. The right
/// slot is the share door — the viral loop lives where the plate is most
/// beautiful; the private note keeps its quieter door further down.
struct HeroControls: View {
    let species: SpeciesRecord
    let onOpenIndex: () -> Void

    var body: some View {
        HStack {
            heroButton(icon: .contents, label: "Contents index", id: "today.contents", action: onOpenIndex)
            Spacer()
            ShareHeroButton(species: species)
        }
        .padding(.horizontal, 12)
        .padding(.top, 4)
    }

    private func heroButton(icon: AtlasIcon, label: String, id: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            AtlasIconView(icon: icon, size: 18, color: AtlasTheme.heroInk)
                .accessibilityHidden(true)
                .frame(width: 44, height: 44)
                .background(AtlasTheme.heroScrim.opacity(0.35), in: Circle())
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityIdentifier(id)
    }
}

struct StatusChip: View {
    let status: ConservationStatus

    var body: some View {
        Text(status.displayName.uppercased())
            .font(AtlasType.technical(10, weight: .bold)).tracking(1.3)
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background(Capsule().fill(AtlasTheme.heroInk.opacity(0.16)))
            .overlay(Capsule().stroke(AtlasTheme.heroInk.opacity(0.5), lineWidth: 1))
            .accessibilityLabel("Conservation status: \(status.displayName)")
    }
}

// MARK: - Hook

private struct HookBlock: View {
    let hook: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Rectangle().fill(AtlasTheme.sepia).frame(width: 44, height: 2)
            Text(hook)
                .font(AtlasType.display(28, weight: .semibold, italic: true))
                .lineSpacing(6)
                .accessibilityIdentifier("today.story.hook")
        }
    }
}

// MARK: - Stats

private struct StatsGrid: View {
    let stats: SpeciesStats

    private var trendText: String {
        switch stats.trend {
        case .decreasing: "Decreasing"
        case .stable: "Stable"
        case .increasing: "Increasing"
        case .unknown: "Unknown"
        }
    }

    private var trendArrow: String {
        switch stats.trend {
        case .decreasing: "↓"
        case .increasing: "↑"
        case .stable: "→"
        case .unknown: "·"
        }
    }

    private var trendSymbol: String {
        switch stats.trend {
        case .decreasing: "chart.line.downtrend.xyaxis"
        case .increasing: "chart.line.uptrend.xyaxis"
        case .stable, .unknown: "chart.xyaxis.line"
        }
    }

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
            StatTile(symbol: "ruler", label: "SIZE", value: stats.size)
            StatTile(symbol: "hourglass", label: "LIFESPAN", value: stats.lifespan)
            StatTile(symbol: "leaf", label: "DIET", value: stats.diet)
            if let population = stats.populationEstimate, let asOf = stats.populationAsOf {
                StatTile(symbol: trendSymbol, label: "REMAINING \(trendArrow)", value: "\(population)\n\(asOf)")
            } else {
                StatTile(symbol: trendSymbol, label: "TREND", value: trendText)
            }
        }
        .accessibilityElement(children: .contain)
    }
}

private struct StatTile: View {
    let symbol: String
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 7) {
                Image(systemName: symbol)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AtlasTheme.sepia)
                    .accessibilityHidden(true)
                Text(label)
                    .font(AtlasType.technical(9, weight: .bold)).tracking(1.1)
                    .foregroundStyle(AtlasTheme.sepia)
                    .lineLimit(1).minimumScaleFactor(0.8)
            }
            Text(value)
                .font(AtlasType.display(17, weight: .semibold))
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 92, alignment: .topLeading)
        .background(AtlasTheme.paperFresh)
        .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label): \(value.replacingOccurrences(of: "\n", with: ", "))")
        .accessibilityAddTraits(.isStaticText)
    }
}

// MARK: - Imagery

private struct ContextImage: View {
    let assetName: String
    let caption: String

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Image(assetName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(AtlasTheme.ruleSoft, lineWidth: 1))
            Text(caption.uppercased())
                .font(AtlasType.technical(9, weight: .bold)).tracking(1.2)
                .foregroundStyle(AtlasTheme.inkMuted)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Habitat illustration. \(caption)")
    }
}

private struct DetailImage: View {
    let assetName: String
    let caption: String

    var body: some View {
        HStack {
            Spacer(minLength: 0)
            VStack(spacing: 9) {
                Image(assetName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 260)
                    .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
                Text(caption)
                    .font(AtlasType.technical(9, weight: .bold)).tracking(1.2)
                    .foregroundStyle(AtlasTheme.inkMuted)
            }
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(caption.capitalized)
    }
}

// MARK: - Range map

/// Reusable, deliberately generalized range map: native MapKit (no external
/// service), non-interactive, showing a broad dashed circle — evocative of
/// place, useless for locating animals. The validator enforces the minimum
/// generalization radius.
struct GeneralizedRangeMap: View {
    let regions: [RangeRegion]

    private var cameraPosition: MapCameraPosition {
        guard let first = regions.first else { return .automatic }
        let viewport = max(first.radiusKm, 60) * 4_200
        return .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: first.latitude, longitude: first.longitude),
            latitudinalMeters: viewport,
            longitudinalMeters: viewport
        ))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("WHERE IT LIVES")
                .font(AtlasType.technical(10, weight: .bold)).tracking(1.25)
                .foregroundStyle(AtlasTheme.sepia)
            Map(position: .constant(cameraPosition), interactionModes: []) {
                ForEach(regions, id: \.name) { region in
                    MapCircle(
                        center: CLLocationCoordinate2D(latitude: region.latitude, longitude: region.longitude),
                        radius: region.radiusKm * 1_000
                    )
                    .foregroundStyle(AtlasTheme.accentSage.opacity(0.28))
                    .stroke(AtlasTheme.accentSage, style: StrokeStyle(lineWidth: 1.6, dash: [7, 5]))
                }
            }
            .mapStyle(.standard(elevation: .flat, pointsOfInterest: .excludingAll, showsTraffic: false))
            .frame(height: 220)
            .saturation(0.35)
            .allowsHitTesting(false)
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .overlay(RoundedRectangle(cornerRadius: 22).stroke(AtlasTheme.ruleSoft, lineWidth: 1))

            ForEach(regions, id: \.name) { region in
                HStack(spacing: 8) {
                    Circle().fill(AtlasTheme.accentSage).frame(width: 6, height: 6)
                    Text(region.name.uppercased())
                        .font(AtlasType.technical(11, weight: .semibold)).tracking(0.9)
                }
            }
            Text("Generalized region · exact locations are never shown")
                .font(.caption).foregroundStyle(AtlasTheme.inkMuted)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Generalized range: \(regions.map(\.name).joined(separator: ", ")). Exact locations are never shown.")
    }
}

// MARK: - Deep dive

private struct DeepDive: View {
    let species: SpeciesRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            if let threats = species.stats?.threats, !threats.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("WHAT THREATENS IT")
                        .font(AtlasType.technical(10, weight: .bold)).tracking(1.25)
                        .foregroundStyle(AtlasTheme.sepia)
                    FlowChips(items: threats)
                }
            }
            if let reproduction = species.reproduction {
                VStack(alignment: .leading, spacing: 10) {
                    Text("LIFE CYCLE")
                        .font(AtlasType.technical(10, weight: .bold)).tracking(1.25)
                        .foregroundStyle(AtlasTheme.sepia)
                    Text(reproduction.text)
                        .font(AtlasType.display(19))
                        .lineSpacing(7)
                }
            }
        }
    }
}

private struct FlowChips: View {
    let items: [String]

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
            ForEach(items, id: \.self) { item in
                Text(item.uppercased())
                    .font(AtlasType.technical(11, weight: .bold)).tracking(0.8)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.8)
                    .padding(.horizontal, 10).padding(.vertical, 12)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(RoundedRectangle(cornerRadius: 14).fill(AtlasTheme.earth.opacity(0.12)))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(AtlasTheme.earth.opacity(0.45), lineWidth: 1))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Story

private struct FieldNotes: View {
    let species: SpeciesRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("FIELD NOTES")
                .font(AtlasType.technical(10, weight: .bold)).tracking(1.25)
                .foregroundStyle(AtlasTheme.sepia)
            ForEach(species.story) { section in
                Text(section.text)
                    .font(AtlasType.display(20))
                    .lineSpacing(8)
                    .accessibilityIdentifier("today.story.\(section.id)")
            }
        }
    }
}

// MARK: - Ritual CTA

struct WitnessActionView: View {
    let species: SpeciesRecord
    @ObservedObject var model: AppModel
    let onOpenReflection: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 18) {
            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                Task { await model.witness() }
            } label: {
                HStack(spacing: 12) {
                    AtlasIconView(icon: .fieldMark, size: 18, color: AtlasTheme.paper)
                    Text(model.isSaving ? "RECORDING" : (model.isWitnessed ? "WITNESSED" : "I BEAR WITNESS"))
                        .font(AtlasType.technical(13, weight: .bold)).tracking(1.6)
                }
                .foregroundStyle(AtlasTheme.paper)
                .frame(maxWidth: .infinity, minHeight: 58)
                .background(model.isWitnessed ? AtlasTheme.accentSage : AtlasTheme.ink)
                .overlay(Rectangle().stroke(model.isWitnessed ? AtlasTheme.accentSage : AtlasTheme.ink, lineWidth: 1))
                .shadow(color: model.isWitnessed ? AtlasTheme.accentSage.opacity(0.45) : .clear, radius: 14)
            }
            .buttonStyle(.plain)
            .disabled(model.isWitnessed || model.isSaving)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.35), value: model.isWitnessed)
            .accessibilityIdentifier("today.witnessButton")
            .accessibilityHint(model.isWitnessed ? "Already recorded privately on this device" : "Records one private Witness on this device")

            if model.isWitnessed {
                witnessedReveal
                    .transition(reduceMotion ? .opacity : .opacity.combined(with: .move(edge: .bottom)))
            } else {
                Text("ONE WITNESS PER WEEK · TAKES A MOMENT")
                    .font(AtlasType.technical(8.5, weight: .medium)).tracking(1.0)
                    .foregroundStyle(AtlasTheme.inkMuted)
            }
        }
        .animation(reduceMotion ? nil : .easeOut(duration: 0.35), value: model.isWitnessed)
    }

    private var witnessedReveal: some View {
        VStack(alignment: .leading, spacing: 18) {
            if let count = model.witnessCount, count > 0 {
                Text("You are one of \(count.formatted(.number.grouping(.automatic))) people who have witnessed the \(species.commonName).")
                    .font(AtlasType.display(19, weight: .semibold))
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(alignment: .leading, spacing: 7) {
                Text("WHY THIS MATTERS")
                    .font(AtlasType.technical(9, weight: .bold)).tracking(1.2)
                    .foregroundStyle(AtlasTheme.sepia)
                Text("Attention is the first act of protection. Every witness joins a public count that shows the world someone is paying attention to this species. Learning its story is the first step—clearer, more specific ways to help will arrive here as Witness grows.")
                    .font(AtlasType.display(16))
                    .lineSpacing(6)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AtlasTheme.accentSage.opacity(0.10))
            .overlay(Rectangle().stroke(AtlasTheme.accentSage.opacity(0.4), lineWidth: 1))
            if let insight = species.insight {
                VStack(alignment: .leading, spacing: 7) {
                    Text("DID YOU KNOW")
                        .font(AtlasType.technical(9, weight: .bold)).tracking(1.2)
                        .foregroundStyle(AtlasTheme.sepia)
                    Text(insight.text)
                        .font(AtlasType.display(16, italic: true))
                        .lineSpacing(5)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AtlasTheme.paperFresh)
                .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
            }
            SharePlateButton(species: species, prominent: true)
            ReminderPrimer()
            Button(action: onOpenReflection) {
                HStack {
                    AtlasIconView(icon: .nib, size: 15, color: AtlasTheme.sepia)
                    Text("LEAVE A PRIVATE NOTE")
                        .font(AtlasType.technical(10, weight: .bold)).tracking(1.1)
                    Spacer()
                }
                .foregroundStyle(AtlasTheme.sepia)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, minHeight: 48)
                .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("today.leaveNote")
            if let url = URL(string: species.action.destinationURL) {
                VStack(alignment: .leading, spacing: 7) {
                    Text("GO FURTHER · \(species.action.effort.uppercased())")
                        .font(AtlasType.technical(9, weight: .bold)).tracking(1.1)
                        .foregroundStyle(AtlasTheme.inkMuted)
                    Link(destination: url) {
                        HStack {
                            Text(species.action.title.uppercased())
                                .font(AtlasType.technical(10, weight: .bold)).tracking(1.05)
                            Spacer()
                            AtlasIconView(icon: .returnMark, size: 15, color: AtlasTheme.sepia)
                        }
                        .foregroundStyle(AtlasTheme.sepia)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
                    }
                    .accessibilityHint("Opens \(species.action.destinationOrganization) outside Witness")
                }
            }
        }
    }
}

// MARK: - Evidence footer

private struct EvidenceFooter: View {
    let species: SpeciesRecord

    var body: some View {
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
                .font(.caption).foregroundStyle(AtlasTheme.inkMuted)
        }
    }
}

// MARK: - Field Season door

/// THE WORKS — the two editorial works, present on every card as content:
/// a flat matted plate for the finished edition, a small fan for the
/// growing library, one line on what they fund. Never a price, never a
/// button; each row is a door to the work's own surface. Sits after the
/// ritual and before the evidence, like a book's back matter.
private struct WorksModule: View {
    let species: SpeciesRecord
    @ObservedObject var model: AppModel
    let ownsFieldSeason: Bool
    let atlasIsActive: Bool
    let onOpenFieldSeason: () -> Void
    let onOpenAtlas: () -> Void

    private let edition = FieldSeasonLoader.loadBundledEdition()

    private var chapter: FieldSeasonChapter? {
        edition?.chapters.first { $0.resolvedKind == .chapter && $0.speciesID == species.id }
    }

    private var storyCount: Int {
        edition?.chapters.filter { $0.resolvedKind == .chapter }.count ?? 8
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle().fill(AtlasTheme.ruleEdge).frame(height: 1)
            Text("THE WORKS")
                .font(AtlasType.technical(10, weight: .bold)).tracking(1.25)
                .foregroundStyle(AtlasTheme.sepia)
                .padding(.top, 16)
                .padding(.bottom, 2)
                .accessibilityAddTraits(.isHeader)

            fieldSeasonRow
            atlasRow

            Text("Made by one person. Field Season and the Atlas support the making of Witness. Your Witness remains free.")
                .font(AtlasType.display(14, weight: .regular, italic: true))
                .foregroundStyle(AtlasTheme.inkMuted)
                .lineSpacing(3)
                .padding(.top, 14)
                .accessibilityIdentifier("today.works.mission")
        }
        .accessibilityElement(children: .contain)
    }

    // MARK: Field Season — a finished work, so a single flat plate.

    private var fieldSeasonRow: some View {
        let meta: String = ownsFieldSeason
            ? "FIELD SEASON ONE · OWNED"
            : atlasIsActive
                ? "FIELD SEASON ONE · INCLUDED"
                : "FIELD SEASON ONE · \(storyCount) STORIES"
        let title = chapter.map { "“\($0.title)”" } ?? "Field Season One"
        let note = chapter.map {
            "This week’s \(species.commonName.lowercased()) is chapter \(String(format: "%02d", $0.number)) of the finished edition."
        } ?? "\(storyCount) species along one ecological edge — complete and narrated."
        let art = chapter?.heroAssetID ?? "vaquita-plate-01"

        return worksRow(meta: meta, title: title, note: note, identifier: "today.fieldseason.door", label: "\(title), Field Season One. \(note) Opens the Field Season page.") {
            open(work: "fieldseason", state: ownsFieldSeason ? "owned" : atlasIsActive ? "included" : "unheld")
            onOpenFieldSeason()
        } visual: {
            if let image = UIImage(named: art) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 58, height: 74)
                    .clipped()
                    .padding(3)
                    .background(AtlasTheme.paperFresh)
                    .overlay(Rectangle().stroke(AtlasTheme.ruleEdge, lineWidth: 1))
            }
        }
    }

    // MARK: Atlas — a growing library, so a small fan of real plates.

    private var atlasAssets: [String] {
        let locked = model.featuredPlates
            .filter { !model.isPlateUnlocked($0, atlasActive: atlasIsActive) }
            .compactMap { $0.species.gallery?.first }
        // Below three real locked plates the fan would be padded with
        // fiction; a fixed trio of archive species is the honest stand-in.
        return locked.count >= 3
            ? Array(locked.prefix(3))
            : ["gharial-plate-01", "snow-leopard-plate-01", "whooping-crane-plate-01"]
    }

    private var atlasRow: some View {
        worksRow(
            meta: atlasIsActive ? "THE ATLAS · ACTIVE" : "THE LIVING LIBRARY · GROWING WEEKLY",
            title: "The Atlas",
            note: "Every past week and every season, narrated, while membership is active.",
            identifier: "today.atlas.door",
            label: "The Atlas, the living library. Opens the Atlas page."
        ) {
            open(work: "atlas", state: atlasIsActive ? "active" : "inactive")
            onOpenAtlas()
        } visual: {
            PlateCollageStrip(assets: atlasAssets, height: 58, spacing: -28)
                .frame(width: 100)
        }
    }

    // MARK: Row anatomy

    private func worksRow<Visual: View>(
        meta: String,
        title: String,
        note: String,
        identifier: String,
        label: String,
        action: @escaping () -> Void,
        @ViewBuilder visual: () -> Visual
    ) -> some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 14) {
                visual()
                    .frame(width: 100, alignment: .center)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    Text(meta)
                        .font(AtlasType.technical(9, weight: .bold)).tracking(1.1)
                        .foregroundStyle(AtlasTheme.sepia)
                        .lineLimit(1).minimumScaleFactor(0.8)
                    Text(title)
                        .font(AtlasType.display(17, weight: .medium))
                        .foregroundStyle(AtlasTheme.ink)
                        .multilineTextAlignment(.leading)
                    Text(note)
                        .font(AtlasType.display(14, weight: .regular, italic: true))
                        .foregroundStyle(AtlasTheme.inkMuted)
                        .lineSpacing(3)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 6)
                Text("›").foregroundStyle(AtlasTheme.sepia)
            }
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(AtlasPressStyle())
        .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier(identifier)
    }

    private func open(work: String, state: String) {
        Task.detached { await WitnessSync.shared.logEvent("works_shelf_opened", metadata: ["work": work, "state": state]) }
    }
}

#Preview("Species Card v2 — Vaquita") {
    ScrollView {
        SpeciesCardV2(
            species: (try? BundledSpeciesCatalog.load())!.first!,
            model: AppModel(),
            onOpenIndex: {},
            onOpenReflection: {}
        )
    }
    .scrollIndicators(.hidden)
    .background(AtlasPaper().ignoresSafeArea())
    .ignoresSafeArea(edges: .top)
}
