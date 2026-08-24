import SwiftUI
import UIKit
import WitnessCore

/// Card v2 (docs/CARD_V2_BRIEF.md): immersive hero, curiosity hook, scannable
/// stats, context imagery, generalized range map, deep dive, and the
/// ceremonial in-app witness climax. Rendered for records carrying v2 content.
struct SpeciesCardV2: View {
    let species: SpeciesRecord
    @ObservedObject var model: AppModel
    let onOpenIndex: () -> Void
    let onOpenReflection: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeroHeader(species: species, onOpenIndex: onOpenIndex, onOpenReflection: onOpenReflection)
            VStack(alignment: .leading, spacing: 34) {
                HookBlock(hook: species.hook)
                if let stats = species.stats {
                    StatsGrid(stats: stats)
                }
                if let context = species.gallery?.dropFirst().first, UIImage(named: context) != nil {
                    ContextImage(assetName: context, caption: species.generalizedRange)
                }
                GeneralizedRangeMap(regions: species.habitatRegions ?? [species.generalizedRange])
                DeepDive(species: species)
                if let detail = species.gallery?.dropFirst(2).first, UIImage(named: detail) != nil {
                    DetailImage(assetName: detail, species: species)
                }
                FieldNotes(species: species)
            }
            .padding(.horizontal, 24)
            .padding(.top, 30)

            WitnessActionView(species: species, model: model, onOpenReflection: onOpenReflection)
                .padding(.horizontal, 24)
                .padding(.top, 40)

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
    let onOpenIndex: () -> Void
    let onOpenReflection: () -> Void

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let hero = species.gallery?.first, let image = UIImage(named: hero) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 470)
                    .clipped()
            } else {
                SpecimenPlate(species: species, showsLeaderLabels: false)
                    .frame(height: 470)
            }

            LinearGradient(
                colors: [AtlasTheme.heroScrim.opacity(0.88), AtlasTheme.heroScrim.opacity(0.35), .clear],
                startPoint: .bottom, endPoint: .top
            )
            .frame(height: 240)
            .frame(maxWidth: .infinity, alignment: .bottom)

            VStack(alignment: .leading, spacing: 6) {
                StatusChip(status: species.conservationStatus)
                Text(species.commonName.uppercased())
                    .font(AtlasType.display(40, weight: .semibold))
                    .accessibilityAddTraits(.isHeader)
                Text(species.scientificName)
                    .font(AtlasType.display(16, italic: true))
                    .opacity(0.85)
            }
            .foregroundStyle(AtlasTheme.heroInk)
            .padding(.horizontal, 24)
            .padding(.bottom, 22)
        }
        .accessibilityElement(children: .contain)
    }
}

/// Floating hero controls, overlaid by TodayView inside the safe area so they
/// never collide with the status bar.
struct HeroControls: View {
    let onOpenIndex: () -> Void
    let onOpenReflection: () -> Void

    var body: some View {
        HStack {
            heroButton(icon: .contents, label: "Contents index", id: "today.contents", action: onOpenIndex)
            Spacer()
            heroButton(icon: .nib, label: "Add a private note", id: "today.privateNote", action: onOpenReflection)
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

private struct StatusChip: View {
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
                .font(AtlasType.display(16, weight: .semibold))
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
    let species: SpeciesRecord

    var body: some View {
        HStack {
            Spacer(minLength: 0)
            VStack(spacing: 9) {
                Image(assetName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 250)
                    .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
                Text("FIELD STUDY · \(species.commonName.uppercased())")
                    .font(AtlasType.technical(9, weight: .bold)).tracking(1.2)
                    .foregroundStyle(AtlasTheme.inkMuted)
            }
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Detail study of \(species.commonName)")
    }
}

// MARK: - Range map

/// Reusable, deliberately generalized range figure: a soft hatched region on a
/// survey grid — evocative of place, useless for locating animals.
struct GeneralizedRangeMap: View {
    let regions: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("WHERE IT LIVES")
                .font(AtlasType.technical(10, weight: .bold)).tracking(1.25)
                .foregroundStyle(AtlasTheme.sepia)
            Canvas { context, size in
                let inset = CGRect(origin: .zero, size: size).insetBy(dx: 10, dy: 10)
                var grid = Path()
                for x in stride(from: inset.minX, through: inset.maxX, by: 30) {
                    grid.move(to: .init(x: x, y: inset.minY)); grid.addLine(to: .init(x: x, y: inset.maxY))
                }
                for y in stride(from: inset.minY, through: inset.maxY, by: 24) {
                    grid.move(to: .init(x: inset.minX, y: y)); grid.addLine(to: .init(x: inset.maxX, y: y))
                }
                context.stroke(grid, with: .color(AtlasTheme.ruleSoft), lineWidth: 0.6)

                let region = Path { p in
                    p.move(to: .init(x: inset.midX - inset.width * 0.22, y: inset.midY - inset.height * 0.18))
                    p.addCurve(
                        to: .init(x: inset.midX + inset.width * 0.24, y: inset.midY - inset.height * 0.04),
                        control1: .init(x: inset.midX - inset.width * 0.02, y: inset.midY - inset.height * 0.36),
                        control2: .init(x: inset.midX + inset.width * 0.18, y: inset.midY - inset.height * 0.22)
                    )
                    p.addCurve(
                        to: .init(x: inset.midX + inset.width * 0.05, y: inset.midY + inset.height * 0.26),
                        control1: .init(x: inset.midX + inset.width * 0.30, y: inset.midY + inset.height * 0.12),
                        control2: .init(x: inset.midX + inset.width * 0.18, y: inset.midY + inset.height * 0.26)
                    )
                    p.addCurve(
                        to: .init(x: inset.midX - inset.width * 0.22, y: inset.midY - inset.height * 0.18),
                        control1: .init(x: inset.midX - inset.width * 0.14, y: inset.midY + inset.height * 0.24),
                        control2: .init(x: inset.midX - inset.width * 0.30, y: inset.midY + inset.height * 0.02)
                    )
                }
                context.fill(region, with: .color(AtlasTheme.accentSage.opacity(0.22)))
                context.stroke(region, with: .color(AtlasTheme.accentSage), style: StrokeStyle(lineWidth: 1.3, dash: [5, 4]))

                var hatch = Path()
                for offset in stride(from: -size.height, through: size.width, by: 9) {
                    hatch.move(to: .init(x: offset, y: inset.maxY))
                    hatch.addLine(to: .init(x: offset + size.height, y: inset.minY))
                }
                context.clip(to: region)
                context.stroke(hatch, with: .color(AtlasTheme.accentSage.opacity(0.35)), lineWidth: 0.6)
            }
            .frame(height: 170)
            .background(AtlasTheme.paperFresh)
            .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))

            ForEach(regions, id: \.self) { region in
                HStack(spacing: 8) {
                    Circle().fill(AtlasTheme.accentSage).frame(width: 6, height: 6)
                    Text(region.uppercased())
                        .font(AtlasType.technical(10, weight: .semibold)).tracking(0.9)
                }
            }
            Text("Generalized region · exact locations are never shown")
                .font(.caption2).foregroundStyle(AtlasTheme.inkMuted)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Generalized range: \(regions.joined(separator: ", ")). Exact locations are never shown.")
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
                        .font(AtlasType.display(17))
                        .lineSpacing(6)
                }
            }
        }
    }
}

private struct FlowChips: View {
    let items: [String]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(items, id: \.self) { item in
                Text(item.uppercased())
                    .font(AtlasType.technical(9, weight: .bold)).tracking(0.9)
                    .lineLimit(1).minimumScaleFactor(0.75)
                    .padding(.horizontal, 11).padding(.vertical, 8)
                    .background(Capsule().fill(AtlasTheme.earth.opacity(0.12)))
                    .overlay(Capsule().stroke(AtlasTheme.earth.opacity(0.45), lineWidth: 1))
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
                    .font(AtlasType.display(18))
                    .lineSpacing(7)
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
                    AtlasIconView(icon: .fieldMark, size: 18, color: model.isWitnessed ? AtlasTheme.accentSage : AtlasTheme.paper)
                    Text(model.isSaving ? "RECORDING" : (model.isWitnessed ? "WITNESSED" : "I BEAR WITNESS"))
                        .font(AtlasType.technical(13, weight: .bold)).tracking(1.6)
                }
                .foregroundStyle(model.isWitnessed ? AtlasTheme.accentSage : AtlasTheme.paper)
                .frame(maxWidth: .infinity, minHeight: 58)
                .background(model.isWitnessed ? AtlasTheme.accentSage.opacity(0.13) : AtlasTheme.ink)
                .overlay(Rectangle().stroke(model.isWitnessed ? AtlasTheme.accentSage.opacity(0.5) : AtlasTheme.ink, lineWidth: 1))
                .shadow(color: model.isWitnessed ? AtlasTheme.accentSage.opacity(0.35) : .clear, radius: 14)
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
                Text("ONE WITNESS PER DAY · TAKES A MOMENT")
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
                    .font(AtlasType.display(17, weight: .semibold))
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
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
