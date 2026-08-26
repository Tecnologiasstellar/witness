import Foundation
import Security
import WitnessCore

/// Configuration for the hosted community service, from an untracked local
/// plist (`SupabaseConfig.plist`). The anon key is a publishable client key;
/// service-role keys must never appear anywhere in the app.
struct SupabaseConfiguration: Equatable {
    let baseURL: URL
    let anonKey: String

    static func load(bundle: Bundle = .main) -> SupabaseConfiguration? {
        guard
            let url = bundle.url(forResource: "SupabaseConfig", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
            let urlString = plist["url"] as? String,
            let baseURL = URL(string: urlString),
            let anonKey = plist["anonKey"] as? String,
            !anonKey.isEmpty,
            !anonKey.hasPrefix("sbp_"), !anonKey.contains("service_role")
        else {
            return nil
        }
        return SupabaseConfiguration(baseURL: baseURL, anonKey: anonKey)
    }
}

/// A stored pseudonymous auth session. This is infrastructure identity for
/// idempotency and RLS, never a user-facing account. It lives in the
/// Keychain and does not survive app deletion.
struct AnonymousSession: Codable, Equatable {
    let userID: UUID
    var accessToken: String
    var refreshToken: String
    var expiresAt: Date
}

/// Minimal Keychain persistence for the anonymous session.
struct KeychainSessionStore {
    private let service = "com.avp.witness.supabase-session"
    private let account = "anonymous"

    func load() -> AnonymousSession? {
        var query = baseQuery
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var result: AnyObject?
        guard
            SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
            let data = result as? Data
        else { return nil }
        return try? Self.decoder.decode(AnonymousSession.self, from: data)
    }

    func save(_ session: AnonymousSession) {
        guard let data = try? Self.encoder.encode(session) else { return }
        var query = baseQuery
        SecItemDelete(query as CFDictionary)
        query[kSecValueData as String] = data
        query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        SecItemAdd(query as CFDictionary, nil)
    }

    func clear() {
        SecItemDelete(baseQuery as CFDictionary)
    }

    private var baseQuery: [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
    }

    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}

/// URLSession-based client for the Witness community backend: silent
/// anonymous auth plus the idempotent `submit_witness` RPC. No SDK, no
/// retained payloads, no private content in any request.
actor SupabaseCommunityService: RemoteWitnessEventService {
    enum ServiceError: Error, LocalizedError {
        case authenticationFailed
        case badResponse(status: Int)

        var errorDescription: String? {
            switch self {
            case .authenticationFailed: "The community service could not be reached."
            case .badResponse(let status): "The community service returned status \(status)."
            }
        }
    }

    private let configuration: SupabaseConfiguration
    private let sessionStore: KeychainSessionStore
    private let urlSession: URLSession

    init(
        configuration: SupabaseConfiguration,
        sessionStore: KeychainSessionStore = KeychainSessionStore(),
        urlSession: URLSession = .shared
    ) {
        self.configuration = configuration
        self.sessionStore = sessionStore
        self.urlSession = urlSession
    }

    func submit(_ event: PendingWitnessEvent) async throws -> ReconciledWitnessCount {
        let session = try await currentSession()
        var request = URLRequest(url: configuration.baseURL.appending(path: "/rest/v1/rpc/submit_witness"))
        request.httpMethod = "POST"
        request.setValue(configuration.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(session.accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "event_id": event.id.uuidString.lowercased(),
            "species": event.speciesID,
            "period": event.assignedPeriod,
            "occurred": ISO8601DateFormatter().string(from: event.occurredAt),
            "version": event.eventVersion
        ])

        let (data, response) = try await urlSession.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw ServiceError.badResponse(status: -1)
        }
        if http.statusCode == 401 {
            // One silent re-auth attempt with a fresh session.
            sessionStore.clear()
            _ = try await currentSession()
            throw ServiceError.authenticationFailed
        }
        guard (200..<300).contains(http.statusCode) else {
            throw ServiceError.badResponse(status: http.statusCode)
        }
        guard let count = Int64(String(decoding: data, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)) else {
            throw ServiceError.badResponse(status: http.statusCode)
        }
        return ReconciledWitnessCount(
            speciesID: event.speciesID,
            assignedPeriod: event.assignedPeriod,
            witnessCount: count
        )
    }

    /// Reads the public aggregate for a species and period. Requires no
    /// authentication: aggregates are the only public community data.
    func count(speciesID: String, assignedPeriod: String) async throws -> ReconciledWitnessCount {
        var components = URLComponents(
            url: configuration.baseURL.appending(path: "/rest/v1/witness_aggregates"),
            resolvingAgainstBaseURL: false
        )
        components?.queryItems = [
            URLQueryItem(name: "species_id", value: "eq.\(speciesID)"),
            URLQueryItem(name: "assigned_period", value: "eq.\(assignedPeriod)"),
            URLQueryItem(name: "select", value: "witness_count")
        ]
        guard let url = components?.url else { throw ServiceError.badResponse(status: -1) }
        var request = URLRequest(url: url)
        request.setValue(configuration.anonKey, forHTTPHeaderField: "apikey")

        let (data, response) = try await urlSession.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw ServiceError.badResponse(status: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        let rows = (try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]) ?? []
        let count = (rows.first?["witness_count"] as? NSNumber)?.int64Value ?? 0
        return ReconciledWitnessCount(
            speciesID: speciesID,
            assignedPeriod: assignedPeriod,
            witnessCount: count
        )
    }

    // MARK: - Silent anonymous session

    private func currentSession() async throws -> AnonymousSession {
        if let session = sessionStore.load() {
            if session.expiresAt > Date().addingTimeInterval(60) {
                return session
            }
            if let refreshed = try? await refresh(session) {
                sessionStore.save(refreshed)
                return refreshed
            }
            sessionStore.clear()
        }
        let created = try await signInAnonymously()
        sessionStore.save(created)
        return created
    }

    private func signInAnonymously() async throws -> AnonymousSession {
        var request = URLRequest(url: configuration.baseURL.appending(path: "/auth/v1/signup"))
        request.httpMethod = "POST"
        request.setValue(configuration.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = Data("{}".utf8)
        return try await authSession(for: request)
    }

    private func refresh(_ session: AnonymousSession) async throws -> AnonymousSession {
        var components = URLComponents(
            url: configuration.baseURL.appending(path: "/auth/v1/token"),
            resolvingAgainstBaseURL: false
        )
        components?.queryItems = [URLQueryItem(name: "grant_type", value: "refresh_token")]
        guard let url = components?.url else { throw ServiceError.authenticationFailed }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(configuration.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: ["refresh_token": session.refreshToken])
        return try await authSession(for: request)
    }

    private func authSession(for request: URLRequest) async throws -> AnonymousSession {
        let (data, response) = try await urlSession.data(for: request)
        guard
            let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode),
            let payload = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let accessToken = payload["access_token"] as? String,
            let refreshToken = payload["refresh_token"] as? String,
            let expiresIn = payload["expires_in"] as? TimeInterval,
            let user = payload["user"] as? [String: Any],
            let idString = user["id"] as? String,
            let userID = UUID(uuidString: idString)
        else {
            throw ServiceError.authenticationFailed
        }
        return AnonymousSession(
            userID: userID,
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresAt: Date().addingTimeInterval(expiresIn)
        )
    }
}
