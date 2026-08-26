import Foundation
import Testing
@testable import WitnessCore

struct FileAccessRepositoryTests {
    private func temporaryFileURL() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("witness-access-tests", isDirectory: true)
            .appendingPathComponent("\(UUID().uuidString).json")
    }

    @Test func missingCacheReturnsNil() async {
        let repository = FileAccessRepository(fileURL: temporaryFileURL())
        #expect(await repository.cachedSnapshot() == nil)
    }

    @Test func savedSnapshotRoundTripsAndIsMarkedAsCache() async throws {
        let url = temporaryFileURL()
        let saved = AccessSnapshot(
            ownsFieldSeasonOne: true,
            atlas: .active(expiration: Date(timeIntervalSince1970: 1_800_000_000), willRenew: true),
            source: .provider,
            verifiedAt: Date(timeIntervalSince1970: 1_756_200_000)
        )
        try await FileAccessRepository(fileURL: url).save(saved)

        // A fresh instance restores the snapshot from disk.
        let restored = await FileAccessRepository(fileURL: url).cachedSnapshot()
        #expect(restored?.ownsFieldSeasonOne == true)
        #expect(restored?.atlas == saved.atlas)
        #expect(restored?.verifiedAt == saved.verifiedAt)
        #expect(restored?.source == .localCache)
    }

    @Test func corruptCacheDegradesToNilNotError() async throws {
        let url = temporaryFileURL()
        try FileManager.default.createDirectory(
            at: url.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try Data("not json".utf8).write(to: url)
        let repository = FileAccessRepository(fileURL: url)
        #expect(await repository.cachedSnapshot() == nil)
    }

    @Test func futureSchemaVersionIsNotTrusted() async throws {
        let url = temporaryFileURL()
        try FileManager.default.createDirectory(
            at: url.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        let payload = """
        {"schemaVersion": 99, "snapshot": {"ownsFieldSeasonOne": true, "atlas": {"inactive": {}}, "source": "provider"}}
        """
        try Data(payload.utf8).write(to: url)
        let repository = FileAccessRepository(fileURL: url)
        #expect(await repository.cachedSnapshot() == nil)
    }

    @Test func lapsedSnapshotOverwritesOwnedSnapshot() async throws {
        let url = temporaryFileURL()
        let repository = FileAccessRepository(fileURL: url)
        try await repository.save(AccessSnapshot(
            ownsFieldSeasonOne: true,
            atlas: .active(expiration: nil, willRenew: true),
            source: .provider,
            verifiedAt: nil
        ))
        try await repository.save(AccessSnapshot(
            ownsFieldSeasonOne: true,
            atlas: .expired(Date(timeIntervalSince1970: 1_756_000_000)),
            source: .provider,
            verifiedAt: nil
        ))
        let restored = await repository.cachedSnapshot()
        #expect(restored?.atlas == .expired(Date(timeIntervalSince1970: 1_756_000_000)))
        #expect(restored?.ownsFieldSeasonOne == true)
    }
}
