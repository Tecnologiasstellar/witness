import Foundation

public struct DailySpeciesSelector: Sendable {
    public init() {}

    public func species(
        for date: Date,
        from records: [SpeciesRecord],
        calendar inputCalendar: Calendar = Calendar(identifier: .gregorian)
    ) -> SpeciesRecord? {
        guard !records.isEmpty else { return nil }

        var calendar = inputCalendar
        if calendar.timeZone.identifier.isEmpty {
            calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        }

        let sortedRecords = records.sorted {
            if $0.publishDate == $1.publishDate { return $0.id < $1.id }
            return $0.publishDate < $1.publishDate
        }
        let reference = calendar.date(from: DateComponents(year: 2026, month: 8, day: 21))!
        let currentDay = calendar.startOfDay(for: date)
        let dayOffset = calendar.dateComponents([.day], from: reference, to: currentDay).day ?? 0
        let index = ((dayOffset % sortedRecords.count) + sortedRecords.count) % sortedRecords.count
        return sortedRecords[index]
    }
}
