import Foundation

/// D-020/D-023: the weekly ritual and a two-week free archive window stay
/// free; older archive content requires active Atlas access. The window is
/// the current and immediately previous ISO week, preserving the spirit of
/// the earlier seven-day rule at the weekly cadence.
public enum ArchiveAccessPolicy {
    public static let freeWindowWeeks = 2

    public static func isUnlocked(
        period: String,
        asOf now: Date,
        calendar: Calendar,
        atlasActive: Bool
    ) -> Bool {
        if atlasActive { return true }
        var iso = Calendar(identifier: .iso8601)
        iso.timeZone = calendar.timeZone
        for offset in 0..<freeWindowWeeks {
            guard let date = iso.date(byAdding: .weekOfYear, value: -offset, to: now) else { continue }
            if WitnessPeriodKey.make(for: date, calendar: iso) == period { return true }
        }
        return false
    }
}
