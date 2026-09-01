import SwiftUI
import WitnessCore

/// Shared quiet building blocks for the access surfaces.

struct AccessStateNotice: View {
    let text: String
    var identifier: String

    var body: some View {
        Text(text)
            .font(AtlasType.technical(12, weight: .medium))
            .foregroundStyle(AtlasTheme.ink)
            .lineSpacing(3)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(AtlasTheme.paperFresh)
            .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
            .accessibilityIdentifier(identifier)
    }
}

/// The action moment, set like a letterpress plate: solid ink, a hairline
/// inset rule, and the price in the display serif. One quiet press state.
struct AccessPrimaryButton: View {
    let title: String
    let subtitle: String?
    let isBusy: Bool
    let isEnabled: Bool
    let identifier: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                if isBusy {
                    ProgressView()
                        .tint(AtlasTheme.paper)
                        .frame(minHeight: 24)
                } else {
                    Text(title)
                        .font(AtlasType.technical(12, weight: .bold))
                        .tracking(1.35)
                    if let subtitle {
                        Text(subtitle)
                            .font(AtlasType.display(16, weight: .semibold))
                            .opacity(0.9)
                    }
                }
            }
            .foregroundStyle(AtlasTheme.paper)
            .frame(maxWidth: .infinity, minHeight: 58)
            .background(isEnabled ? AtlasTheme.ink : AtlasTheme.inkMuted)
            .overlay(
                Rectangle()
                    .strokeBorder(AtlasTheme.paper.opacity(0.35), lineWidth: 1)
                    .padding(3)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(AtlasPressStyle())
        .disabled(!isEnabled || isBusy)
        .accessibilityIdentifier(identifier)
        .accessibilityLabel(subtitle.map { "\(title), \($0)" } ?? title)
        .accessibilityAddTraits(.isButton)
    }
}

/// Shared press feedback for the purchase moments: a slight settle, like
/// pressing type into paper. Respects Reduce Motion by fading only.
struct AtlasPressStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.985 : 1)
            .opacity(configuration.isPressed ? 0.88 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// A fan of real plates from the archive — the paid library shown, not
/// described. Decorative: pair it with a text line that carries the meaning.
struct PlateCollageStrip: View {
    var assets: [String] = [
        "whooping-crane-plate-01",
        "gharial-plate-01",
        "snow-leopard-plate-01",
        "axolotl-plate-01",
        "staghorn-coral-plate-01",
    ]
    // 5 cards at 0.72 aspect with -26pt overlap stay under 330pt, so the
    // fan never widens the sheet past the smallest supported screen.
    var height: CGFloat = 118

    private static let tilts: [Double] = [-7, 4, -1.5, 6, -5]
    private static let lifts: [CGFloat] = [10, 3, 0, 5, 12]

    var body: some View {
        let cards = assets.compactMap { name in UIImage(named: name).map { (name: name, image: $0) } }
        if !cards.isEmpty {
            HStack(spacing: -26) {
                ForEach(Array(cards.enumerated()), id: \.element.name) { index, card in
                    plateCard(card.image)
                        .rotationEffect(.degrees(Self.tilts[index % Self.tilts.count]))
                        .offset(y: Self.lifts[index % Self.lifts.count])
                        .zIndex(index == cards.count / 2 ? 10 : Double(index))
                }
            }
            .frame(maxWidth: .infinity, minHeight: height + 16)
            .accessibilityHidden(true)
        }
    }

    private func plateCard(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: height * 0.72, height: height)
            .clipped()
            .padding(4)
            .background(AtlasTheme.paperFresh)
            .overlay(Rectangle().stroke(AtlasTheme.ruleEdge, lineWidth: 1))
            .shadow(color: AtlasTheme.heroScrim.opacity(0.16), radius: 9, y: 5)
    }
}

struct AccessQuietRow: View {
    let title: String
    var detail: String?
    let identifier: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(AtlasType.technical(11, weight: .medium))
                    .tracking(0.7)
                Spacer()
                if let detail {
                    Text(detail)
                        .font(AtlasType.technical(11, weight: .medium))
                        .foregroundStyle(AtlasTheme.sepia)
                }
                Text("·").foregroundStyle(AtlasTheme.sepia)
            }
            .foregroundStyle(AtlasTheme.ink)
            .frame(minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
        .accessibilityIdentifier(identifier)
        .accessibilityLabel(detail.map { "\(title), \($0)" } ?? title)
    }
}

struct AccessSectionHeading: View {
    let text: String

    var body: some View {
        Text(text)
            .font(AtlasType.technical(10, weight: .bold))
            .tracking(1.2)
            .foregroundStyle(AtlasTheme.sepia)
            .accessibilityAddTraits(.isHeader)
    }
}

/// Renders the outcome of a purchase or restore attempt as a calm state
/// line. Cancellation shows nothing; there is no error theater.
struct PurchasePhaseNotice: View {
    let purchasePhase: CommerceModel.PurchasePhase
    let restorePhase: CommerceModel.RestorePhase

    var body: some View {
        if let text {
            AccessStateNotice(text: text, identifier: "access.phase.notice")
        }
    }

    private var text: String? {
        switch purchasePhase {
        case .pendingApproval:
            return "This purchase is awaiting approval. Nothing is unlocked yet; it will complete on its own once approved."
        case .unlocked:
            return "Your access is confirmed."
        case .supportThanked:
            return "Thank you. Your support helps fund research, fact-checking, illustration, accessibility, and the operation of Witness."
        case .failed(let reason):
            return "The purchase did not complete. \(reason) You can try again; nothing was charged twice."
        case .idle, .purchasing:
            break
        }
        switch restorePhase {
        case .restoredWithChanges:
            return "Your purchases were restored."
        case .nothingFound:
            return "Restore finished. No previous purchases were found for this Apple account."
        case .failed(let reason):
            return "Restore did not complete. \(reason)"
        case .idle, .restoring:
            return nil
        }
    }
}
