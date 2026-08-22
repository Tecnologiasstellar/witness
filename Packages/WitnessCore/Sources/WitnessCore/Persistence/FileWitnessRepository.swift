import Foundation

public actor FileWitnessRepository: WitnessRepository {
    public static let reflectionCharacterLimit = 1_000

    private struct Store: Codable, Sendable {
        let schemaVersion: Int
        var records: [WitnessRecord]

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

    public func allRecords() throws -> [WitnessRecord] {
        try load().records.sorted { $0.witnessedAt > $1.witnessedAt }
    }

    public func recordWitness(
        speciesID: String,
        localDay: String,
        witnessedAt: Date
    ) throws -> WitnessSaveResult {
        var store = try load()
        let eventID = WitnessDayKey.eventID(speciesID: speciesID, localDay: localDay)

        if let existing = store.records.first(where: { $0.id == eventID }) {
            return .existing(existing)
        }

        let record = WitnessRecord(
            id: eventID,
            speciesID: speciesID,
            localDay: localDay,
            witnessedAt: witnessedAt
        )
        store.records.append(record)
        try persist(store)
        return .created(record)
    }

    public func updateReflection(eventID: String, reflection: String?) throws -> WitnessRecord {
        var store = try load()
        guard let index = store.records.firstIndex(where: { $0.id == eventID }) else {
            throw WitnessPersistenceError.recordNotFound(eventID)
        }

        let normalized = reflection?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let storedValue = normalized?.isEmpty == true ? nil : normalized
        if let storedValue, storedValue.count > Self.reflectionCharacterLimit {
            throw WitnessPersistenceError.reflectionTooLong(limit: Self.reflectionCharacterLimit)
        }

        store.records[index].reflection = storedValue
        try persist(store)
        return store.records[index]
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
        try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
    }
}
