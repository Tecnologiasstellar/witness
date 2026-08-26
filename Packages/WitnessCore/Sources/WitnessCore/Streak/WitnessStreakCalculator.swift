import Foundation

/// Consecutive-week streak (D-016). Weeks are derived from each record's
/// timestamp, not its stored period string, so day-keyed records from the
/// earlier daily cadence count toward weekly streaks without migration.
public enum WitnessStreakCalculator {
    public static func currentStreak(
        records: [WitnessRecord],
        asOf date: Date,
        calendar inputCalendar: Calendar
    ) -> Int {
        guard !records.isEmpty else { return 0 }

        var iso = Calendar(identifier: .iso8601)
        iso.timeZone = inputCalendar.timeZone

        let witnessedWeeks = Set(records.map { WitnessPeriodKey.make(for: $0.witnessedAt, calendar: iso) })
        let thisWeek = WitnessPeriodKey.make(for: date, calendar: iso)
        let startingDate: Date

        if witnessedWeeks.contains(thisWeek) {
            startingDate = date
        } else if let lastWeek = iso.date(byAdding: .weekOfYear, value: -1, to: date),
                  witnessedWeeks.contains(WitnessPeriodKey.make(for: lastWeek, calendar: iso)) {
            startingDate = lastWeek
        } else {
            return 0
        }

        var streak = 0
        var cursor = startingDate
        while witnessedWeeks.contains(WitnessPeriodKey.make(for: cursor, calendar: iso)) {
            streak += 1
            guard let previous = iso.date(byAdding: .weekOfYear, value: -1, to: cursor) else { break }
            cursor = previous
        }
        return streak
    }
}
