import Foundation

/// A Witness event queued for idempotent remote submission. The event ID and
/// idempotency semantics mirror the local archive: one event per species and
/// local day per installation. No reflection text or personal data is ever
/// part of a pending event.
public struct PendingWitnessEvent: Codable, Equatable, Identifiable, Sendable {
    public let id: UUID
    public let speciesID: String
    public let assignedPeriod: String
    public let occurredAt: Date
    public let eventVersion: Int
    public var attemptCount: Int
    public var nextAttemptAt: Date

    public init(
        id: UUID,
        speciesID: String,
        assignedPeriod: String,
        occurredAt: Date,
        eventVersion: Int = 1,
        attemptCount: Int = 0,
        nextAttemptAt: Date
    ) {
        self.id = id
        self.speciesID = speciesID
        self.assignedPeriod = assignedPeriod
        self.occurredAt = occurredAt
        self.eventVersion = eventVersion
        self.attemptCount = attemptCount
        self.nextAttemptAt = nextAttemptAt
    }
}

/// The authoritative server response for a species/period aggregate.
public struct ReconciledWitnessCount: Codable, Equatable, Sendable {
    public let speciesID: String
    public let assignedPeriod: String
    public let witnessCount: Int64

    public init(speciesID: String, assignedPeriod: String, witnessCount: Int64) {
        self.speciesID = speciesID
        self.assignedPeriod = assignedPeriod
        self.witnessCount = witnessCount
    }
}

/// Remote submission boundary. The server response, never optimistic UI,
/// determines the collective count.
public protocol RemoteWitnessEventService: Sendable {
    func submit(_ event: PendingWitnessEvent) async throws -> ReconciledWitnessCount
    func count(speciesID: String, assignedPeriod: String) async throws -> ReconciledWitnessCount
}

/// Deterministic in-memory community service for previews and UI tests.
public actor FakeRemoteWitnessEventService: RemoteWitnessEventService {
    private var counts: [String: Int64]
    private var submittedKeys: Set<String> = []
    public var failsSubmissions = false

    public init(initialCounts: [String: Int64] = [:]) {
        self.counts = initialCounts
    }

    private func key(_ speciesID: String, _ period: String) -> String {
        "\(speciesID)|\(period)"
    }

    public func setFailsSubmissions(_ fails: Bool) {
        failsSubmissions = fails
    }

    public func submit(_ event: PendingWitnessEvent) async throws -> ReconciledWitnessCount {
        if failsSubmissions {
            throw URLError(.notConnectedToInternet)
        }
        let key = key(event.speciesID, event.assignedPeriod)
        // Idempotent per species/period: only the first submission counts.
        if !submittedKeys.contains(key) {
            submittedKeys.insert(key)
            counts[key, default: 0] += 1
        }
        return ReconciledWitnessCount(
            speciesID: event.speciesID,
            assignedPeriod: event.assignedPeriod,
            witnessCount: counts[key, default: 0]
        )
    }

    public func count(speciesID: String, assignedPeriod: String) async throws -> ReconciledWitnessCount {
        ReconciledWitnessCount(
            speciesID: speciesID,
            assignedPeriod: assignedPeriod,
            witnessCount: counts[key(speciesID, assignedPeriod), default: 0]
        )
    }
}

/// Durable, file-backed queue of unsent Witness events with exponential
/// backoff. Enqueueing is idempotent per species/period so a relaunch or
/// double-tap cannot create duplicate submissions.
public actor WitnessEventOutbox {
    public struct BackoffPolicy: Sendable {
        public let baseDelay: TimeInterval
        public let maxDelay: TimeInterval

        public init(baseDelay: TimeInterval = 30, maxDelay: TimeInterval = 6 * 60 * 60) {
            self.baseDelay = baseDelay
            self.maxDelay = maxDelay
        }

        /// Exponential backoff with deterministic-input jitter kept small so
        /// tests stay stable: base * 2^attempts, capped.
        public func delay(afterAttempts attempts: Int) -> TimeInterval {
            let exponent = min(Double(attempts), 16)
            return min(baseDelay * pow(2, exponent), maxDelay)
        }
    }

    private struct Store: Codable, Sendable {
        let schemaVersion: Int
        var events: [PendingWitnessEvent]

        static let empty = Store(schemaVersion: 1, events: [])
    }

    private let fileURL: URL
    private let policy: BackoffPolicy
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(fileURL: URL, policy: BackoffPolicy = BackoffPolicy()) {
        self.fileURL = fileURL
        self.policy = policy
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder = encoder
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    /// Adds an event unless one for the same species and period is already
    /// queued. Returns the queued event either way.
    @discardableResult
    public func enqueue(
        speciesID: String,
        assignedPeriod: String,
        occurredAt: Date,
        now: Date
    ) throws -> PendingWitnessEvent {
        var store = try load()
        if let existing = store.events.first(where: {
            $0.speciesID == speciesID && $0.assignedPeriod == assignedPeriod
        }) {
            return existing
        }
        let event = PendingWitnessEvent(
            id: UUID(),
            speciesID: speciesID,
            assignedPeriod: assignedPeriod,
            occurredAt: occurredAt,
            nextAttemptAt: now
        )
        store.events.append(event)
        try persist(store)
        return event
    }

    /// Events whose next attempt is due, oldest first.
    public func dueEvents(now: Date) throws -> [PendingWitnessEvent] {
        try load().events
            .filter { $0.nextAttemptAt <= now }
            .sorted { $0.occurredAt < $1.occurredAt }
    }

    public func allEvents() throws -> [PendingWitnessEvent] {
        try load().events
    }

    /// Removes a successfully submitted event.
    public func markSubmitted(id: UUID) throws {
        var store = try load()
        store.events.removeAll { $0.id == id }
        try persist(store)
    }

    /// Records a failed attempt and schedules the next one with backoff.
    public func markFailed(id: UUID, now: Date) throws {
        var store = try load()
        guard let index = store.events.firstIndex(where: { $0.id == id }) else { return }
        store.events[index].attemptCount += 1
        store.events[index].nextAttemptAt =
            now.addingTimeInterval(policy.delay(afterAttempts: store.events[index].attemptCount))
        try persist(store)
    }

    private func load() throws -> Store {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return .empty }
        let data = try Data(contentsOf: fileURL)
        let store = try decoder.decode(Store.self, from: data)
        guard store.schemaVersion == Store.empty.schemaVersion else {
            // A future-schema outbox is preserved on disk but not processed.
            return .empty
        }
        return store
    }

    private func persist(_ store: Store) throws {
        try FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        let data = try encoder.encode(store)
        try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
    }
}
