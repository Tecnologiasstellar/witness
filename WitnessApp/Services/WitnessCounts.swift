import Foundation

/// Read-only fetch of the aggregate witness count (D-015). The count view is
/// the only surface the backend exposes to clients.
enum WitnessCounts {
    private struct Row: Decodable {
        let witness_count: Int
    }

    static func fetch(speciesID: String) async -> Int? {
        guard BackendConfig.isConfigured else { return nil }
        var components = URLComponents(
            url: BackendConfig.supabaseURL.appending(path: "rest/v1/species_witness_counts"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [
            URLQueryItem(name: "species_id", value: "eq.\(speciesID)"),
            URLQueryItem(name: "select", value: "witness_count"),
        ]

        var request = URLRequest(url: components.url!)
        request.timeoutInterval = 10
        request.setValue(BackendConfig.supabaseAnonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(BackendConfig.supabaseAnonKey)", forHTTPHeaderField: "Authorization")

        guard let (data, response) = try? await URLSession.shared.data(for: request),
              (response as? HTTPURLResponse)?.statusCode == 200,
              let rows = try? JSONDecoder().decode([Row].self, from: data) else {
            return nil
        }
        return rows.first?.witness_count ?? 0
    }
}
