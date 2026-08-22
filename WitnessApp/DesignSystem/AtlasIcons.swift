import SwiftUI

enum AtlasIcon: CaseIterable {
    case dusk, drawer, nib, contents, fieldMark, returnMark
}

struct AtlasIconView: View {
    let icon: AtlasIcon
    var size: CGFloat = 23
    var lineWidth: CGFloat = 1.35
    var color: Color = AtlasTheme.ink

    var body: some View {
        ZStack {
            AtlasIconShape(icon: icon)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
            AtlasIconDots(icon: icon).fill(color)
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}

private struct AtlasIconShape: Shape {
    let icon: AtlasIcon

    func path(in rect: CGRect) -> Path {
        let s = min(rect.width, rect.height) / 24
        func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint { .init(x: x * s, y: y * s) }
        var path = Path()

        switch icon {
        case .dusk:
            path.move(to: point(2, 17.5)); path.addLine(to: point(22, 17.5))
            path.addArc(center: point(12, 17.5), radius: 6.4 * s, startAngle: .degrees(180), endAngle: .degrees(360), clockwise: false)
            path.move(to: point(12, 4.4)); path.addLine(to: point(12, 6.4))
            path.move(to: point(5.4, 7.1)); path.addLine(to: point(6.8, 8.5))
            path.move(to: point(18.6, 7.1)); path.addLine(to: point(17.2, 8.5))
        case .drawer:
            path.addRect(.init(x: 3 * s, y: 5 * s, width: 18 * s, height: 14 * s))
            path.move(to: point(3, 9.7)); path.addLine(to: point(21, 9.7))
            path.move(to: point(3, 14.4)); path.addLine(to: point(21, 14.4))
        case .nib:
            path.move(to: point(12, 3)); path.addLine(to: point(16, 12)); path.addLine(to: point(12, 21)); path.addLine(to: point(8, 12)); path.closeSubpath()
            path.move(to: point(12, 10.5)); path.addLine(to: point(12, 18.5))
        case .contents:
            path.move(to: point(8.4, 6.4)); path.addLine(to: point(20.4, 6.4))
            path.move(to: point(8.4, 12)); path.addLine(to: point(16.4, 12))
            path.move(to: point(8.4, 17.6)); path.addLine(to: point(20.4, 17.6))
        case .fieldMark:
            path.addEllipse(in: .init(x: 4.6 * s, y: 4.6 * s, width: 14.8 * s, height: 14.8 * s))
            path.move(to: point(12, 1.6)); path.addLine(to: point(12, 5))
            path.move(to: point(12, 19)); path.addLine(to: point(12, 22.4))
            path.move(to: point(1.6, 12)); path.addLine(to: point(5, 12))
            path.move(to: point(19, 12)); path.addLine(to: point(22.4, 12))
        case .returnMark:
            path.move(to: point(20, 12)); path.addLine(to: point(5, 12))
            path.move(to: point(10.5, 7)); path.addLine(to: point(5, 12)); path.addLine(to: point(10.5, 17))
            path.move(to: point(20, 9)); path.addLine(to: point(20, 15))
        }
        return path
    }
}

private struct AtlasIconDots: Shape {
    let icon: AtlasIcon

    func path(in rect: CGRect) -> Path {
        let s = min(rect.width, rect.height) / 24
        var path = Path()
        func dot(_ x: CGFloat, _ y: CGFloat, _ radius: CGFloat) {
            path.addEllipse(in: .init(x: (x - radius) * s, y: (y - radius) * s, width: radius * 2 * s, height: radius * 2 * s))
        }
        switch icon {
        case .drawer: dot(12, 7.3, 0.9); dot(12, 12, 0.9); dot(12, 16.7, 0.9)
        case .nib: dot(12, 8.4, 1)
        case .contents: dot(4.7, 6.4, 1.1); dot(4.7, 12, 1.1); dot(4.7, 17.6, 1.1)
        case .fieldMark: dot(12, 12, 1.5)
        default: break
        }
        return path
    }
}
