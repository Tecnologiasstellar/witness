import SwiftUI
import WitnessCore

/// The editorial sheet the reader pulls up over the hero plate: hook, sourced
/// story, one credible action, and sources — the "read" step of the ritual.
struct StorySheet: View {
    let species: SpeciesRecord
    let onOpenFigures: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(spacing: 8) {
                Capsule()
                    .fill(AtlasTheme.ruleSoft)
                    .frame(width: 44, height: 4)
                Text("FIELD NOTES")
                    .font(AtlasType.technical(10, weight: .bold)).tracking(1.4)
                    .foregroundStyle(AtlasTheme.sepia)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 12)

            Text(species.hook)
                .font(AtlasType.display(24, weight: .semibold, italic: true))
                .lineSpacing(5)
                .accessibilityIdentifier("today.story.hook")

            VStack(alignment: .leading, spacing: 18) {
                ForEach(species.story) { section in
                    Text(section.text)
                        .font(AtlasType.display(18))
                        .lineSpacing(7)
                        .accessibilityIdentifier("today.story.\(section.id)")
                }
            }
            .foregroundStyle(AtlasTheme.ink)

            actionSection
            evidenceSection
        }
        .padding(.horizontal, 26)
        .padding(.bottom, 30)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            UnevenRoundedRectangle(topLeadingRadius: 32, topTrailingRadius: 32)
                .fill(AtlasTheme.paperFresh)
                .shadow(color: AtlasTheme.ink.opacity(0.08), radius: 14, y: -4)
        )
        .foregroundStyle(AtlasTheme.ink)
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
            Text("EFFORT · \(species.action.effort.uppercased())")
                .font(AtlasType.technical(9, weight: .bold)).tracking(1.1)
                .foregroundStyle(AtlasTheme.inkMuted)
            if let url = URL(string: species.action.destinationURL) {
                Link(destination: url) {
                    HStack {
                        Text("OPEN \(species.action.destinationOrganization.uppercased())")
                            .font(AtlasType.technical(10, weight: .bold)).tracking(1.05)
                        Spacer()
                        AtlasIconView(icon: .returnMark, size: 15, color: AtlasTheme.sepia)
                    }
                    .padding(.horizontal, 18)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundStyle(AtlasTheme.sepia)
                    .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
                }
                .accessibilityHint("Opens an official source outside Witness")
            }
        }
    }

    private var evidenceSection: some View {
        VStack(alignment: .leading, spacing: 9) {
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
                            .frame(minHeight: 32, alignment: .leading)
                    }
                }
            }
            Text("Record last fact-checked \(species.editorial.lastFactChecked). Artwork: \(species.media.depictionType.lowercased()).")
                .font(.caption).foregroundStyle(AtlasTheme.inkMuted)
            Button("SPECIMEN FIGURES") { onOpenFigures() }
                .font(AtlasType.technical(10, weight: .bold)).tracking(1.1)
                .foregroundStyle(AtlasTheme.sepia)
                .frame(minHeight: 44)
        }
    }
}
