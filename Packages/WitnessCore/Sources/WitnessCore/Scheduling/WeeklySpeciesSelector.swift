import Foundation

/// One past ritual week: the assigned period key and the species featured
/// during it.
public struct FeaturedPlate: Equatable, Identifiable, Sendable {
    public let period: String
    public let species: SpeciesRecord

    public var id: String { period }

    public init(period: String, species: SpeciesRecord) {
        self.period = period
        self.species = species
    }
}

/// Deterministic weekly assignment: every date inside one ISO week (Monday
/// start, local time zone) resolves to the same species, and the featured
/// species advances once per week (D-023).
public struct WeeklySpeciesSelector: Sendable {
    /// The first week Witness featured a species; history never reaches before it.
    public static let catalogEpoch = DateComponents(year: 2026, month: 8, day: 21)

    public init() {}

    /// Every featured week from the catalog epoch through `date`, newest first.
    public func featuredHistory(
        asOf date: Date,
        from records: [SpeciesRecord],
        calendar inputCalendar: Calendar = Calendar(identifier: .gregorian)
    ) -> [FeaturedPlate] {
        guard !records.isEmpty else { return [] }

        var iso = Calendar(identifier: .iso8601)
        iso.timeZone = inputCalendar.timeZone
        guard
            let epoch = iso.date(from: Self.catalogEpoch),
            let epochWeekStart = iso.dateInterval(of: .weekOfYear, for: epoch)?.start,
            let currentWeekStart = iso.dateInterval(of: .weekOfYear, for: date)?.start
        else {
            return []
        }
        let weekCount = max(0, iso.dateComponents(
            [.weekOfYear], from: epochWeekStart, to: currentWeekStart
        ).weekOfYear ?? 0)

        return (0...weekCount).compactMap { offset in
            guard let week = iso.date(byAdding: .weekOfYear, value: -offset, to: currentWeekStart),
                  let species = species(for: week, from: records, calendar: inputCalendar) else {
                return nil
            }
            return FeaturedPlate(
                period: WitnessPeriodKey.make(for: week, calendar: iso),
                species: species
            )
        }
    }

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
