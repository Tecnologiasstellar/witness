import Foundation

/// Deterministic in-memory purchase service for previews and tests.
/// Scriptable per-product behavior lets a test or preview walk every
/// purchase state without a store SDK.
public actor FakePurchaseService: PurchaseService {
    public enum ScriptedBehavior: Equatable, Sendable {
        case succeed
        case cancel
        case pend
        case fail(reason: String)
    }

    private var snapshot: AccessSnapshot
    private var behaviors: [String: ScriptedBehavior]
    private var restorableSnapshot: AccessSnapshot?
    private(set) public var supportTipCount = 0

    public init(
        snapshot: AccessSnapshot = .defaultFree,
        behaviors: [String: ScriptedBehavior] = [:],
        restorableSnapshot: AccessSnapshot? = nil
    ) {
        self.snapshot = snapshot
        self.behaviors = behaviors
        self.restorableSnapshot = restorableSnapshot
    }

    public func products() async throws -> [CommerceProduct] {
        [
            CommerceProduct(
                id: WitnessProductCatalog.fieldSeasonOneProductID,
                kind: .permanentEdition,
                localizedTitle: "Field Season",
                localizedDescription: "Permanent access to Field Season.",
                localizedPrice: "$0.00",
                duration: nil
            ),
            CommerceProduct(
                id: WitnessProductCatalog.atlasSixMonthProductID,
                kind: .atlasSubscription,
                localizedTitle: "Atlas - 6 Months",
                localizedDescription: "Full Atlas access, renewed every 6 months.",
                localizedPrice: "$0.00",
                duration: .sixMonths
            ),
            CommerceProduct(
                id: WitnessProductCatalog.atlasAnnualProductID,
                kind: .atlasSubscription,
                localizedTitle: "Atlas - Annual",
                localizedDescription: "Full Atlas access, renewed annually.",
                localizedPrice: "$0.00",
                duration: .annual
            ),
            CommerceProduct(
                id: WitnessProductCatalog.supportOnceProductID,
                kind: .supportTip,
                localizedTitle: "Support Witness",
                localizedDescription: "A one-time tip supporting Witness.",
                localizedPrice: "$0.00",
                duration: nil
            )
        ]
    }

    public func accessSnapshot(forceRefresh: Bool) async throws -> AccessSnapshot {
        snapshot
    }

    public func purchase(productID: String) async throws -> PurchaseOutcome {
        guard let kind = WitnessProductCatalog.kind(forProductID: productID) else {
            return .failed(reason: "Unknown product: \(productID)")
        }
        switch behaviors[productID] ?? .succeed {
        case .cancel:
            return .userCancelled
        case .pend:
            return .pending
        case .fail(let reason):
            return .failed(reason: reason)
        case .succeed:
            break
        }
        switch kind {
        case .supportTip:
            supportTipCount += 1
            return .supportThanks
        case .permanentEdition:
            snapshot.ownsFieldSeasonOne = true
        case .atlasSubscription:
            snapshot.atlas = .active(expiration: nil, willRenew: true)
        }
        snapshot.source = .provider
        return .success(snapshot)
    }

    public func restorePurchases() async throws -> RestoreOutcome {
        guard let restorableSnapshot else { return .nothingToRestore }
        snapshot = restorableSnapshot
        return .restored(snapshot)
    }

    /// Simulate a provider-verified state change (expiry, refund, revocation).
    public func applyProviderUpdate(_ newSnapshot: AccessSnapshot) {
        snapshot = newSnapshot
    }
}
