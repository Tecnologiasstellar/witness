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
        var components = URLComponents(
            url: baseURL.appending(path: "rest/v1/\(table)"),
            resolvingAgainstBaseURL: false
        )!
        var prefer = "return=minimal"
        if item.kind == .witness {
            components.queryItems = [URLQueryItem(name: "on_conflict", value: "install_id,species_id,day")]
            prefer += ",resolution=ignore-duplicates"
        }

        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.httpBody = item.body
        request.timeoutInterval = 15
        request.setValue(anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(anonKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(prefer, forHTTPHeaderField: "Prefer")

        let (_, response) = try await URLSession.shared.data(for: request)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0
        guard (200..<300).contains(status) else {
            throw RequestFailed(statusCode: status)
        }
    }
}
