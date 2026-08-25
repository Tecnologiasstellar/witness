import Foundation
import WitnessCore

/// Fire-and-forget sync of witness events and analytics (D-015, D-017).
/// Everything is queued durably on device first and drained opportunistically;
/// no failure here ever surfaces into or blocks the local ritual.
final class WitnessSync: Sendable {
    static let shared = WitnessSync()

    private let queue: FileSyncQueue
    private let transport: (any SyncTransport)?
    private let installID: String
    private let encoder: JSONEncoder

    private struct WitnessPayload: Encodable {
        let install_id: String
        let species_id: String
        let day: String
    }

    private struct EventPayload: Encodable {
        let install_id: String
        let name: String
        let metadata: [String: String]
    }

    init(
        queueURL: URL = WitnessSync.defaultQueueURL,
        transport: (any SyncTransport)? = BackendConfig.isConfigured
            ? SupabaseTransport(baseURL: BackendConfig.supabaseURL, anonKey: BackendConfig.supabaseAnonKey)
            : nil,
        installID: String = InstallIdentity.id()
    ) {
        self.queue = FileSyncQueue(fileURL: queueURL)
        self.transport = transport
        self.installID = installID
        self.encoder = JSONEncoder()
    }

    func witnessRecorded(speciesID: String, localDay: String) async {
        guard transport != nil else { return }
        let payload = WitnessPayload(install_id: installID, species_id: speciesID, day: localDay)
        await enqueue(kind: .witness, payload: payload)
        await drain()
    }

    func logEvent(_ name: String, metadata: [String: String] = [:]) async {
        guard transport != nil else { return }
        let payload = EventPayload(install_id: installID, name: name, metadata: metadata)
        await enqueue(kind: .event, payload: payload)
    }

    func drain() async {
        guard let transport else { return }
        _ = await queue.drain(using: transport)
    }

    private func enqueue(kind: SyncItem.Kind, payload: some Encodable) async {
        guard let body = try? encoder.encode(payload) else { return }
        try? await queue.enqueue(kind: kind, body: body, at: Date())
    }

    private static var defaultQueueURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
        return base
            .appendingPathComponent("Witness", isDirectory: true)
            .appendingPathComponent("sync-queue.json")
    }
}
