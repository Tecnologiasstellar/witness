import Foundation
import Testing
@testable import WitnessCore

struct WitnessEventOutboxTests {
    private let now = Date(timeIntervalSince1970: 1_756_300_000)

    private func makeOutbox() -> WitnessEventOutbox {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("witness-outbox-tests", isDirectory: true)
            .appendingPathComponent("\(UUID().uuidString).json")
        return WitnessEventOutbox(fileURL: url)
    }

    @Test func enqueueIsIdempotentPerSpeciesAndPeriod() async throws {
        let outbox = makeOutbox()
        let first = try await outbox.enqueue(
            speciesID: "vaquita", assignedPeriod: "2026-08-26", occurredAt: now, now: now
        )
        let second = try await outbox.enqueue(
            speciesID: "vaquita", assignedPeriod: "2026-08-26", occurredAt: now.addingTimeInterval(60), now: now
        )
        #expect(first.id == second.id)
        #expect(try await outbox.allEvents().count == 1)

        _ = try await outbox.enqueue(
            speciesID: "vaquita", assignedPeriod: "2026-08-27", occurredAt: now, now: now
        )
        #expect(try await outbox.allEvents().count == 2)
    }

    @Test func dueEventsRespectBackoffSchedule() async throws {
        let outbox = makeOutbox()
        let event = try await outbox.enqueue(
            speciesID: "vaquita", assignedPeriod: "2026-08-26", occurredAt: now, now: now
        )
        #expect(try await outbox.dueEvents(now: now).count == 1)

        try await outbox.markFailed(id: event.id, now: now)
        // First retry waits base * 2 = 60s.
        #expect(try await outbox.dueEvents(now: now).isEmpty)
        #expect(try await outbox.dueEvents(now: now.addingTimeInterval(61)).count == 1)

        try await outbox.markFailed(id: event.id, now: now)
        let events = try await outbox.allEvents()
        #expect(events[0].attemptCount == 2)
    }

    @Test func backoffGrowsExponentiallyAndCaps() {
        let policy = WitnessEventOutbox.BackoffPolicy(baseDelay: 30, maxDelay: 3_600)
        #expect(policy.delay(afterAttempts: 1) == 60)
        #expect(policy.delay(afterAttempts: 2) == 120)
        #expect(policy.delay(afterAttempts: 10) == 3_600)
        #expect(policy.delay(afterAttempts: 30) == 3_600)
    }

    @Test func submittedEventsAreRemovedDurably() async throws {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("witness-outbox-tests", isDirectory: true)
            .appendingPathComponent("\(UUID().uuidString).json")
        let outbox = WitnessEventOutbox(fileURL: url)
        let event = try await outbox.enqueue(
            speciesID: "vaquita", assignedPeriod: "2026-08-26", occurredAt: now, now: now
        )
        try await outbox.markSubmitted(id: event.id)

        // A fresh instance sees the durable empty state.
        let reopened = WitnessEventOutbox(fileURL: url)
        #expect(try await reopened.allEvents().isEmpty)
    }

    @Test func queueSurvivesRelaunch() async throws {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("witness-outbox-tests", isDirectory: true)
            .appendingPathComponent("\(UUID().uuidString).json")
        _ = try await WitnessEventOutbox(fileURL: url).enqueue(
            speciesID: "vaquita", assignedPeriod: "2026-08-26", occurredAt: now, now: now
        )
        let reopened = WitnessEventOutbox(fileURL: url)
        let events = try await reopened.allEvents()
        #expect(events.count == 1)
        #expect(events[0].speciesID == "vaquita")
    }

    @Test func pendingEventCarriesNoReflectionField() throws {
        // The wire type must never grow a reflection or free-text field.
        let event = PendingWitnessEvent(
            id: UUID(), speciesID: "vaquita", assignedPeriod: "2026-08-26",
            occurredAt: now, nextAttemptAt: now
        )
        let data = try JSONEncoder().encode(event)
        let keys = (try JSONSerialization.jsonObject(with: data) as? [String: Any])?.keys ?? [:].keys
        #expect(Set(keys) == [
            "id", "speciesID", "assignedPeriod", "occurredAt",
            "eventVersion", "attemptCount", "nextAttemptAt"
        ])
    }
}
