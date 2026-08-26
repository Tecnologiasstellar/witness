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

struct AccessPrimaryButton: View {
    let title: String
    let subtitle: String?
    let isBusy: Bool
    let isEnabled: Bool
    let identifier: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 3) {
                if isBusy {
                    ProgressView()
                        .tint(AtlasTheme.paper)
                        .frame(minHeight: 20)
                } else {
                    Text(title)
                        .font(AtlasType.technical(12, weight: .bold))
                        .tracking(1.1)
                    if let subtitle {
                        Text(subtitle)
                            .font(AtlasType.technical(10, weight: .medium))
                            .opacity(0.85)
                    }
                }
            }
            .foregroundStyle(AtlasTheme.paper)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(isEnabled ? AtlasTheme.ink : AtlasTheme.inkMuted)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled || isBusy)
        .accessibilityIdentifier(identifier)
        .accessibilityLabel(subtitle.map { "\(title), \($0)" } ?? title)
        .accessibilityAddTraits(.isButton)
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
