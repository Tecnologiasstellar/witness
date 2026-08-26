import Foundation
import SwiftUI
import WitnessCore

/// Presentation state for the commerce surfaces. UI state here is never
/// authorization: access decisions always flow from the verified or cached
/// `AccessSnapshot` through `StandardContentAccessPolicy`, and unknown or
/// failed provider state degrades to the free ritual, never to a lock-out
/// of free content or an invented unlock.
@MainActor
final class CommerceModel: ObservableObject {
    enum ProductsState: Equatable {
        case loading
        case unavailable(String)
        case ready([CommerceProduct])
    }

    enum PurchasePhase: Equatable {
        case idle
        case purchasing(productID: String)
        case pendingApproval
        case unlocked
        case supportThanked
        case failed(String)
    }

    enum RestorePhase: Equatable {
        case idle
        case restoring
        case restoredWithChanges
        case nothingFound
        case failed(String)
    }

    @Published private(set) var productsState: ProductsState = .loading
    @Published private(set) var snapshot: AccessSnapshot = .defaultFree
    @Published private(set) var purchasePhase: PurchasePhase = .idle
    @Published private(set) var restorePhase: RestorePhase = .idle

    private let purchaseService: any PurchaseService
    private let accessRepository: any AccessRepository
    private let policy = StandardContentAccessPolicy()
    private var didStart = false

    init(purchaseService: any PurchaseService, accessRepository: any AccessRepository) {
        self.purchaseService = purchaseService
        self.accessRepository = accessRepository
    }

    // MARK: - Access facts

    func canAccess(_ requirement: ContentAccessRequirement) -> Bool {
        policy.canAccess(requirement, with: snapshot)
    }

    var ownsFieldSeason: Bool { snapshot.ownsFieldSeasonOne }
    var atlasIsActive: Bool { policy.atlasGrantsAccess(snapshot.atlas) }

    /// Honest one-line Atlas status for the Access overview. Dates are
    /// verified store data; no date is invented.
    var atlasStatusLine: String {
        switch snapshot.atlas {
        case .inactive:
            return "Not active"
        case .active(let expiration, let willRenew):
            guard let expiration else { return "Active" }
            let date = Self.dateText(expiration)
            return willRenew == true ? "Renews \(date)" : "Active until \(date)"
        case .gracePeriod(let expiration):
            guard let expiration else { return "Active — payment issue" }
            return "Active until \(Self.dateText(expiration)) — payment issue"
        case .billingRetry:
            return "Payment issue — access paused"
        case .expired:
            return "Expired"
        case .revoked:
            return "Not active"
        case .unknown:
            return "Status unavailable — try refresh"
        }
    }

    var accessVerifiedLine: String? {
        switch snapshot.source {
        case .provider:
            guard let verifiedAt = snapshot.verifiedAt else { return nil }
            return "Verified \(Self.dateText(verifiedAt))"
        case .localCache:
            guard let verifiedAt = snapshot.verifiedAt else { return "From last verified state" }
            return "Last verified \(Self.dateText(verifiedAt))"
        case .unverifiedDefault:
            return nil
        }
    }

    // MARK: - Products

    var fieldSeasonProduct: CommerceProduct? { product(WitnessProductCatalog.fieldSeasonOneProductID) }
    var atlasSixMonthProduct: CommerceProduct? { product(WitnessProductCatalog.atlasSixMonthProductID) }
    var atlasAnnualProduct: CommerceProduct? { product(WitnessProductCatalog.atlasAnnualProductID) }
    var supportProduct: CommerceProduct? { product(WitnessProductCatalog.supportOnceProductID) }

    /// True only when calculated from decimal prices in one currency.
    var annualIsBetterMonthlyValue: Bool {
        guard let annual = atlasAnnualProduct, let sixMonth = atlasSixMonthProduct else { return false }
        return isBetterMonthlyValue(annual, than: sixMonth)
    }

    private func product(_ id: String) -> CommerceProduct? {
        guard case .ready(let products) = productsState else { return nil }
        return products.first(where: { $0.id == id })
    }

    // MARK: - Lifecycle

    func startIfNeeded() async {
        guard !didStart else { return }
        didStart = true
        if let cached = await accessRepository.cachedSnapshot() {
            snapshot = cached
        }
        await refresh()
    }

    func refresh() async {
        if case .ready = productsState {} else {
            productsState = .loading
        }
        do {
            let products = try await purchaseService.products()
            productsState = products.isEmpty
                ? .unavailable("Nothing is available right now. The free ritual is unaffected.")
                : .ready(products)
        } catch {
            productsState = .unavailable("The store could not be reached. Your access and the free ritual are unaffected.")
        }
        await refreshAccess()
    }

    func refreshAccess() async {
        do {
            let verified = try await purchaseService.accessSnapshot(forceRefresh: true)
            snapshot = verified
            try? await accessRepository.save(verified)
        } catch {
            // Keep the cached or default snapshot; never fabricate state.
        }
    }

    // MARK: - Purchase and restore

    func purchase(productID: String) async {
        guard case .idle = purchasePhase.normalizedForNewAttempt else { return }
        purchasePhase = .purchasing(productID: productID)
        do {
            switch try await purchaseService.purchase(productID: productID) {
            case .success(let newSnapshot):
                snapshot = newSnapshot
                try? await accessRepository.save(newSnapshot)
                purchasePhase = .unlocked
            case .supportThanks:
                purchasePhase = .supportThanked
            case .pending:
                purchasePhase = .pendingApproval
            case .userCancelled:
                purchasePhase = .idle
            case .failed(let reason):
                purchasePhase = .failed(reason)
            }
        } catch {
            purchasePhase = .failed(error.localizedDescription)
        }
    }

    func restore() async {
        guard restorePhase != .restoring else { return }
        restorePhase = .restoring
        do {
            switch try await purchaseService.restorePurchases() {
            case .restored(let newSnapshot):
                let changed = newSnapshot.ownsFieldSeasonOne != snapshot.ownsFieldSeasonOne
                    || newSnapshot.atlas != snapshot.atlas
                snapshot = newSnapshot
                try? await accessRepository.save(newSnapshot)
                restorePhase = changed ? .restoredWithChanges : .nothingFound
            case .nothingToRestore:
                restorePhase = .nothingFound
            case .failed(let reason):
                restorePhase = .failed(reason)
            }
        } catch {
            restorePhase = .failed(error.localizedDescription)
        }
    }

    func clearTransientPhases() {
        purchasePhase = .idle
        restorePhase = .idle
    }

    private static func dateText(_ date: Date) -> String {
        date.formatted(date: .abbreviated, time: .omitted)
    }
}

private extension CommerceModel.PurchasePhase {
    /// Terminal phases may start a new attempt; an in-flight one may not.
    var normalizedForNewAttempt: CommerceModel.PurchasePhase {
        switch self {
        case .purchasing, .pendingApproval: self
        case .idle, .unlocked, .supportThanked, .failed: .idle
        }
    }
}
