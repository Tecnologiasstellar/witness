import Foundation
import Testing
@testable import WitnessCore

struct FakePurchaseServiceTests {
    let policy = StandardContentAccessPolicy()

    @Test func fieldSeasonPurchaseGrantsPermanentOwnershipOnly() async throws {
        let service = FakePurchaseService()
        let outcome = try await service.purchase(productID: WitnessProductCatalog.fieldSeasonOneProductID)
        guard case .success(let snapshot) = outcome else {
            Issue.record("Expected success, got \(outcome)")
            return
        }
        #expect(snapshot.ownsFieldSeasonOne)
        #expect(policy.canAccess(.fieldSeasonOne, with: snapshot))
        #expect(!policy.canAccess(.atlas, with: snapshot))
    }

    @Test func eitherAtlasDurationGrantsTheSameAccess() async throws {
        for productID in WitnessProductCatalog.atlasProductIDs {
            let service = FakePurchaseService()
            let outcome = try await service.purchase(productID: productID)
            guard case .success(let snapshot) = outcome else {
                Issue.record("Expected success for \(productID), got \(outcome)")
                return
            }
            #expect(policy.canAccess(.atlas, with: snapshot))
            #expect(policy.canAccess(.fieldSeasonOne, with: snapshot))
            #expect(!snapshot.ownsFieldSeasonOne)
        }
    }

    @Test func supportTipIsRepeatableAndGrantsNothing() async throws {
        let service = FakePurchaseService()
        for _ in 1...3 {
            let outcome = try await service.purchase(productID: WitnessProductCatalog.supportOnceProductID)
            #expect(outcome == .supportThanks)
        }
        #expect(await service.supportTipCount == 3)
        let snapshot = try await service.accessSnapshot(forceRefresh: true)
        #expect(snapshot == .defaultFree)
    }

    @Test func cancelPendingAndFailureDoNotChangeAccess() async throws {
        let service = FakePurchaseService(behaviors: [
            WitnessProductCatalog.fieldSeasonOneProductID: .cancel,
            WitnessProductCatalog.atlasAnnualProductID: .pend,
            WitnessProductCatalog.atlasSixMonthProductID: .fail(reason: "network")
        ])
        #expect(try await service.purchase(productID: WitnessProductCatalog.fieldSeasonOneProductID) == .userCancelled)
        #expect(try await service.purchase(productID: WitnessProductCatalog.atlasAnnualProductID) == .pending)
        #expect(try await service.purchase(productID: WitnessProductCatalog.atlasSixMonthProductID) == .failed(reason: "network"))
        let snapshot = try await service.accessSnapshot(forceRefresh: true)
        #expect(snapshot == .defaultFree)
    }

    @Test func unknownProductFailsWithoutAccessChange() async throws {
        let service = FakePurchaseService()
        let outcome = try await service.purchase(productID: "com.avp.witness.plus.monthly")
        guard case .failed = outcome else {
            Issue.record("Expected failure, got \(outcome)")
            return
        }
        #expect(try await service.accessSnapshot(forceRefresh: true) == .defaultFree)
    }

    @Test func restoreReturnsNothingOnFreshInstall() async throws {
        let service = FakePurchaseService()
        #expect(try await service.restorePurchases() == .nothingToRestore)
    }

    @Test func restoreRecoversPermanentOwnership() async throws {
        let owned = AccessSnapshot(
            ownsFieldSeasonOne: true,
            atlas: .inactive,
            source: .provider,
            verifiedAt: Date(timeIntervalSince1970: 1_756_000_000)
        )
        let service = FakePurchaseService(restorableSnapshot: owned)
        let outcome = try await service.restorePurchases()
        #expect(outcome == .restored(owned))
        #expect(try await service.accessSnapshot(forceRefresh: true) == owned)
    }

    @Test func providerRefundRemovesSeasonAccess() async throws {
        let service = FakePurchaseService()
        _ = try await service.purchase(productID: WitnessProductCatalog.fieldSeasonOneProductID)
        await service.applyProviderUpdate(.defaultFree)
        let snapshot = try await service.accessSnapshot(forceRefresh: true)
        #expect(!policy.canAccess(.fieldSeasonOne, with: snapshot))
        #expect(policy.canAccess(.free, with: snapshot))
    }

    @Test func providerExpiryLocksAtlasButKeepsOwnedSeason() async throws {
        let service = FakePurchaseService()
        _ = try await service.purchase(productID: WitnessProductCatalog.fieldSeasonOneProductID)
        _ = try await service.purchase(productID: WitnessProductCatalog.atlasAnnualProductID)
        var lapsed = try await service.accessSnapshot(forceRefresh: true)
        lapsed.atlas = .expired(Date(timeIntervalSince1970: 1_756_000_000))
        await service.applyProviderUpdate(lapsed)
        let snapshot = try await service.accessSnapshot(forceRefresh: true)
        #expect(!policy.canAccess(.atlas, with: snapshot))
        #expect(policy.canAccess(.fieldSeasonOne, with: snapshot))
    }

    @Test func fakeProductListMatchesAllowList() async throws {
        let products = try await FakePurchaseService().products()
        #expect(products.map(\.id) == WitnessProductCatalog.allProductIDs)
        let atlasProducts = products.filter { $0.kind == .atlasSubscription }
        #expect(Set(atlasProducts.compactMap(\.duration)) == [.sixMonths, .annual])
    }
}
