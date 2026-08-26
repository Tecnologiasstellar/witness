import Foundation
import RevenueCat
import WitnessCore

/// Production purchase execution through RevenueCat. Configured exactly once
/// in the composition root with the public Apple SDK key; never from views.
/// All SDK types stay behind this boundary — the app sees only the domain
/// models from `WitnessCore`.
struct RevenueCatPurchaseAdapter: PurchaseService {
    /// Must be called once, before the adapter is used.
    @MainActor
    static func configure(apiKey: String) {
        guard !Purchases.isConfigured else { return }
        Purchases.logLevel = .warn
        Purchases.configure(withAPIKey: apiKey)
    }

    func products() async throws -> [CommerceProduct] {
        let offerings = try await Purchases.shared.offerings()
        let offering = offerings.offering(identifier: RevenueCatIdentifiers.offering) ?? offerings.current
        guard let offering else { return [] }

        let byProductID = Dictionary(
            offering.availablePackages.map { ($0.storeProduct.productIdentifier, $0) },
            uniquingKeysWith: { first, _ in first }
        )
        // Allow-list order and allow-list membership are the contract; an
        // unexpected product in the offering is ignored, never sold.
        return WitnessProductCatalog.allProductIDs.compactMap { productID in
            guard
                let package = byProductID[productID],
                let kind = WitnessProductCatalog.kind(forProductID: productID)
            else { return nil }
            let product = package.storeProduct
            return CommerceProduct(
                id: product.productIdentifier,
                kind: kind,
                localizedTitle: product.localizedTitle,
                localizedDescription: product.localizedDescription,
                localizedPrice: product.localizedPriceString,
                duration: Self.duration(of: product),
                price: product.price,
                currencyCode: product.currencyCode
            )
        }
    }

    func accessSnapshot(forceRefresh: Bool) async throws -> AccessSnapshot {
        let info = try await Purchases.shared.customerInfo(
            fetchPolicy: forceRefresh ? .fetchCurrent : .cachedOrFetched
        )
        return Self.snapshot(from: info)
    }

    func purchase(productID: String) async throws -> PurchaseOutcome {
        guard WitnessProductCatalog.kind(forProductID: productID) != nil else {
            return .failed(reason: "This product is not available.")
        }
        let offerings = try await Purchases.shared.offerings()
        let offering = offerings.offering(identifier: RevenueCatIdentifiers.offering) ?? offerings.current
        guard let package = offering?.availablePackages.first(where: {
            $0.storeProduct.productIdentifier == productID
        }) else {
            return .failed(reason: "This product is not available right now.")
        }

        do {
            let result = try await Purchases.shared.purchase(package: package)
            if result.userCancelled { return .userCancelled }
            if WitnessProductCatalog.kind(forProductID: productID) == .supportTip {
                return .supportThanks
            }
            return .success(Self.snapshot(from: result.customerInfo))
        } catch let error as ErrorCode {
            switch error {
            case .paymentPendingError:
                return .pending
            case .purchaseCancelledError:
                return .userCancelled
            default:
                return .failed(reason: error.localizedDescription)
            }
        }
    }

    func restorePurchases() async throws -> RestoreOutcome {
        do {
            let info = try await Purchases.shared.restorePurchases()
            let snapshot = Self.snapshot(from: info)
            let policy = StandardContentAccessPolicy()
            if snapshot.ownsFieldSeasonOne || policy.atlasGrantsAccess(snapshot.atlas) {
                return .restored(snapshot)
            }
            return .nothingToRestore
        } catch {
            return .failed(reason: error.localizedDescription)
        }
    }

    // MARK: - Mapping boundary

    static func snapshot(from info: CustomerInfo) -> AccessSnapshot {
        RevenueCatSnapshotMapper.snapshot(
            fieldSeason: facts(from: info.entitlements[RevenueCatIdentifiers.fieldSeasonEntitlement]),
            atlas: facts(from: info.entitlements[RevenueCatIdentifiers.atlasEntitlement]),
            verifiedAt: Date()
        )
    }

    private static func facts(from entitlement: EntitlementInfo?) -> EntitlementFacts? {
        guard let entitlement else { return nil }
        return EntitlementFacts(
            isActive: entitlement.isActive,
            willRenew: entitlement.willRenew,
            expirationDate: entitlement.expirationDate,
            billingIssueDetectedAt: entitlement.billingIssueDetectedAt,
            unsubscribeDetectedAt: entitlement.unsubscribeDetectedAt
        )
    }

    private static func duration(of product: StoreProduct) -> BillingDuration? {
        guard let period = product.subscriptionPeriod else { return nil }
        switch (period.unit, period.value) {
        case (.month, 6): return .sixMonths
        case (.year, 1): return .annual
        default: return nil
        }
    }
}

/// RevenueCat dashboard identifiers, mirrored from the source of record.
enum RevenueCatIdentifiers {
    static let offering = "witness_access_v1"
    static let fieldSeasonEntitlement = "field_season_1_access"
    static let atlasEntitlement = "atlas_access"
}
