import Foundation
import WitnessCore

/// Minimal PostgREST client over URLSession. Inserts are idempotent server-side:
/// witness rows carry a unique (install_id, species_id, day) constraint and are
/// posted with ignore-duplicates.
struct SupabaseTransport: SyncTransport {
    let baseURL: URL
    let anonKey: String

    struct RequestFailed: Error {
        let statusCode: Int
    }

    func send(_ item: SyncItem) async throws {
        let table = item.kind == .witness ? "witness_events" : "events"
        var request = URLRequest(url: baseURL.appending(path: "rest/v1/\(table)"))
        request.httpMethod = "POST"
        request.httpBody = item.body
        request.timeoutInterval = 15
        request.setValue(anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(anonKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("return=minimal", forHTTPHeaderField: "Prefer")

        let (_, response) = try await URLSession.shared.data(for: request)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0
        // 409 means the unique (install_id, species_id, day) constraint already
        // holds this witness — a resend after an interrupted upload, which is
        // success. PostgREST's ignore-duplicates upsert is unusable here because
        // its conflict check needs a select grant the privacy model forbids.
        if status == 409, item.kind == .witness { return }
        guard (200..<300).contains(status) else {
            throw RequestFailed(statusCode: status)
        }
    }
}
