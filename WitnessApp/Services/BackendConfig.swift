import Foundation

/// Environment wiring per D-018: Debug builds talk to witness-staging,
/// Release (TestFlight / App Store) builds talk to witness-prod.
/// Anon keys are publishable by design; the service-role key never enters
/// this repository.
enum BackendConfig {
#if DEBUG
    static let supabaseURL = URL(string: "https://apnwougtcnewgyvnphva.supabase.co")!
    static let supabaseAnonKey = ""
#else
    static let supabaseURL = URL(string: "https://hozkcgfajvollyobitmz.supabase.co")!
    static let supabaseAnonKey = ""
#endif

    /// Sync stays fully disabled until the anon key for this environment is
    /// filled in — the local ritual never depends on it.
    static var isConfigured: Bool { !supabaseAnonKey.isEmpty }
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
