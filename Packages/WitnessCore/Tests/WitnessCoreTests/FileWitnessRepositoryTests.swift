import Foundation
import Testing
@testable import WitnessCore

@Suite("Durable local Witness repository")
struct FileWitnessRepositoryTests {
    @Test("A species can be witnessed only once per local day")
    func idempotentWitness() async throws {
        let fileURL = temporaryStoreURL()
        let repository = FileWitnessRepository(fileURL: fileURL)
        let date = Date(timeIntervalSince1970: 1_787_310_000)

        let first = try await repository.recordWitness(
            speciesID: "vaquita",
            localDay: "2026-08-21",
            witnessedAt: date
        )
        let duplicate = try await repository.recordWitness(
            speciesID: "vaquita",
            localDay: "2026-08-21",
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
            localDay: "2026-08-21",
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
            localDay: "2026-08-21",
            witnessedAt: Date(timeIntervalSince1970: 1_787_310_000)
        )
        _ = try await firstRepository.updateReflection(
            eventID: result.record.id,
            reflection: "  I want to remember the silence between breaths.  "
        )

        let restoredRepository = FileWitnessRepository(fileURL: fileURL)
        let restored = try #require(try await restoredRepository.allRecords().first)

        #expect(restored.id == "2026-08-21|vaquita")
        #expect(restored.reflection == "I want to remember the silence between breaths.")
    }

    private func temporaryStoreURL() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("WitnessCoreTests", isDirectory: true)
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
            .appendingPathComponent("witness-archive.json")
    }
}
