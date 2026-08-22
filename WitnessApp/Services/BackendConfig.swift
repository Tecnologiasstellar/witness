import Foundation

/// Environment wiring per D-018: Debug builds talk to witness-staging,
/// Release (TestFlight / App Store) builds talk to witness-prod.
/// Anon keys are publishable by design; the service-role key never enters
/// this repository.
enum BackendConfig {
#if DEBUG
    static let supabaseURL = URL(string: "https://apnwougtcnewgyvnphva.supabase.co")!
    static let supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFwbndvdWd0Y25ld2d5dm5waHZhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODc0MTMxNDEsImV4cCI6MjEwMjk4OTE0MX0.Xp2j4SrSEmiUkdyvqyFZb0J7PJKrENtELXKcqnHu3BE"
#else
    static let supabaseURL = URL(string: "https://hozkcgfajvollyobitmz.supabase.co")!
    static let supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhvemtjZ2ZhanZvbGx5b2JpdG16Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODc0MTA4MjIsImV4cCI6MjEwMjk4NjgyMn0.znVHqtMHKVcEz4D3-hqHkxt6TV6wYc5hE9ebu7gXy-c"
#endif

    /// Sync stays fully disabled until the anon key for this environment is
    /// filled in — the local ritual never depends on it.
    static var isConfigured: Bool { !supabaseAnonKey.isEmpty }

    /// RevenueCat public Apple SDK key (publishable by design).
    static let revenueCatAPIKey = "appl_pjYQNNEyIbRmyicMlyeWnIyaroK"
}

enum InstallIdentity {
    private static let key = "witness.install.id"

    static func id(defaults: UserDefaults = .standard) -> String {
        if let existing = defaults.string(forKey: key) {
            return existing
        }
        let fresh = UUID().uuidString.lowercased()
        defaults.set(fresh, forKey: key)
        return fresh
    }
}
