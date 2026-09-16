import SwiftUI
import WitnessCore

/// Renders the species' approved bundled artwork. When the media record maps
/// to no asset it renders nothing: the old fallback drew a vaquita — with
/// "tall dorsal fin" / "beakless head" leader labels — for whatever species
/// failed the lookup, which is a false depiction. Fail closed instead.
struct SpecimenPlate: View {
    let species: SpeciesRecord
    var opacity: Double = 1

    var body: some View {
        if let artwork = UIImage(named: species.media.assetID) {
            Image(uiImage: artwork)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(opacity)
                .accessibilityLabel("\(species.media.depictionType) of \(species.commonName)")
                .accessibilityAddTraits(.isImage)
        } else {
            Color.clear
        }
    }
}

struct AtlasScaleRule: View {
    var body: some View {
        VStack(spacing: 3) {
            Canvas { context, size in
                let y = size.height / 2
                var line = Path()
                line.move(to: .init(x: 0, y: y)); line.addLine(to: .init(x: size.width, y: y))
                context.stroke(line, with: .color(AtlasTheme.hairline), lineWidth: 1)
                for x in [0, size.width * 0.25, size.width * 0.5, size.width * 0.75, size.width] {
                    let length: CGFloat = x == size.width * 0.5 ? 8 : (x == 0 || x == size.width ? 6 : 3)
                    var tick = Path(); tick.move(to: .init(x: x, y: y - length / 2)); tick.addLine(to: .init(x: x, y: y + length / 2))
                    context.stroke(tick, with: .color(AtlasTheme.hairline), lineWidth: 1)
                }
            }
            .frame(width: 132, height: 8)
            Text("SCALE UNAVAILABLE")
                .font(AtlasType.technical(8.5))
                .tracking(1.7)
                .foregroundStyle(AtlasTheme.inkMuted)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Scale unavailable for this abstract prototype depiction")
        .accessibilityAddTraits(.isStaticText)
    }
}

struct AtlasTally: View {
    let count: Int?
    let lastVerified: String

    private var countLine: String {
        guard let count else {
            return "COUNT UNAVAILABLE · LAST VERIFIED \(lastVerified)"
        }
        let formatted = count.formatted(.number.grouping(.automatic))
        return "\(formatted) WITNESS\(count == 1 ? "" : "ES") · COLLECTIVE COUNT"
    }

    var body: some View {
        VStack(spacing: 7) {
            HStack(spacing: 7) {
                ForEach(0..<8, id: \.self) { index in
                    Circle()
                        .stroke(AtlasTheme.hairline, lineWidth: 1)
                        .fill(index < min(count ?? 0, 8) ? AtlasTheme.sepia.opacity(0.55) : .clear)
                        .frame(width: 7, height: 7)
                }
            }
            Text(countLine)
                .font(AtlasType.technical(9, weight: .medium))
                .tracking(1.44)
                .foregroundStyle(AtlasTheme.ink)
                .multilineTextAlignment(.center)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(count.map { "\($0) witnesses, collective count" } ?? "Count unavailable")
        .accessibilityAddTraits(.isStaticText)
    }
}

struct AtlasDivider: View {
    var body: some View {
        HStack(spacing: 5) {
            Rectangle().fill(AtlasTheme.earth).frame(width: 18, height: 1)
            Circle().stroke(AtlasTheme.earth, lineWidth: 1).frame(width: 4, height: 4)
            Rectangle().fill(AtlasTheme.earth).frame(width: 18, height: 1)
        }
        .frame(height: 7)
        .accessibilityHidden(true)
    }
}
