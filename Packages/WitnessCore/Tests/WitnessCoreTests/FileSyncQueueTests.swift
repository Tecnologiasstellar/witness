import Foundation
import Testing
@testable import WitnessCore

private actor MockTransport: SyncTransport {
    private var failuresRemaining: Int
    private(set) var sentItems: [SyncItem] = []

    init(failFirst: Int = 0) {
        self.failuresRemaining = failFirst
    }

    struct SendFailure: Error {}

    func send(_ item: SyncItem) async throws {
        if failuresRemaining > 0 {
            failuresRemaining -= 1
            throw SendFailure()
        }
        sentItems.append(item)
    }
}

@Suite struct FileSyncQueueTests {
    private func makeQueueURL() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("witness-sync-tests", isDirectory: true)
            .appendingPathComponent("\(UUID().uuidString).json")
    }

    @Test func enqueuePersistsAcrossInstances() async throws {
        let url = makeQueueURL()
        let first = FileSyncQueue(fileURL: url)
        try await first.enqueue(kind: .witness, body: Data("a".utf8), at: Date(timeIntervalSince1970: 1))

        let second = FileSyncQueue(fileURL: url)
        let pending = try await second.pendingItems()
        #expect(pending.count == 1)
        #expect(pending[0].kind == .witness)
        #expect(pending[0].body == Data("a".utf8))
    }

    @Test func drainSendsOldestFirstAndEmptiesQueue() async throws {
        let queue = FileSyncQueue(fileURL: makeQueueURL())
        try await queue.enqueue(kind: .witness, body: Data("first".utf8), at: Date(timeIntervalSince1970: 1))
        try await queue.enqueue(kind: .event, body: Data("second".utf8), at: Date(timeIntervalSince1970: 2))

        let transport = MockTransport()
        let result = await queue.drain(using: transport)

        #expect(result.sent == 2)
        #expect(result.remaining == 0)
        #expect(result.lastErrorDescription == nil)
        #expect(await transport.sentItems.map(\.body) == [Data("first".utf8), Data("second".utf8)])
        #expect(try await queue.pendingItems().isEmpty)
    }

    @Test func drainStopsAtFirstFailureAndKeepsRemainingItems() async throws {
        let queue = FileSyncQueue(fileURL: makeQueueURL())
        try await queue.enqueue(kind: .witness, body: Data("first".utf8), at: Date(timeIntervalSince1970: 1))
        try await queue.enqueue(kind: .event, body: Data("second".utf8), at: Date(timeIntervalSince1970: 2))

        let transport = MockTransport(failFirst: 1)
        let result = await queue.drain(using: transport)

        #expect(result.sent == 0)
        #expect(result.remaining == 2)
        #expect(result.lastErrorDescription != nil)
        let pending = try await queue.pendingItems()
        #expect(pending.map(\.body) == [Data("first".utf8), Data("second".utf8)])

        let retry = await queue.drain(using: transport)
        #expect(retry.sent == 2)
        #expect(retry.remaining == 0)
    }
}
