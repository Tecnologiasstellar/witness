import Foundation
import Testing
@testable import WitnessCore

@Suite("Witness streak calculation")
struct WitnessStreakCalculatorTests {
    @Test("Consecutive local days form a streak")
    func consecutiveDays() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try #require(TimeZone(identifier: "America/Mexico_City"))
        let today = try #require(calendar.date(from: DateComponents(year: 2026, month: 8, day: 21, hour: 12)))
        let records = [19, 20, 21].map { day in
            WitnessRecord(
                id: "2026-08-\(day)|species-\(day)",
                speciesID: "species-\(day)",
                localDay: "2026-08-\(day)",
                witnessedAt: today
            )
        }

        #expect(WitnessStreakCalculator.currentStreak(records: records, asOf: today, calendar: calendar) == 3)
    }

    @Test("Yesterday preserves a streak but a larger gap resets it")
    func graceAndGap() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try #require(TimeZone(identifier: "America/Mexico_City"))
        let today = try #require(calendar.date(from: DateComponents(year: 2026, month: 8, day: 21, hour: 12)))
        let yesterday = WitnessRecord(
            id: "2026-08-20|vaquita",
            speciesID: "vaquita",
            localDay: "2026-08-20",
            witnessedAt: today
        )
        let old = WitnessRecord(
            id: "2026-08-18|other",
            speciesID: "other",
            localDay: "2026-08-18",
            witnessedAt: today
        )

        #expect(WitnessStreakCalculator.currentStreak(records: [yesterday], asOf: today, calendar: calendar) == 1)
        #expect(WitnessStreakCalculator.currentStreak(records: [old], asOf: today, calendar: calendar) == 0)
    }
}
