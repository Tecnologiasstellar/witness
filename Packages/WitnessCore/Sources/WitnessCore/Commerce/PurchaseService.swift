import Foundation

/// Provider-neutral purchase boundary. The RevenueCat adapter in WitnessApp
/// implements this; WitnessCore never imports a store SDK.
public protocol PurchaseService: Sendable {
    func products() async throws -> [CommerceProduct]
    func accessSnapshot(forceRefresh: Bool) async throws -> AccessSnapshot
    func purchase(productID: String) async throws -> PurchaseOutcome
    func restorePurchases() async throws -> RestoreOutcome
}

/// Local persistence of the last verified access snapshot so paid content
/// the user is entitled to keeps working offline. Contains no secrets and
/// is never authoritative over provider verification.
public protocol AccessRepository: Sendable {
    func cachedSnapshot() async -> AccessSnapshot?
    func save(_ snapshot: AccessSnapshot) async throws
}
