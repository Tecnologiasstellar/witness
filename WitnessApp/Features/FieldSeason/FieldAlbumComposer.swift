import UIKit
import WitnessCore

/// Renders the owned edition into a keepsake PDF: the season plate as cover,
/// one page per piece (title, opening lines, the reflective prompt, and its
/// doors as live links), and a closing index of every door. Pure derivation
/// from the reviewed edition data — a future season exports itself.
@MainActor
enum FieldAlbumComposer {
    private static let pageSize = CGRect(x: 0, y: 0, width: 612, height: 792)
    private static let margin: CGFloat = 64

    private static let paper = UIColor(red: 0.969, green: 0.953, blue: 0.918, alpha: 1)
    private static let ink = UIColor(red: 0.169, green: 0.149, blue: 0.125, alpha: 1)
    private static let inkMuted = UIColor(red: 0.427, green: 0.388, blue: 0.333, alpha: 1)
    private static let sepia = UIColor(red: 0.541, green: 0.353, blue: 0.169, alpha: 1)

    static func render(edition: FieldSeasonEdition, to url: URL) throws {
        let renderer = UIGraphicsPDFRenderer(bounds: pageSize, format: {
            let format = UIGraphicsPDFRendererFormat()
            format.documentInfo = [
                kCGPDFContextTitle as String: "Witness — \(edition.title)",
                kCGPDFContextCreator as String: "Witness",
            ]
            return format
        }())
        try renderer.writePDF(to: url) { context in
            coverPage(context, edition: edition)
            for piece in edition.chapters {
                piecePage(context, piece: piece)
            }
            doorsPage(context, edition: edition)
        }
    }

    // MARK: pages

    private static func coverPage(_ context: UIGraphicsPDFRendererContext, edition: FieldSeasonEdition) {
        context.beginPage()
        fillPaper(context)
        if let plate = UIImage(named: "season-plate-01") {
            let inset = pageSize.insetBy(dx: margin - 18, dy: margin - 18)
            let scale = min(inset.width / plate.size.width, inset.height / plate.size.height)
            let size = CGSize(width: plate.size.width * scale, height: plate.size.height * scale)
            plate.draw(in: CGRect(
                x: inset.midX - size.width / 2,
                y: inset.midY - size.height / 2,
                width: size.width,
                height: size.height
            ))
        } else {
            var y = pageSize.height * 0.4
            y = draw("WITNESS", font: technical(14, kern: 5), color: sepia, y: y, centered: true) + 12
            _ = draw(edition.title, font: serif(34, italic: true), color: ink, y: y, centered: true)
        }
    }

    private static func piecePage(_ context: UIGraphicsPDFRendererContext, piece: FieldSeasonChapter) {
        context.beginPage()
        fillPaper(context)
        var y = margin

        y = draw(kindLabel(piece), font: technical(10, kern: 3), color: sepia, y: y) + 10
        y = draw(piece.title, font: serif(27), color: ink, y: y) + 14
        rule(context, y: y, width: 72)
        y += 22

        if let opening = piece.sections.first?.entries.first?.text {
            y = draw(excerpt(opening), font: serif(12.5), color: ink, y: y, lineSpacing: 4.5) + 22
        }
        if let prompt = piece.sections.first(where: { $0.style == .prompt })?.entries.first?.text {
            rule(context, y: y, width: 48, centered: true)
            y += 16
            y = draw(prompt, font: serif(13.5, italic: true), color: ink, y: y,
                     centered: true, lineSpacing: 5, inset: 40) + 16
            rule(context, y: y, width: 48, centered: true)
            y += 30
        }
        if let action = piece.sections.first(where: { $0.style == .action }) {
            y = draw("ITS DOORS", font: technical(9, kern: 3), color: inkMuted, y: y) + 10
            for door in action.entries {
                y = doorRow(context, door: door, y: y) + 8
            }
        }
        footer(context, text: "WITNESS · FIELD SEASON ONE")
    }

    private static func doorsPage(_ context: UIGraphicsPDFRendererContext, edition: FieldSeasonEdition) {
        context.beginPage()
        fillPaper(context)
        var y = margin
        y = draw("EVERY DOOR IN THE SEASON", font: technical(10, kern: 3), color: sepia, y: y) + 10
        y = draw("Walk one. One is enough.", font: serif(24, italic: true), color: ink, y: y) + 14
        rule(context, y: y, width: 72)
        y += 22

        // The index flows onto further pages as the door count grows —
        // a future season with more pieces paginates itself.
        var seen = Set<String>()
        for piece in edition.chapters {
            for section in piece.sections where section.style == .action {
                for door in section.entries where !seen.contains(door.url ?? "") {
                    seen.insert(door.url ?? "")
                    if y > pageSize.height - 150 {
                        context.beginPage()
                        fillPaper(context)
                        y = margin
                        y = draw("EVERY DOOR IN THE SEASON, CONTINUED", font: technical(10, kern: 3), color: sepia, y: y) + 18
                    }
                    y = doorRow(context, door: door, y: y) + 7
                }
            }
        }
        let note = "Every count and claim in this album is sourced and dated in its chapter. " +
            "These organizations are independent of Witness; any support goes directly to them. " +
            "Exported \(Self.dateStamp()) — and the honest thing about a date is that it ages. " +
            "Witness — remember what is still here."
        if y > pageSize.height - 170 {
            context.beginPage()
            fillPaper(context)
            y = margin
        }
        _ = draw(note, font: serif(10.5, italic: true), color: inkMuted, y: y + 18, lineSpacing: 4)
    }

    // MARK: drawing helpers

    private static func fillPaper(_ context: UIGraphicsPDFRendererContext) {
        paper.setFill()
        context.fill(pageSize)
        sepia.withAlphaComponent(0.75).setStroke()
        let border = UIBezierPath(rect: pageSize.insetBy(dx: 22, dy: 22))
        border.lineWidth = 1
        border.stroke()
    }

    private static func doorRow(_ context: UIGraphicsPDFRendererContext, door: FieldSeasonEntry, y: CGFloat) -> CGFloat {
        var y = draw(door.lead ?? "", font: serif(12, weight: .semibold), color: ink, y: y) + 2
        y = draw(door.text, font: serif(10.5), color: inkMuted, y: y, lineSpacing: 3) + 2
        if let urlString = door.url, let url = URL(string: urlString) {
            let font = technical(10)
            let rect = textRect(urlString, font: font, y: y, inset: 0)
            draw(urlString, font: font, color: sepia, y: y)
            context.setURL(url, for: rect)
            y = rect.maxY
        }
        return y
    }

    private static func footer(_ context: UIGraphicsPDFRendererContext, text: String) {
        draw(text, font: technical(8, kern: 3), color: inkMuted, y: pageSize.height - 46, centered: true)
    }

    private static func rule(_ context: UIGraphicsPDFRendererContext, y: CGFloat, width: CGFloat, centered: Bool = false) {
        sepia.setFill()
        let x = centered ? pageSize.midX - width / 2 : margin
        context.fill(CGRect(x: x, y: y, width: width, height: 1))
    }

    @discardableResult
    private static func draw(
        _ text: String,
        font: UIFont,
        color: UIColor,
        y: CGFloat,
        centered: Bool = false,
        lineSpacing: CGFloat = 2,
        inset: CGFloat = 0
    ) -> CGFloat {
        let rect = textRect(text, font: font, y: y, lineSpacing: lineSpacing, inset: inset, centered: centered)
        attributed(text, font: font, color: color, lineSpacing: lineSpacing, centered: centered).draw(in: rect)
        return rect.maxY
    }

    private static func textRect(
        _ text: String,
        font: UIFont,
        y: CGFloat,
        lineSpacing: CGFloat = 2,
        inset: CGFloat = 0,
        centered: Bool = false
    ) -> CGRect {
        let width = pageSize.width - 2 * (margin + inset)
        let bounds = attributed(text, font: font, color: .black, lineSpacing: lineSpacing, centered: centered)
            .boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                          options: [.usesLineFragmentOrigin], context: nil)
        return CGRect(x: margin + inset, y: y, width: width, height: ceil(bounds.height))
    }

    private static func attributed(
        _ text: String,
        font: UIFont,
        color: UIColor,
        lineSpacing: CGFloat,
        centered: Bool
    ) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = lineSpacing
        paragraph.alignment = centered ? .center : .natural
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font, .foregroundColor: color, .paragraphStyle: paragraph,
        ]
        if let kern = font.fontDescriptor.fontAttributes[.init(rawValue: "witnessKern")] as? CGFloat {
            attributes[.kern] = kern
        }
        return NSAttributedString(string: text, attributes: attributes)
    }

    // MARK: type + text

    /// System serif (same recorded font decision as the app UI — no bundled font).
    private static func serif(_ size: CGFloat, weight: UIFont.Weight = .regular, italic: Bool = false) -> UIFont {
        let base = UIFont.systemFont(ofSize: size, weight: weight)
        var traits: UIFontDescriptor.SymbolicTraits = []
        if italic { traits.insert(.traitItalic) }
        var descriptor = base.fontDescriptor
        if let serif = descriptor.withDesign(.serif) { descriptor = serif }
        if let withTraits = descriptor.withSymbolicTraits(traits.union(descriptor.symbolicTraits)) {
            descriptor = withTraits
        }
        return UIFont(descriptor: descriptor, size: size)
    }

    private static func technical(_ size: CGFloat, kern: CGFloat = 1) -> UIFont {
        let font = UIFont.monospacedSystemFont(ofSize: size, weight: .medium)
        let descriptor = font.fontDescriptor.addingAttributes(
            [.init(rawValue: "witnessKern"): kern]
        )
        return UIFont(descriptor: descriptor, size: size)
    }

    private static func excerpt(_ text: String, limit: Int = 420) -> String {
        guard text.count > limit else { return text }
        let clipped = String(text.prefix(limit))
        if let lastPeriod = clipped.lastIndex(of: ".") {
            return String(clipped[...lastPeriod])
        }
        return clipped + "…"
    }

    private static func kindLabel(_ piece: FieldSeasonChapter) -> String {
        switch piece.resolvedKind {
        case .chapter: "CHAPTER \(String(format: "%02d", piece.number))"
        case .letter: "OPENING FIELD LETTER"
        case .interlude: "INTERLUDE"
        case .synthesis: "CLOSING SYNTHESIS"
        }
    }

    private static func dateStamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
