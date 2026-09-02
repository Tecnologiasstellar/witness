import SwiftUI
@preconcurrency import UserNotifications
import WitnessCore

/// Weekly local-notification reminder (D-023; D-008: the iOS prompt fires
/// only after the first completed witness). Zero server infrastructure —
/// the catalog rotates on-device, so a repeating local notification is the
/// whole feature.
@MainActor
final class ReminderService: ObservableObject {
    static let shared = ReminderService()

    @Published private(set) var isEnabled: Bool
    @Published private(set) var hour: Int
    @Published private(set) var minute: Int
    /// The user enabled a reminder but iOS notification permission is off.
    @Published private(set) var isSystemDenied = false
    /// The post-first-witness primer was answered (any choice) — never ask again.
    @Published private(set) var primerAnswered: Bool
    /// A time was named during the introduction (D-026). `hour`/`minute`
    /// hold it; the primer turns it into a real reminder — and only then
    /// asks iOS. Needed because 8:00 is also the default and cannot signal
    /// intent on its own.
    @Published private(set) var hasPreference: Bool

    static let presets: [(label: String, hour: Int, minute: Int)] = [
        ("MORNING", 8, 0),
        ("MIDDAY", 12, 30),
        ("EVENING", 19, 0),
    ]

    private static let notificationID = "daily-ritual-reminder"
    private let defaults = UserDefaults.standard

    private init() {
        isEnabled = defaults.bool(forKey: "reminder.enabled")
        hour = defaults.object(forKey: "reminder.hour") as? Int ?? 8
        minute = defaults.object(forKey: "reminder.minute") as? Int ?? 0
        primerAnswered = defaults.bool(forKey: "reminder.primerAnswered")
        hasPreference = defaults.bool(forKey: "reminder.hasPreference")
        Task { await refreshAuthorization() }
    }

    /// Records a preferred time without touching the notification API.
    func setPreferredTime(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
        hasPreference = true
        defaults.set(hour, forKey: "reminder.hour")
        defaults.set(minute, forKey: "reminder.minute")
        defaults.set(true, forKey: "reminder.hasPreference")
    }

    /// "in the morning" / "at midday" / "in the evening" / "at 8:00 AM".
    var preferredPhrase: String {
        switch Self.presets.first(where: { $0.hour == hour && $0.minute == minute })?.label {
        case "MORNING": "in the morning"
        case "MIDDAY": "at midday"
        case "EVENING": "in the evening"
        default: "at \(timeLabel)"
        }
    }

#if DEBUG
    /// A forced introduction (UI tests) means a fresh person: the primer is
    /// unanswered and no time has been named.
    func resetFirstRunState() {
        primerAnswered = false
        hasPreference = false
        defaults.removeObject(forKey: "reminder.primerAnswered")
        defaults.removeObject(forKey: "reminder.hasPreference")
    }
#endif

    var timeLabel: String {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        let date = Calendar.current.date(from: components) ?? .now
        return date.formatted(date: .omitted, time: .shortened)
    }

    func markPrimerAnswered() {
        primerAnswered = true
        defaults.set(true, forKey: "reminder.primerAnswered")
    }

    func enable(hour: Int, minute: Int) async {
        markPrimerAnswered()
        let center = UNUserNotificationCenter.current()
        let granted = (try? await center.requestAuthorization(options: [.alert, .sound])) ?? false
        guard granted else {
            isSystemDenied = true
            isEnabled = false
            defaults.set(false, forKey: "reminder.enabled")
            return
        }

        isSystemDenied = false
        self.hour = hour
        self.minute = minute
        isEnabled = true
        hasPreference = false
        defaults.set(true, forKey: "reminder.enabled")
        defaults.set(hour, forKey: "reminder.hour")
        defaults.set(minute, forKey: "reminder.minute")
        defaults.set(false, forKey: "reminder.hasPreference")

        let content = UNMutableNotificationContent()
        content.title = "This week's species is waiting"
        content.body = "A new plate is on the table. Take one quiet minute to bear witness."
        content.sound = .default

        // Weekly cadence (D-023): one reminder per ritual week, on Monday,
        // when the new plate arrives.
        var trigger = DateComponents()
        trigger.weekday = 2
        trigger.hour = hour
        trigger.minute = minute
        let request = UNNotificationRequest(
            identifier: Self.notificationID,
            content: content,
            trigger: UNCalendarNotificationTrigger(dateMatching: trigger, repeats: true)
        )
        center.removePendingNotificationRequests(withIdentifiers: [Self.notificationID])
        try? await center.add(request)

        Task.detached {
            // Coarse hour only — no minute-level fingerprinting in analytics.
            await WitnessSync.shared.logEvent("reminder_enabled", metadata: ["hour": String(hour)])
        }
    }

    func disable() {
        isEnabled = false
        defaults.set(false, forKey: "reminder.enabled")
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [Self.notificationID])
        Task.detached {
            await WitnessSync.shared.logEvent("reminder_disabled")
        }
    }

    /// Reflect permission revoked in iOS Settings after we scheduled.
    func refreshAuthorization() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        switch settings.authorizationStatus {
        case .denied:
            isSystemDenied = isEnabled || isSystemDenied
            if isEnabled { disable() }
        default:
            break
        }
    }
}
