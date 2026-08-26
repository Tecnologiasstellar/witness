import Foundation
import Testing
@testable import WitnessCore

@Suite("Deterministic weekly species assignment")
struct WeeklySpeciesSelectorTests {
    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/Mexico_City")!
        return calendar
    }

    @Test("Every day of one ISO week returns the same species")
    func assignmentIsStableWithinWeek() throws {
        let records = try BundledSpeciesCatalog.load()
        let selector = WeeklySpeciesSelector()
        // 2026-08-17 (Monday) through 2026-08-23 (Sunday) are one ISO week.
        let ids = try (17...23).map { day -> String? in
            let date = try #require(calendar.date(from: DateComponents(year: 2026, month: 8, day: day, hour: 9)))
            return selector.species(for: date, from: records, calendar: calendar)?.id
        }
        #expect(Set(ids).count == 1)
        #expect(ids.first == "vaquita")
    }

    @Test("The featured species advances at the ISO week boundary")
    func advancesWeekly() throws {
        // Two records so weeks alternate deterministically.
        let records = try BundledSpeciesCatalog.load()
        let base = try #require(records.first)
        let second = SpeciesRecord(
            id: "zz-test-species",
            schemaVersion: base.schemaVersion,
            commonName: "Test",
            scientificName: "Testus testus",
            conservationStatus: base.conservationStatus,
            generalizedRange: base.generalizedRange,
            hook: base.hook,
            story: base.story,
            action: base.action,
            media: base.media,
            publishDate: "2026-09-01",
            sources: base.sources,
            editorial: base.editorial
        )
        let selector = WeeklySpeciesSelector()
        let sunday = try #require(calendar.date(from: DateComponents(year: 2026, month: 8, day: 23, hour: 23)))
        let monday = try #require(calendar.date(from: DateComponents(year: 2026, month: 8, day: 24, hour: 1)))

        let sundaySpecies = selector.species(for: sunday, from: records + [second], calendar: calendar)?.id
        let mondaySpecies = selector.species(for: monday, from: records + [second], calendar: calendar)?.id
        #expect(sundaySpecies != mondaySpecies)
    }

    @Test("An empty catalog returns no assignment")
    func emptyCatalogReturnsNil() {
        #expect(WeeklySpeciesSelector().species(for: Date(), from: []) == nil)
    }

    @Test("Week keys are canonical ISO week identifiers")
    func weekKeyFormat() throws {
        let midWeek = try #require(calendar.date(from: DateComponents(year: 2026, month: 8, day: 26, hour: 12)))
        #expect(WitnessPeriodKey.make(for: midWeek, calendar: calendar) == "2026-W35")
        // Same week, different day, same key.
        let monday = try #require(calendar.date(from: DateComponents(year: 2026, month: 8, day: 24, hour: 0, minute: 30)))
        #expect(WitnessPeriodKey.make(for: monday, calendar: calendar) == "2026-W35")
        // A January date belonging to the previous ISO week-year.
        let newYear = try #require(calendar.date(from: DateComponents(year: 2027, month: 1, day: 1, hour: 12)))
        #expect(WitnessPeriodKey.make(for: newYear, calendar: calendar) == "2026-W53")
    }
}
