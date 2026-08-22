import SwiftUI

struct PlateFrame: View {
    var showsSecondRule = true
    var showsCornerTicks = true

    var body: some View {
        GeometryReader { geo in
            let outer = CGRect(x: 14, y: 44, width: max(0, geo.size.width - 28), height: max(0, geo.size.height - 148))
            let inner = outer.insetBy(dx: 5, dy: 5)
            ZStack {
                Path { $0.addRect(outer) }.stroke(AtlasTheme.sepia, lineWidth: 1)
                if showsSecondRule { Path { $0.addRect(inner) }.stroke(AtlasTheme.sepia, lineWidth: 0.5) }
                if showsCornerTicks {
                    PlateCornerTicks(inner: inner).stroke(AtlasTheme.sepia, lineWidth: 1)
                    PlateCornerDots(inner: inner).fill(AtlasTheme.sepia)
                }
            }
            .opacity(0.62)
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

struct AtlasPaper: View {
    var tone: Color = AtlasTheme.paper
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    var body: some View {
        ZStack {
            tone
            if !reduceTransparency {
                RadialGradient(colors: [Color.white.opacity(0.55), .clear], center: .init(x: 0.18, y: 0), startRadius: 0, endRadius: 520)
                RadialGradient(colors: [AtlasTheme.earth.opacity(0.14), .clear], center: .init(x: 0.92, y: 1), startRadius: 0, endRadius: 460)
                Canvas { context, size in
                    for x in stride(from: 0, through: size.width, by: 3) {
                        context.fill(Path(CGRect(x: x, y: 0, width: 1, height: size.height)), with: .color(AtlasTheme.sepia.opacity(0.032)))
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct AtlasPill<Label: View>: View {
    let label: Label
    init(@ViewBuilder label: () -> Label) { self.label = label() }

    var body: some View {
        label
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(AtlasTheme.paper.opacity(0.5), in: Capsule())
            .overlay(Capsule().stroke(AtlasTheme.ruleEdge, lineWidth: 1))
            .overlay(Capsule().inset(by: 4).stroke(AtlasTheme.ruleSoft, lineWidth: 1))
    }
}

private struct PlateCornerTicks: Shape {
    let inner: CGRect
    func path(in rect: CGRect) -> Path {
        let t: CGFloat = 14
        var p = Path()
        p.move(to: .init(x: inner.minX, y: inner.minY + t)); p.addLine(to: .init(x: inner.minX, y: inner.minY)); p.addLine(to: .init(x: inner.minX + t, y: inner.minY))
        p.move(to: .init(x: inner.maxX - t, y: inner.minY)); p.addLine(to: .init(x: inner.maxX, y: inner.minY)); p.addLine(to: .init(x: inner.maxX, y: inner.minY + t))
        p.move(to: .init(x: inner.maxX, y: inner.maxY - t)); p.addLine(to: .init(x: inner.maxX, y: inner.maxY)); p.addLine(to: .init(x: inner.maxX - t, y: inner.maxY))
        p.move(to: .init(x: inner.minX + t, y: inner.maxY)); p.addLine(to: .init(x: inner.minX, y: inner.maxY)); p.addLine(to: .init(x: inner.minX, y: inner.maxY - t))
        return p
    }
}

private struct PlateCornerDots: Shape {
    let inner: CGRect
    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = 1.2
        var p = Path()
        for point in [CGPoint(x: inner.minX + 7, y: inner.minY + 7), CGPoint(x: inner.maxX - 7, y: inner.minY + 7), CGPoint(x: inner.maxX - 7, y: inner.maxY - 7), CGPoint(x: inner.minX + 7, y: inner.maxY - 7)] {
            p.addEllipse(in: .init(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2))
        }
        return p
    }
}
