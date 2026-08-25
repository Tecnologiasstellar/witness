import Foundation
import Testing
@testable import WitnessCore

@Suite("Featured history")
struct FeaturedHistoryTests {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()

    private var catalog: [SpeciesRecord] {
        (try? BundledSpeciesCatalog.load()) ?? []
    }

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day, hour: 12))!
    }

    @Test("History runs newest-first from today back to the catalog epoch")
    func historySpansEpochToToday() throws {
        let plates = DailySpeciesSelector().featuredHistory(
            asOf: date(2026, 8, 24),
            from: catalog,
            calendar: calendar
        )
        #expect(plates.map(\.localDay) == ["2026-08-24", "2026-08-23", "2026-08-22", "2026-08-21"])
    }

    @Test("Each history day carries the same species the daily selector chooses")
    func historyMatchesDailySelection() throws {
        let selector = DailySpeciesSelector()
        let plates = selector.featuredHistory(asOf: date(2026, 8, 24), from: catalog, calendar: calendar)
        let todaysSpecies = selector.species(for: date(2026, 8, 24), from: catalog, calendar: calendar)
        #expect(plates.first?.species == todaysSpecies)
    }

    @Test("A date before the epoch still yields exactly one plate")
    func beforeEpochClampsToSingleDay() throws {
        let plates = DailySpeciesSelector().featuredHistory(
            asOf: date(2026, 8, 10),
            from: catalog,
            calendar: calendar
        )
        #expect(plates.count == 1)
        #expect(plates.first?.localDay == "2026-08-10")
    }
}
