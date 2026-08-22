import Foundation
import Testing
@testable import WitnessCore

@Suite("Witness+ archive gate")
struct ArchiveAccessPolicyTests {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()

    // 2026-08-22 12:00 UTC
    private let now = Date(timeIntervalSince1970: 1_787_400_000)

    @Test("Today and the previous six days stay free")
    func freeWindow() {
        #expect(ArchiveAccessPolicy.isUnlocked(localDay: "2026-08-22", asOf: now, calendar: calendar, hasPlus: false))
        #expect(ArchiveAccessPolicy.isUnlocked(localDay: "2026-08-16", asOf: now, calendar: calendar, hasPlus: false))
    }

    @Test("The eighth day back is locked without Witness+")
    func lockedBeyondWindow() {
        #expect(!ArchiveAccessPolicy.isUnlocked(localDay: "2026-08-15", asOf: now, calendar: calendar, hasPlus: false))
        #expect(!ArchiveAccessPolicy.isUnlocked(localDay: "2025-01-01", asOf: now, calendar: calendar, hasPlus: false))
    }

    @Test("Witness+ unlocks the entire archive")
    func plusUnlocksEverything() {
        #expect(ArchiveAccessPolicy.isUnlocked(localDay: "2025-01-01", asOf: now, calendar: calendar, hasPlus: true))
        #expect(ArchiveAccessPolicy.isUnlocked(localDay: "2026-08-15", asOf: now, calendar: calendar, hasPlus: true))
    }
}
