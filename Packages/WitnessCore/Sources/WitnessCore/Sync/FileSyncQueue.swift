import Foundation

public actor FileSyncQueue {
    private struct Store: Codable, Sendable {
        let schemaVersion: Int
        var items: [SyncItem]

        static let empty = Store(schemaVersion: 1, items: [])
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

    public func enqueue(kind: SyncItem.Kind, body: Data, at date: Date) throws {
        var store = try load()
        store.items.append(SyncItem(kind: kind, body: body, createdAt: date))
        try persist(store)
    }

    public func pendingItems() throws -> [SyncItem] {
        try load().items
    }

    /// Sends pending items oldest-first, removing each on success and stopping
    /// at the first failure so order is preserved for the next attempt.
    public func drain(using transport: any SyncTransport) async -> SyncDrainResult {
        var store: Store
        do {
            store = try load()
        } catch {
            return SyncDrainResult(sent: 0, remaining: 0, lastErrorDescription: String(describing: error))
        }

        var sent = 0
        var lastError: String?
        while let item = store.items.first {
            do {
                try await transport.send(item)
                store.items.removeFirst()
                sent += 1
            } catch {
                lastError = String(describing: error)
                break
            }
        }

        do {
            try persist(store)
        } catch {
            lastError = String(describing: error)
        }
        return SyncDrainResult(sent: sent, remaining: store.items.count, lastErrorDescription: lastError)
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
