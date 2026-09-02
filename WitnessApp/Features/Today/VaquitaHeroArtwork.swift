import SwiftUI
import WitnessCore

/// Renders the species' approved bundled artwork when its media record maps
/// to an asset in the catalog; otherwise falls back to the rights-safe,
/// code-drawn geometry (D-013).
struct SpecimenPlate: View {
    let species: SpeciesRecord
    var showsLeaderLabels = true
    var opacity: Double = 1
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        if let artwork = UIImage(named: species.media.assetID) {
            Image(uiImage: artwork)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(opacity)
                .accessibilityLabel("\(species.media.depictionType) of \(species.commonName)")
                .accessibilityAddTraits(.isImage)
        } else {
            fallbackGeometry
        }
    }

    private var fallbackGeometry: some View {
        GeometryReader { proxy in
            let bodyWidth = min(proxy.size.width * 0.82, 318)
            ZStack {
                AtlasPorpoiseShape()
                    .stroke(AtlasTheme.ink.opacity(opacity), style: StrokeStyle(lineWidth: 1.35, lineCap: .round, lineJoin: .round))
                    .background(AtlasPorpoiseShape().fill(AtlasTheme.paper.opacity(0.12)))
                    .frame(width: bodyWidth, height: min(proxy.size.height * 0.62, 94))
                    .rotationEffect(.degrees(-7))

                if showsLeaderLabels && !dynamicTypeSize.isAccessibilitySize {
                    leader("tall dorsal fin", x: 0.58, y: 0.10)
                    leader("beakless head", x: 0.76, y: 0.26)
                    leader("pale flank", x: 0.10, y: 0.77)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Abstract prototype depiction of \(species.commonName). Artwork rights remain pending approval.")
    }

    private func leader(_ title: String, x: CGFloat, y: CGFloat) -> some View {
        Text(title)
            .font(AtlasType.display(10.5, italic: true))
            .foregroundStyle(AtlasTheme.sepia)
            .position(x: 318 * x, y: 184 * y)
            .accessibilityHidden(true)
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

private struct AtlasPorpoiseShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY * 1.04))
        path.addCurve(to: CGPoint(x: rect.maxX * 0.78, y: rect.midY * 0.80), control1: CGPoint(x: rect.maxX * 0.20, y: rect.minY), control2: CGPoint(x: rect.maxX * 0.64, y: rect.minY * 0.8))
        path.addCurve(to: CGPoint(x: rect.maxX * 0.94, y: rect.midY * 0.50), control1: CGPoint(x: rect.maxX * 0.86, y: rect.midY * 0.76), control2: CGPoint(x: rect.maxX * 0.91, y: rect.midY * 0.58))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)); path.addLine(to: CGPoint(x: rect.maxX * 0.98, y: rect.midY * 0.72)); path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)); path.addLine(to: CGPoint(x: rect.maxX * 0.91, y: rect.midY * 1.08))
        path.addCurve(to: CGPoint(x: rect.maxX * 0.30, y: rect.midY * 1.42), control1: CGPoint(x: rect.maxX * 0.74, y: rect.maxY * 0.82), control2: CGPoint(x: rect.maxX * 0.48, y: rect.maxY * 0.94))
        path.addLine(to: CGPoint(x: rect.maxX * 0.40, y: rect.maxY)); path.addLine(to: CGPoint(x: rect.maxX * 0.22, y: rect.midY * 1.45))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.midY * 1.04), control1: CGPoint(x: rect.maxX * 0.11, y: rect.midY * 1.42), control2: CGPoint(x: rect.maxX * 0.02, y: rect.midY * 1.20))
        path.closeSubpath()
        return path
    }
}
