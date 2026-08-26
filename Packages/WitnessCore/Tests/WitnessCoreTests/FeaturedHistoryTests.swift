import Foundation
import Testing
@testable import WitnessCore

@Suite("Featured weekly history")
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

    @Test("History runs newest-first from the current week back to the epoch week")
    func historySpansEpochToCurrentWeek() throws {
        // Epoch 2026-08-21 sits in ISO week 2026-W34; 2026-09-08 is 2026-W37.
        let plates = WeeklySpeciesSelector().featuredHistory(
            asOf: date(2026, 9, 8),
            from: catalog,
            calendar: calendar
        )
        #expect(plates.map(\.period) == ["2026-W37", "2026-W36", "2026-W35", "2026-W34"])
    }

    @Test("Each history week carries the same species the weekly selector chooses")
    func historyMatchesWeeklySelection() throws {
        let selector = WeeklySpeciesSelector()
        let plates = selector.featuredHistory(asOf: date(2026, 9, 8), from: catalog, calendar: calendar)
        let currentSpecies = selector.species(for: date(2026, 9, 8), from: catalog, calendar: calendar)
        #expect(plates.first?.species == currentSpecies)
    }

    @Test("Every day of one week yields the same single-week history head")
    func historyStableWithinWeek() throws {
        let selector = WeeklySpeciesSelector()
        let monday = selector.featuredHistory(asOf: date(2026, 8, 24), from: catalog, calendar: calendar)
        let sunday = selector.featuredHistory(asOf: date(2026, 8, 30), from: catalog, calendar: calendar)
        #expect(monday.first == sunday.first)
    }

    @Test("A date before the epoch still yields exactly one plate")
    func beforeEpochClampsToSingleWeek() throws {
        let plates = WeeklySpeciesSelector().featuredHistory(
            asOf: date(2026, 8, 10),
            from: catalog,
            calendar: calendar
        )
        #expect(plates.count == 1)
        #expect(plates.first?.period == "2026-W33")
    }
}
