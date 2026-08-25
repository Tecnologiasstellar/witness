import Foundation

public struct HelpingRecord: Codable, Equatable, Identifiable, Sendable {
    public let speciesID: String
    public let startedAt: Date

    public var id: String { speciesID }

    public init(speciesID: String, startedAt: Date) {
        self.speciesID = speciesID
        self.startedAt = startedAt
    }
}

/// Durable on-device record of which species the user is actively helping —
/// one record per species, first mark wins (idempotent).
public actor FileHelpingStore {
    private struct Store: Codable, Sendable {
        let schemaVersion: Int
        var records: [HelpingRecord]

        static let empty = Store(schemaVersion: 1, records: [])
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

    public func allRecords() throws -> [HelpingRecord] {
        try load().records.sorted { $0.startedAt > $1.startedAt }
    }

    @discardableResult
    public func startHelping(speciesID: String, at date: Date) throws -> HelpingRecord {
        var store = try load()
        if let existing = store.records.first(where: { $0.speciesID == speciesID }) {
            return existing
        }
        let record = HelpingRecord(speciesID: speciesID, startedAt: date)
        store.records.append(record)
        try persist(store)
        return record
    }

    private func load() throws -> Store {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return .empty
        }
        let data = try Data(contentsOf: fileURL)
        let store = try decoder.decode(Store.self, from: data)
        guard store.schemaVersion == Store.empty.schemaVersion else {
            throw WitnessPersistenceError.unsupportedSchema(store.schemaVersion)
        }
        return store
    }

    private func persist(_ store: Store) throws {
        let directory = fileURL.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let data = try encoder.encode(store)
        // completeFileProtection is the iOS privacy guarantee; on macOS (test
        // host only) it is volume-dependent and can fail with EPERM.
#if os(iOS)
        try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
#else
        try data.write(to: fileURL, options: [.atomic])
#endif
    }
}
