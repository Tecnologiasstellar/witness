import Foundation
import SwiftUI
import WitnessCore

/// Which paid surface an event happened on (§14 "paywall viewed by context").
enum CommerceContext: String {
    case fieldSeasonPreview = "fieldseason_preview"
    case atlasSheet = "atlas_sheet"
    case support
    case index
}

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
    private let logEvent: (String, [String: String]) -> Void
    private var didStart = false
    private var isRefreshing = false

    init(
        purchaseService: any PurchaseService,
        accessRepository: any AccessRepository,
        logEvent: @escaping (String, [String: String]) -> Void = CommerceModel.sendToWitnessSync
    ) {
        self.purchaseService = purchaseService
        self.accessRepository = accessRepository
        self.logEvent = logEvent
    }

    /// Fire-and-forget, matching the call shape the views already use.
    /// Never blocks or fails a purchase: `logEvent` no-ops without a transport.
    static let sendToWitnessSync: @Sendable (String, [String: String]) -> Void = { name, metadata in
        Task.detached { await WitnessSync.shared.logEvent(name, metadata: metadata) }
    }

    // MARK: - Funnel (§14)

    /// `state` keeps the conversion denominator honest: a member reopening a
    /// paid page to get back into it is not a paywall view. Same vocabulary
    /// as `works_shelf_opened`.
    func paywallViewed(_ context: CommerceContext) {
        let held = switch context {
        case .fieldSeasonPreview: ownsFieldSeason || atlasIsActive
        case .atlasSheet: atlasIsActive
        case .support, .index: false
        }
        logEvent("paywall_viewed", [
            "context": context.rawValue,
            "state": held ? "held" : "unheld"
        ])
    }

    func libraryOpened(from context: CommerceContext) {
        logEvent("atlas_library_opened", ["context": context.rawValue])
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
        // A failed store fetch is not a completed start: the next surface
        // that appears tries again instead of showing a stale failure.
        if case .unavailable = productsState {
            await refresh()
            return
        }
        guard !didStart else { return }
        didStart = true
        if let cached = await accessRepository.cachedSnapshot() {
            snapshot = cached
        }
        await refresh()
    }

    func refresh() async {
        // Two surfaces appearing at once must not double-fetch.
        guard !isRefreshing else { return }
        isRefreshing = true
        defer { isRefreshing = false }
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

    /// Foreground re-fetches products only when the last attempt failed;
    /// otherwise it just re-verifies access.
    func refreshOnForeground() async {
        if case .unavailable = productsState {
            await refresh()
        } else {
            await refreshAccess()
        }
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

    func purchase(productID: String, context: CommerceContext) async {
        guard case .idle = purchasePhase.normalizedForNewAttempt else { return }
        purchasePhase = .purchasing(productID: productID)
        var base = ["context": context.rawValue, "product": productID]
        logEvent("purchase_started", base)
        do {
            switch try await purchaseService.purchase(productID: productID) {
            case .success(let newSnapshot):
                snapshot = newSnapshot
                try? await accessRepository.save(newSnapshot)
                purchasePhase = .unlocked
                logEvent("purchase_succeeded", base)
            case .supportThanks:
                purchasePhase = .supportThanked
                logEvent("purchase_succeeded", base)
            case .pending:
                purchasePhase = .pendingApproval
                logEvent("purchase_pending", base)
            case .userCancelled:
                purchasePhase = .idle
                logEvent("purchase_cancelled", base)
            case .failed(let reason):
                purchasePhase = .failed(reason)
                base["reason"] = Self.shortReason(reason)
                logEvent("purchase_failed", base)
            }
        } catch {
            let reason = error.localizedDescription
            purchasePhase = .failed(reason)
            base["reason"] = Self.shortReason(reason)
            logEvent("purchase_failed", base)
        }
    }

    func restore(context: CommerceContext) async {
        guard restorePhase != .restoring else { return }
        restorePhase = .restoring
        let base = ["context": context.rawValue]
        logEvent("restore_started", base)
        do {
            switch try await purchaseService.restorePurchases() {
            case .restored(let newSnapshot):
                let changed = newSnapshot.ownsFieldSeasonOne != snapshot.ownsFieldSeasonOne
                    || newSnapshot.atlas != snapshot.atlas
                snapshot = newSnapshot
                try? await accessRepository.save(newSnapshot)
                restorePhase = changed ? .restoredWithChanges : .nothingFound
                logEvent("restore_finished", base.merging(
                    ["outcome": changed ? "restored" : "nothing"]) { _, new in new })
            case .nothingToRestore:
                restorePhase = .nothingFound
                logEvent("restore_finished", base.merging(["outcome": "nothing"]) { _, new in new })
            case .failed(let reason):
                restorePhase = .failed(reason)
                logEvent("restore_finished", base.merging(
                    ["outcome": "failed", "reason": Self.shortReason(reason)]) { _, new in new })
            }
        } catch {
            let reason = error.localizedDescription
            restorePhase = .failed(reason)
            logEvent("restore_finished", base.merging(
                ["outcome": "failed", "reason": Self.shortReason(reason)]) { _, new in new })
        }
    }

    /// Store errors can be long and localized; the funnel only needs enough
    /// to tell one failure mode from another.
    private static func shortReason(_ reason: String) -> String {
        String(reason.prefix(120))
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
