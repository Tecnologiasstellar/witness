import Foundation
import Testing
@testable import WitnessCore

@Suite("Durable local Witness repository")
struct FileWitnessRepositoryTests {
    @Test("A species can be witnessed only once per ritual period")
    func idempotentWitness() async throws {
        let fileURL = temporaryStoreURL()
        let repository = FileWitnessRepository(fileURL: fileURL)
        let date = Date(timeIntervalSince1970: 1_787_310_000)

        let first = try await repository.recordWitness(
            speciesID: "vaquita",
            assignedPeriod: "2026-W34",
            witnessedAt: date
        )
        let duplicate = try await repository.recordWitness(
            speciesID: "vaquita",
            assignedPeriod: "2026-W34",
            witnessedAt: date.addingTimeInterval(90)
        )

        guard case .created = first else { Issue.record("First write was not created"); return }
        guard case .existing = duplicate else { Issue.record("Duplicate write was not reconciled"); return }
        #expect(first.record == duplicate.record)
        #expect(try await repository.allRecords().count == 1)
    }

    @Test("Saving an empty reflection deletes the stored note")
    func emptyReflectionDeletes() async throws {
        let fileURL = temporaryStoreURL()
        let repository = FileWitnessRepository(fileURL: fileURL)
        let result = try await repository.recordWitness(
            speciesID: "vaquita",
            assignedPeriod: "2026-W34",
            witnessedAt: Date(timeIntervalSince1970: 1_787_310_000)
        )

        _ = try await repository.updateReflection(eventID: result.record.id, reflection: "A quiet note.")
        let cleared = try await repository.updateReflection(eventID: result.record.id, reflection: "   ")
        #expect(cleared.reflection == nil)
        #expect(try await repository.allRecords().first?.reflection == nil)
    }

    @Test("A new repository instance restores the record and reflection")
    func restorationAndReflectionRoundTrip() async throws {
        let fileURL = temporaryStoreURL()
        let firstRepository = FileWitnessRepository(fileURL: fileURL)
        let result = try await firstRepository.recordWitness(
            speciesID: "vaquita",
            assignedPeriod: "2026-W34",
            witnessedAt: Date(timeIntervalSince1970: 1_787_310_000)
        )
        _ = try await firstRepository.updateReflection(
            eventID: result.record.id,
            reflection: "  I want to remember the silence between breaths.  "
        )

        let restoredRepository = FileWitnessRepository(fileURL: fileURL)
        let restored = try #require(try await restoredRepository.allRecords().first)

        #expect(restored.id == "2026-W34|vaquita")
        #expect(restored.reflection == "I want to remember the silence between breaths.")
    }

    @Test("A pre-weekly archive with day-keyed records loads unchanged")
    func legacyDailyArchiveStillLoads() async throws {
        let fileURL = temporaryStoreURL()
        try FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        // Exactly the on-disk shape written before D-016 (weekly cadence).
        let legacyJSON = """
        {
          "schemaVersion": 1,
          "records": [
            {
              "id": "2026-08-21|vaquita",
              "speciesID": "vaquita",
              "localDay": "2026-08-21",
              "witnessedAt": "2026-08-21T15:00:00Z",
              "reflection": "Kept."
            }
          ]
        }
        """
        try Data(legacyJSON.utf8).write(to: fileURL)

        let repository = FileWitnessRepository(fileURL: fileURL)
        let restored = try #require(try await repository.allRecords().first)
        #expect(restored.assignedPeriod == "2026-08-21")
        #expect(restored.reflection == "Kept.")

        // New weekly records coexist with legacy day-keyed history.
        _ = try await repository.recordWitness(
            speciesID: "vaquita",
            assignedPeriod: "2026-W35",
            witnessedAt: Date(timeIntervalSince1970: 1_787_915_000)
        )
        #expect(try await repository.allRecords().count == 2)
    }

    private func temporaryStoreURL() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("WitnessCoreTests", isDirectory: true)
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
            .appendingPathComponent("witness-archive.json")
    }
}
