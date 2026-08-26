import Foundation
import Testing
@testable import WitnessCore

@Suite("Weekly witness streak calculation")
struct WitnessStreakCalculatorTests {
    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/Mexico_City")!
        return calendar
    }

    private func record(year: Int, month: Int, day: Int, species: String) -> WitnessRecord {
        let date = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: 12))!
        return WitnessRecord(
            id: "\(WitnessPeriodKey.make(for: date, calendar: calendar))|\(species)",
            speciesID: species,
            assignedPeriod: WitnessPeriodKey.make(for: date, calendar: calendar),
            witnessedAt: date
        )
    }

    @Test("Consecutive weeks form a streak")
    func consecutiveWeeks() throws {
        let asOf = try #require(calendar.date(from: DateComponents(year: 2026, month: 8, day: 26, hour: 12)))
        let records = [
            record(year: 2026, month: 8, day: 12, species: "a"),  // W33
            record(year: 2026, month: 8, day: 19, species: "b"),  // W34
            record(year: 2026, month: 8, day: 25, species: "c")   // W35
        ]
        #expect(WitnessStreakCalculator.currentStreak(records: records, asOf: asOf, calendar: calendar) == 3)
    }

    @Test("Last week preserves a streak but a larger gap resets it")
    func graceAndGap() throws {
        let asOf = try #require(calendar.date(from: DateComponents(year: 2026, month: 8, day: 26, hour: 12)))
        let lastWeek = record(year: 2026, month: 8, day: 19, species: "vaquita")
        let twoWeeksAgo = record(year: 2026, month: 8, day: 12, species: "other")

        #expect(WitnessStreakCalculator.currentStreak(records: [lastWeek], asOf: asOf, calendar: calendar) == 1)
        #expect(WitnessStreakCalculator.currentStreak(records: [twoWeeksAgo], asOf: asOf, calendar: calendar) == 0)
    }

    @Test("Multiple witnesses inside one week count as one streak week")
    func oneWeekManyRecords() throws {
        let asOf = try #require(calendar.date(from: DateComponents(year: 2026, month: 8, day: 26, hour: 12)))
        let records = [
            record(year: 2026, month: 8, day: 24, species: "a"),
            record(year: 2026, month: 8, day: 25, species: "b"),
            record(year: 2026, month: 8, day: 26, species: "c")
        ]
        #expect(WitnessStreakCalculator.currentStreak(records: records, asOf: asOf, calendar: calendar) == 1)
    }

    @Test("Old day-keyed records still count toward weekly streaks")
    func legacyDayKeyedRecords() throws {
        // A record persisted before D-016 carries a day key; the streak uses
        // its timestamp, so no migration is needed.
        let asOf = try #require(calendar.date(from: DateComponents(year: 2026, month: 8, day: 26, hour: 12)))
        let legacyDate = try #require(calendar.date(from: DateComponents(year: 2026, month: 8, day: 21, hour: 9)))
        let legacy = WitnessRecord(
            id: "2026-08-21|vaquita",
            speciesID: "vaquita",
            assignedPeriod: "2026-08-21",
            witnessedAt: legacyDate
        )
        #expect(WitnessStreakCalculator.currentStreak(records: [legacy], asOf: asOf, calendar: calendar) == 1)
    }
}
