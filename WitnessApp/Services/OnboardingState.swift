import Foundation
import WitnessCore

/// Whether the first-run introduction has been shown (D-026). One flag on
/// the device; the review copy reachable from INDEX never touches it.
@MainActor
final class OnboardingState: ObservableObject {
    @Published private(set) var hasSeen: Bool

    private let defaults = UserDefaults.standard
    private static let key = "onboarding.seen"

    init() {
        var seen = defaults.bool(forKey: Self.key)
#if DEBUG
        // UI tests: "force" resets first-run state so the introduction
        // renders for a fresh person; "real" honors the stored flag; any
        // other run under a per-test archive starts on Today, so the
        // existing ritual and access suites never meet the introduction.
        let environment = ProcessInfo.processInfo.environment
        switch environment["WITNESS_ONBOARDING"] {
        case "force":
            seen = false
            defaults.set(false, forKey: Self.key)
            ReminderService.shared.resetFirstRunState()
        case "real":
            break
        default:
            if let archive = environment["WITNESS_TEST_ARCHIVE"], !archive.isEmpty {
                seen = true
            }
        }
#endif
        hasSeen = seen
    }

    /// Records the introduction as seen, whether finished or skipped.
    func complete(pagesSeen: Int, skipped: Bool, reminder: String) {
        hasSeen = true
        defaults.set(true, forKey: Self.key)
        Task.detached {
            await WitnessSync.shared.logEvent("onboarding_completed", metadata: [
                "pages": String(pagesSeen),
                "skipped": skipped ? "true" : "false",
                "reminder": reminder,
            ])
        }
    }
}
