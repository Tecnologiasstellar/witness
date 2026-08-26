import Foundation

/// Durable local cache of the last verified access snapshot so entitled
/// content keeps working offline. This cache is presentation input, never
/// authorization proof: provider verification always overwrites it, and a
/// missing or unreadable cache degrades to the default free state.
public actor FileAccessRepository: AccessRepository {
    private struct Store: Codable, Sendable {
        let schemaVersion: Int
        var snapshot: AccessSnapshot

        static let currentSchemaVersion = 1
    }

    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(fileURL: URL) {
        self.fileURL = fileURL
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder = encoder

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    public func cachedSnapshot() async -> AccessSnapshot? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        guard
            let data = try? Data(contentsOf: fileURL),
            let store = try? decoder.decode(Store.self, from: data),
            store.schemaVersion == Store.currentSchemaVersion
        else {
            // An unreadable or future-schema cache is discarded, not trusted.
            return nil
        }
        var snapshot = store.snapshot
        snapshot.source = .localCache
        return snapshot
    }

    public func save(_ snapshot: AccessSnapshot) async throws {
        let store = Store(schemaVersion: Store.currentSchemaVersion, snapshot: snapshot)
        let directory = fileURL.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let data = try encoder.encode(store)
        try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
    }
}
