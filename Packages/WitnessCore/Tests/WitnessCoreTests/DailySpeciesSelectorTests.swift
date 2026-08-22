import Foundation
import Testing
@testable import WitnessCore

@Suite("Deterministic daily species assignment")
struct DailySpeciesSelectorTests {
    @Test("The same local calendar day always returns the same species")
    func assignmentIsStableWithinDay() throws {
        let records = try BundledSpeciesCatalog.load()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try #require(TimeZone(identifier: "America/Mexico_City"))
        let morning = try #require(calendar.date(from: DateComponents(year: 2026, month: 8, day: 21, hour: 8)))
        let evening = try #require(calendar.date(from: DateComponents(year: 2026, month: 8, day: 21, hour: 22)))
        let selector = DailySpeciesSelector()

        #expect(selector.species(for: morning, from: records, calendar: calendar)?.id == "vaquita")
        #expect(selector.species(for: evening, from: records, calendar: calendar)?.id == "vaquita")
    }

    @Test("An empty catalog returns no assignment")
    func emptyCatalogReturnsNil() {
        #expect(DailySpeciesSelector().species(for: Date(), from: []) == nil)
    }
}
