import SwiftUI
@preconcurrency import UserNotifications
import WitnessCore

/// Daily local-notification reminder (D-008: primed only after the first
/// completed witness). Zero server infrastructure — the catalog rotates
/// on-device, so a repeating local notification is the whole feature.
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
        Task { await refreshAuthorization() }
    }

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
        defaults.set(true, forKey: "reminder.enabled")
        defaults.set(hour, forKey: "reminder.hour")
        defaults.set(minute, forKey: "reminder.minute")

        let content = UNMutableNotificationContent()
        content.title = "Today's species is waiting"
        content.body = "A new plate is on the table. Take one quiet minute to bear witness."
        content.sound = .default

        var trigger = DateComponents()
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
