#if DEBUG
import Foundation
import StoreKit
import WitnessCore

/// Debug-only StoreKit 2 implementation of `PurchaseService`, driven by the
/// local `Witness.storekit` configuration. This is deterministic test
/// infrastructure for the commerce surfaces and StoreKitTest automation.
/// It is compiled out of Release; production purchase execution arrives
/// with the RevenueCat adapter and is never this type.
actor StoreKitPurchaseAdapter: PurchaseService {
    enum AdapterError: Error, LocalizedError {
        case unverifiedTransaction

        var errorDescription: String? {
            "The purchase could not be verified by the store."
        }
    }

    func products() async throws -> [CommerceProduct] {
        let storeProducts = try await Product.products(for: WitnessProductCatalog.allProductIDs)
        let byID = Dictionary(uniqueKeysWithValues: storeProducts.map { ($0.id, $0) })
        // Preserve the allow-list order regardless of store response order.
        return WitnessProductCatalog.allProductIDs.compactMap { id in
            guard let product = byID[id], let kind = WitnessProductCatalog.kind(forProductID: id) else {
                return nil
            }
            return CommerceProduct(
                id: product.id,
                kind: kind,
                localizedTitle: product.displayName,
                localizedDescription: product.description,
                localizedPrice: product.displayPrice,
                duration: Self.duration(of: product),
                price: product.price,
                currencyCode: product.priceFormatStyle.currencyCode
            )
        }
    }

    func accessSnapshot(forceRefresh: Bool) async throws -> AccessSnapshot {
        var ownsFieldSeasonOne = false
        var atlasTransaction: Transaction?

        for await entitlement in Transaction.currentEntitlements {
            guard case .verified(let transaction) = entitlement else { continue }
            if transaction.productID == WitnessProductCatalog.fieldSeasonOneProductID {
                ownsFieldSeasonOne = transaction.revocationDate == nil
            }
            if WitnessProductCatalog.atlasProductIDs.contains(transaction.productID) {
                atlasTransaction = transaction
            }
        }

        return AccessSnapshot(
            ownsFieldSeasonOne: ownsFieldSeasonOne,
            atlas: await atlasState(currentTransaction: atlasTransaction),
            source: .provider,
            verifiedAt: Date()
        )
    }

    func purchase(productID: String) async throws -> PurchaseOutcome {
        guard
            WitnessProductCatalog.kind(forProductID: productID) != nil,
            let product = try await Product.products(for: [productID]).first
        else {
            return .failed(reason: "This product is not available right now.")
        }

        let result: Product.PurchaseResult
        do {
            result = try await product.purchase()
        } catch StoreKitError.userCancelled {
            return .userCancelled
        } catch {
            return .failed(reason: error.localizedDescription)
        }

        switch result {
        case .userCancelled:
            return .userCancelled
        case .pending:
            return .pending
        case .success(let verification):
            guard case .verified(let transaction) = verification else {
                throw AdapterError.unverifiedTransaction
            }
            await transaction.finish()
            if WitnessProductCatalog.kind(forProductID: productID) == .supportTip {
                return .supportThanks
            }
            return .success(try await accessSnapshot(forceRefresh: true))
        @unknown default:
            return .failed(reason: "The store returned an unrecognized result.")
        }
    }

    func restorePurchases() async throws -> RestoreOutcome {
        do {
            try await AppStore.sync()
        } catch {
            return .failed(reason: error.localizedDescription)
        }
        let snapshot = try await accessSnapshot(forceRefresh: true)
        let policy = StandardContentAccessPolicy()
        if snapshot.ownsFieldSeasonOne || policy.atlasGrantsAccess(snapshot.atlas) {
            return .restored(snapshot)
        }
        return .nothingToRestore
    }

    /// Maps the Atlas subscription-group status to the domain state, so the
    /// local harness exercises grace period, billing retry, expiry, and
    /// revocation the same way the production adapter must.
    private func atlasState(currentTransaction: Transaction?) async -> AtlasAccessState {
        guard let statuses = await subscriptionStatuses() else {
            if let transaction = currentTransaction {
                return .active(expiration: transaction.expirationDate, willRenew: nil)
            }
            return .inactive
        }

        // One product per group at a time; prefer the most favorable status.
        var best: AtlasAccessState = .inactive
        for status in statuses {
            guard case .verified(let renewal) = status.renewalInfo,
                  case .verified(let transaction) = status.transaction else { continue }
            let expiration = transaction.expirationDate
            switch status.state {
            case .subscribed:
                return .active(expiration: expiration, willRenew: renewal.willAutoRenew)
            case .inGracePeriod:
                best = .gracePeriod(expiration: renewal.gracePeriodExpirationDate ?? expiration)
            case .inBillingRetryPeriod:
                if case .gracePeriod = best {} else {
                    best = .billingRetry(expiration: expiration)
                }
            case .expired:
                if case .inactive = best { best = .expired(expiration) }
            case .revoked:
                if case .inactive = best { best = .revoked(transaction.revocationDate) }
            default:
                continue
            }
        }
        return best
    }

    private func subscriptionStatuses() async -> [Product.SubscriptionInfo.Status]? {
        guard
            let anyAtlasID = WitnessProductCatalog.atlasProductIDs.first,
            let product = try? await Product.products(for: [anyAtlasID]).first,
            let subscription = product.subscription,
            let statuses = try? await subscription.status
        else {
            return nil
        }
        return statuses
    }

    private static func duration(of product: Product) -> BillingDuration? {
        guard let period = product.subscription?.subscriptionPeriod else { return nil }
        switch (period.unit, period.value) {
        case (.month, 6): return .sixMonths
        case (.year, 1): return .annual
        default: return nil
        }
    }
}
#endif
