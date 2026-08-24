import SwiftUI
import UIKit

/// Atlas palette. Light values are authored; the dark values remain proposed until
/// they have been re-measured on a physical device.
enum AtlasTheme {
    static let paper = adaptive(light: 0xF1E8D5, dark: 0x15130F)
    static let paperAged = adaptive(light: 0xE9DCC1, dark: 0x1D1A15)
    static let paperFresh = adaptive(light: 0xF7F1E3, dark: 0x221E18)

    static let ink = adaptive(light: 0x25231F, dark: 0xEFE6D2)
    static let sepia = adaptive(light: 0x624936, dark: 0xC6A98A)
    static let inkMuted = adaptive(light: 0x6B6157, dark: 0xA79C8D)

    /// Decoration only. This fails the text contrast floor and must never be applied to Text.
    static let hairline = adaptive(light: 0x81796E, dark: 0x7C7365)
    static let earth = adaptive(light: 0x8A684A, dark: 0xB08C68)
    static let accentSage = adaptive(light: 0x65745A, dark: 0x93A886)

    /// Fixed (non-adaptive) pair for text sitting on hero imagery: the scrim is
    /// always deep ink and the type on it always warm paper, in both modes.
    static let heroScrim = Color(uiColor: UIColor(hex: 0x15130F))
    static let heroInk = Color(uiColor: UIColor(hex: 0xF1E8D5))

    static var ruleSoft: Color { sepia.opacity(0.22) }
    static var ruleEdge: Color { sepia.opacity(0.55) }
    static var ruleTab: Color { sepia.opacity(0.30) }

    private static func adaptive(light: UInt, dark: UInt) -> Color {
        Color(uiColor: UIColor { traits in
            UIColor(hex: traits.userInterfaceStyle == .dark ? dark : light)
        })
    }
}

/// Display is EB Garamond when it is deliberately bundled later; the current
/// system-serif fallback avoids shipping a font without a recorded license decision.
enum AtlasType {
    static func display(_ size: CGFloat, weight: Font.Weight = .medium, italic: Bool = false) -> Font {
        let name = italic ? "EBGaramond-Italic" : "EBGaramond-Regular"
        if UIFont(name: name, size: size) != nil {
            return Font.custom(name, size: size, relativeTo: .body).weight(weight)
        }
        var descriptor = UIFont.systemFont(ofSize: size, weight: uiWeight(weight)).fontDescriptor
        if let serif = descriptor.withDesign(.serif) { descriptor = serif }
        if italic, let italicized = descriptor.withSymbolicTraits(.traitItalic) { descriptor = italicized }
        return Font(UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(descriptor: descriptor, size: size)))
    }

    // Fixed point sizes wrapped through UIFontMetrics so every label follows
    // the user's Dynamic Type setting.
    static func technical(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        Font(UIFontMetrics(forTextStyle: .caption1).scaledFont(for: .systemFont(ofSize: size, weight: uiWeight(weight))))
    }

    private static func uiWeight(_ weight: Font.Weight) -> UIFont.Weight {
        switch weight {
        case .medium: .medium
        case .semibold: .semibold
        case .bold: .bold
        default: .regular
        }
    }

    static func tracking(_ em: CGFloat, at size: CGFloat, dynamicTypeSize: DynamicTypeSize) -> CGFloat {
        (dynamicTypeSize >= .accessibility1 ? min(em, 0.06) : em) * size
    }
}

/// Compatibility aliases let existing domain-driven views migrate one surface at a time.
enum WitnessTheme {
    static let accent = AtlasTheme.accentSage
    static let ink = AtlasTheme.ink
    static let secondaryInk = AtlasTheme.inkMuted
    static let paper = AtlasTheme.paper
    static let raisedPaper = AtlasTheme.paperFresh
    static let rule = AtlasTheme.ruleSoft
    static let endangered = AtlasTheme.sepia
}

private extension UIColor {
    convenience init(hex: UInt) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1
        )
    }
}
