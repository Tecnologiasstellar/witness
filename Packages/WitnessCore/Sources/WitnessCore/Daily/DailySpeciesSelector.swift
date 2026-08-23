import Foundation

/// One past day of the ritual: the local day and the species featured on it.
public struct FeaturedPlate: Equatable, Identifiable, Sendable {
    public let localDay: String
    public let species: SpeciesRecord

    public var id: String { localDay }

    public init(localDay: String, species: SpeciesRecord) {
        self.localDay = localDay
        self.species = species
    }
}

public struct DailySpeciesSelector: Sendable {
    /// The first day Witness featured a species; history never reaches before it.
    public static let catalogEpoch = DateComponents(year: 2026, month: 8, day: 21)

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
        let reference = calendar.date(from: Self.catalogEpoch)!
        let currentDay = calendar.startOfDay(for: date)
        let dayOffset = calendar.dateComponents([.day], from: reference, to: currentDay).day ?? 0
        let index = ((dayOffset % sortedRecords.count) + sortedRecords.count) % sortedRecords.count
        return sortedRecords[index]
    }

    /// Every featured day from the catalog epoch through `date`, newest first.
    public func featuredHistory(
        asOf date: Date,
        from records: [SpeciesRecord],
        calendar inputCalendar: Calendar = Calendar(identifier: .gregorian)
    ) -> [FeaturedPlate] {
        guard !records.isEmpty else { return [] }

        var calendar = inputCalendar
        if calendar.timeZone.identifier.isEmpty {
            calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        }

        let reference = calendar.date(from: Self.catalogEpoch)!
        let currentDay = calendar.startOfDay(for: date)
        let dayCount = max(0, calendar.dateComponents([.day], from: reference, to: currentDay).day ?? 0)

        return (0...dayCount).compactMap { offset in
            guard let day = calendar.date(byAdding: .day, value: -offset, to: currentDay),
                  let species = species(for: day, from: records, calendar: calendar) else {
                return nil
            }
            return FeaturedPlate(
                localDay: WitnessDayKey.make(for: day, calendar: calendar),
                species: species
            )
        }
    }
}
