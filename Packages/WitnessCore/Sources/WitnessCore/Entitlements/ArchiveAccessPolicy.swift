import Foundation

/// The single Witness+ entitlement (D-016). A concrete RevenueCat adapter
/// lives in the app target; core logic only ever sees this protocol.
public protocol EntitlementProviding: Sendable {
    /// Whether the Witness+ ("plus") entitlement is currently active.
    func hasPlus() async -> Bool
}

/// D-016: the daily ritual and the last seven local days of the archive stay
/// free; older archive content requires Witness+.
public enum ArchiveAccessPolicy {
    public static let freeWindowDays = 7

    public static func isUnlocked(
        localDay: String,
        asOf now: Date,
        calendar: Calendar,
        hasPlus: Bool
    ) -> Bool {
        if hasPlus { return true }
        guard let cutoffDate = calendar.date(byAdding: .day, value: -(freeWindowDays - 1), to: now) else {
            return false
        }
        let cutoffDay = WitnessDayKey.make(for: cutoffDate, calendar: calendar)
        return localDay >= cutoffDay
    }
}
