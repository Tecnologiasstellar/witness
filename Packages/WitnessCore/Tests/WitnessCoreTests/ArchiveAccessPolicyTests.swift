import Foundation
import Testing
@testable import WitnessCore

@Suite("Atlas archive gate")
struct ArchiveAccessPolicyTests {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()

    // 2026-08-26 12:00 UTC — ISO week 2026-W35.
    private let now = Date(timeIntervalSince1970: 1_787_745_600)

    @Test("The current and previous ritual weeks stay free")
    func freeWindow() {
        #expect(ArchiveAccessPolicy.isUnlocked(period: "2026-W35", asOf: now, calendar: calendar, atlasActive: false))
        #expect(ArchiveAccessPolicy.isUnlocked(period: "2026-W34", asOf: now, calendar: calendar, atlasActive: false))
    }

    @Test("Weeks beyond the free window are locked without Atlas")
    func lockedBeyondWindow() {
        #expect(!ArchiveAccessPolicy.isUnlocked(period: "2026-W33", asOf: now, calendar: calendar, atlasActive: false))
        #expect(!ArchiveAccessPolicy.isUnlocked(period: "2025-W01", asOf: now, calendar: calendar, atlasActive: false))
        // Legacy day keys never match a week window and stay Atlas-gated.
        #expect(!ArchiveAccessPolicy.isUnlocked(period: "2026-08-15", asOf: now, calendar: calendar, atlasActive: false))
    }

    @Test("Active Atlas unlocks the entire archive")
    func atlasUnlocksEverything() {
        #expect(ArchiveAccessPolicy.isUnlocked(period: "2025-W01", asOf: now, calendar: calendar, atlasActive: true))
        #expect(ArchiveAccessPolicy.isUnlocked(period: "2026-W33", asOf: now, calendar: calendar, atlasActive: true))
    }
}
