import Foundation

public enum WitnessStreakCalculator {
    public static func currentStreak(
        records: [WitnessRecord],
        asOf date: Date,
        calendar inputCalendar: Calendar
    ) -> Int {
        guard !records.isEmpty else { return 0 }

        let calendar = inputCalendar
        let witnessedDays = Set(records.map(\.localDay))
        let today = calendar.startOfDay(for: date)
        let todayKey = WitnessDayKey.make(for: today, calendar: calendar)
        let startingDate: Date

        if witnessedDays.contains(todayKey) {
            startingDate = today
        } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
                  witnessedDays.contains(WitnessDayKey.make(for: yesterday, calendar: calendar)) {
            startingDate = yesterday
        } else {
            return 0
        }

        var streak = 0
        var cursor = startingDate
        while witnessedDays.contains(WitnessDayKey.make(for: cursor, calendar: calendar)) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = previous
        }
        return streak
    }
}
