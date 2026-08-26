import Foundation

/// Deterministic weekly assignment: every date inside one ISO week (Monday
/// start, local time zone) resolves to the same species, and the featured
/// species advances once per week (D-016).
public struct WeeklySpeciesSelector: Sendable {
    public init() {}

    public func species(
        for date: Date,
        from records: [SpeciesRecord],
        calendar inputCalendar: Calendar = Calendar(identifier: .gregorian)
    ) -> SpeciesRecord? {
        guard !records.isEmpty else { return nil }

        var iso = Calendar(identifier: .iso8601)
        iso.timeZone = inputCalendar.timeZone

        let sortedRecords = records.sorted {
            if $0.publishDate == $1.publishDate { return $0.id < $1.id }
            return $0.publishDate < $1.publishDate
        }

        let reference = iso.date(from: DateComponents(year: 2026, month: 8, day: 21))!
        guard
            let referenceWeekStart = iso.dateInterval(of: .weekOfYear, for: reference)?.start,
            let currentWeekStart = iso.dateInterval(of: .weekOfYear, for: date)?.start
        else {
            return sortedRecords[0]
        }
        let weekOffset = iso.dateComponents(
            [.weekOfYear],
            from: referenceWeekStart,
            to: currentWeekStart
        ).weekOfYear ?? 0
        let index = ((weekOffset % sortedRecords.count) + sortedRecords.count) % sortedRecords.count
        return sortedRecords[index]
    }
}
