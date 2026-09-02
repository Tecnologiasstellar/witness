import SwiftUI
import WitnessCore

struct SpecimenDetailView: View {
    let species: SpeciesRecord
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                HStack {
                    Button("BACK") { dismiss() }
                        .font(AtlasType.technical(11, weight: .bold))
                        .tracking(1.15)
                        .frame(minWidth: 44, minHeight: 44, alignment: .leading)
                        .contentShape(Rectangle())
                    Spacer()
                    Text("SPECIMEN NOTES")
                        .font(AtlasType.technical(10, weight: .semibold))
                        .tracking(1.2)
                }
                .foregroundStyle(AtlasTheme.sepia)

                figure("FIG. 01 · GENERALIZED RANGE", accessibility: "Figure 1. Generalized range: \(species.generalizedRange)") {
                    RangeFigure()
                } caption: {
                    Text(species.generalizedRange)
                }

                figure("FIG. 02 · PREY", accessibility: "Figure 2. Prey data is not yet verified.") {
                    Text("NOT YET VERIFIED")
                        .font(AtlasType.display(28, weight: .semibold))
                        .frame(maxWidth: .infinity, minHeight: 112)
                        .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
                } caption: {
                    Text("No reviewed prey figure is bundled with this local record.")
                }

                figure("FIG. 03 · CURRENT BUNDLED STORY", accessibility: "Figure 3. Gillnet bycatch is described in the current bundled story.") {
                    GillnetFigure(species: species)
                } caption: {
                    Text("Gillnet bycatch is the single cause described in the bundled story. Read the sources before making any broader claim.")
                }

                actionSection
                sources
            }
            .padding(22)
            .foregroundStyle(AtlasTheme.ink)
        }
        .background(AtlasPaper().ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }

    private func figure<Content: View, Caption: View>(_ title: String, accessibility: String, @ViewBuilder content: () -> Content, @ViewBuilder caption: () -> Caption) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(AtlasType.technical(10, weight: .bold))
                .tracking(1.25)
                .foregroundStyle(AtlasTheme.sepia)
            content()
            caption()
                .font(.footnote)
                .foregroundStyle(AtlasTheme.inkMuted)
                .lineSpacing(3)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibility)
    }

    private var actionSection: some View {
        VStack(alignment: .leading, spacing: 11) {
            AtlasDivider()
            Text("ONE CREDIBLE ACTION")
                .font(AtlasType.technical(10, weight: .bold)).tracking(1.25)
                .foregroundStyle(AtlasTheme.sepia)
            Text(species.action.title)
                .font(AtlasType.display(23, weight: .semibold))
            Text(species.action.summary)
                .font(.body).foregroundStyle(AtlasTheme.inkMuted).lineSpacing(4)
            if let url = URL(string: species.action.destinationURL) {
                Link(destination: url) {
                    AtlasPill {
                        HStack {
                            Text("OPEN \(species.action.destinationOrganization.uppercased())")
                                .font(AtlasType.technical(10, weight: .bold)).tracking(1.05)
                            Spacer()
                            AtlasIconView(icon: .returnMark, size: 15, color: AtlasTheme.sepia)
                        }
                        .padding(.horizontal, 18).foregroundStyle(AtlasTheme.sepia)
                    }
                }
                .accessibilityHint("Opens an official source outside Witness")
            }
        }
    }

    private var sources: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("SOURCES & VERIFICATION")
                .font(AtlasType.technical(10, weight: .bold)).tracking(1.25)
                .foregroundStyle(AtlasTheme.sepia)
            ForEach(species.sources) { source in
                if let url = URL(string: source.url) {
                    Link(destination: url) {
                        Text("\(source.organization) · \(source.title)")
                            .font(.footnote).foregroundStyle(AtlasTheme.ink)
                    }
                }
            }
            Text("Record last fact-checked \(species.editorial.lastFactChecked). Artwork: \(species.media.depictionType.lowercased()).")
                .font(.caption).foregroundStyle(AtlasTheme.inkMuted)
        }
    }
}

private struct RangeFigure: View {
    var body: some View {
        Canvas { context, size in
            let inset = CGRect(origin: .zero, size: size).insetBy(dx: 12, dy: 12)
            var grid = Path()
            for step in stride(from: inset.minX, through: inset.maxX, by: 34) { grid.move(to: .init(x: step, y: inset.minY)); grid.addLine(to: .init(x: step, y: inset.maxY)) }
            for step in stride(from: inset.minY, through: inset.maxY, by: 24) { grid.move(to: .init(x: inset.minX, y: step)); grid.addLine(to: .init(x: inset.maxX, y: step)) }
            context.stroke(grid, with: .color(AtlasTheme.ruleSoft), lineWidth: 0.6)
            var coast = Path(); coast.move(to: .init(x: inset.minX + 20, y: inset.minY + 20)); coast.addCurve(to: .init(x: inset.maxX - 44, y: inset.maxY - 22), control1: .init(x: inset.maxX * 0.42, y: inset.minY + 8), control2: .init(x: inset.maxX * 0.58, y: inset.maxY))
            context.stroke(coast, with: .color(AtlasTheme.ink), lineWidth: 1.3)
            context.fill(Path(ellipseIn: .init(x: size.width * 0.58, y: size.height * 0.48, width: 7, height: 7)), with: .color(AtlasTheme.earth))
        }
        .frame(height: 145)
        .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
    }
}

private struct GillnetFigure: View {
    let species: SpeciesRecord
    var body: some View {
        ZStack {
            SpecimenPlate(species: species, showsLeaderLabels: false, opacity: 0.45)
            Canvas { context, size in
                var net = Path()
                for x in stride(from: 18, through: size.width - 18, by: 18) { net.move(to: .init(x: x, y: 0)); net.addLine(to: .init(x: x, y: size.height)) }
                for y in stride(from: 8, through: size.height, by: 16) { net.move(to: .init(x: 0, y: y)); net.addLine(to: .init(x: size.width, y: y)) }
                context.stroke(net, with: .color(AtlasTheme.earth.opacity(0.55)), lineWidth: 0.7)
            }
        }
        .frame(height: 138)
        .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
    }
}
