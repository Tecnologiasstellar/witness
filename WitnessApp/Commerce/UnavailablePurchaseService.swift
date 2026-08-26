import Foundation
import WitnessCore

/// Release composition until the production RevenueCat adapter lands.
/// Nothing is purchasable, no price is invented, and the free ritual is
/// untouched. Cached verified access (if any) still applies through the
/// access repository.
struct UnavailablePurchaseService: PurchaseService {
    struct Unavailable: Error, LocalizedError {
        var errorDescription: String? {
            "Purchases are not available in this build."
        }
    }

    func products() async throws -> [CommerceProduct] {
        throw Unavailable()
    }

    func accessSnapshot(forceRefresh: Bool) async throws -> AccessSnapshot {
        throw Unavailable()
    }

    func purchase(productID: String) async throws -> PurchaseOutcome {
        .failed(reason: "Purchases are not available in this build.")
    }

    func restorePurchases() async throws -> RestoreOutcome {
        .failed(reason: "Purchases are not available in this build.")
    }
}
