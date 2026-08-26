import StoreKit
import StoreKitTest
import XCTest
import WitnessCore
@testable import Witness

/// StoreKitTest coverage of the Debug purchase adapter against the local
/// `Witness.storekit` configuration. This proves local commerce behavior
/// only; it is not RevenueCat, Sandbox, or production evidence.
@MainActor
final class StoreKitPurchaseAdapterTests: XCTestCase {
    private var session: SKTestSession!
    private var adapter: StoreKitPurchaseAdapter!
    private let policy = StandardContentAccessPolicy()

    override func setUp() async throws {
        let bundle = Bundle(for: Self.self)
        let configuration = try XCTUnwrap(
            bundle.url(forResource: "Witness", withExtension: "storekit"),
            "Witness.storekit must be bundled with the test target"
        )
        session = try SKTestSession(contentsOf: configuration)
        session.resetToDefaultState()
        session.disableDialogs = true
        session.clearTransactions()
        adapter = StoreKitPurchaseAdapter()
    }

    override func tearDown() async throws {
        session.clearTransactions()
        session = nil
        adapter = nil
    }

    // MARK: - Products

    func testProductsMatchAllowListWithKindsAndDurations() async throws {
        let products = try await adapter.products()
        XCTAssertEqual(products.map(\.id), WitnessProductCatalog.allProductIDs)

        let byID = Dictionary(uniqueKeysWithValues: products.map { ($0.id, $0) })
        XCTAssertEqual(byID[WitnessProductCatalog.fieldSeasonOneProductID]?.kind, .permanentEdition)
        XCTAssertEqual(byID[WitnessProductCatalog.atlasSixMonthProductID]?.duration, .sixMonths)
        XCTAssertEqual(byID[WitnessProductCatalog.atlasAnnualProductID]?.duration, .annual)
        XCTAssertEqual(byID[WitnessProductCatalog.supportOnceProductID]?.kind, .supportTip)

        for product in products {
            XCTAssertFalse(product.localizedPrice.isEmpty)
            XCTAssertNotNil(product.price)
            XCTAssertNotNil(product.currencyCode)
        }
    }

    func testFreshStateHasNoEntitlements() async throws {
        let snapshot = try await adapter.accessSnapshot(forceRefresh: true)
        XCTAssertFalse(snapshot.ownsFieldSeasonOne)
        XCTAssertFalse(policy.atlasGrantsAccess(snapshot.atlas))
        XCTAssertTrue(policy.canAccess(.free, with: snapshot))
    }

    // MARK: - Field Season

    func testFieldSeasonPurchaseGrantsPermanentOwnershipOnly() async throws {
        let outcome = try await adapter.purchase(productID: WitnessProductCatalog.fieldSeasonOneProductID)
        guard case .success(let snapshot) = outcome else {
            return XCTFail("Expected success, got \(outcome)")
        }
        XCTAssertTrue(snapshot.ownsFieldSeasonOne)
        XCTAssertTrue(policy.canAccess(.fieldSeasonOne, with: snapshot))
        XCTAssertFalse(policy.canAccess(.atlas, with: snapshot))
    }

    func testFieldSeasonRefundRemovesOwnership() async throws {
        _ = try await adapter.purchase(productID: WitnessProductCatalog.fieldSeasonOneProductID)
        let transaction = try XCTUnwrap(
            session.allTransactions().first(where: {
                $0.productIdentifier == WitnessProductCatalog.fieldSeasonOneProductID
            })
        )
        try session.refundTransaction(identifier: UInt(transaction.identifier))

        let snapshot = try await waitForSnapshot { !$0.ownsFieldSeasonOne }
        XCTAssertFalse(policy.canAccess(.fieldSeasonOne, with: snapshot))
        XCTAssertTrue(policy.canAccess(.free, with: snapshot))
    }

    // MARK: - Atlas

    func testBothAtlasDurationsGrantTheSameAccess() async throws {
        for productID in [WitnessProductCatalog.atlasSixMonthProductID, WitnessProductCatalog.atlasAnnualProductID] {
            session.clearTransactions()
            let outcome = try await adapter.purchase(productID: productID)
            guard case .success = outcome else {
                return XCTFail("Expected success for \(productID), got \(outcome)")
            }
            let snapshot = try await waitForSnapshot { self.policy.atlasGrantsAccess($0.atlas) }
            XCTAssertTrue(policy.canAccess(.atlas, with: snapshot), "atlas access for \(productID)")
            XCTAssertTrue(policy.canAccess(.fieldSeasonOne, with: snapshot), "season inclusion for \(productID)")
            XCTAssertFalse(snapshot.ownsFieldSeasonOne, "subscription must not create permanent ownership")
        }
    }

    func testAtlasExpiryLocksAtlasButKeepsOwnedSeason() async throws {
        _ = try await adapter.purchase(productID: WitnessProductCatalog.fieldSeasonOneProductID)
        _ = try await adapter.purchase(productID: WitnessProductCatalog.atlasSixMonthProductID)
        try session.expireSubscription(productIdentifier: WitnessProductCatalog.atlasSixMonthProductID)

        let snapshot = try await waitForSnapshot { !self.policy.atlasGrantsAccess($0.atlas) }
        XCTAssertFalse(policy.canAccess(.atlas, with: snapshot))
        XCTAssertTrue(policy.canAccess(.fieldSeasonOne, with: snapshot), "owned season survives lapse")
        XCTAssertTrue(policy.canAccess(.free, with: snapshot))
    }

    // MARK: - Support

    func testSupportTipIsRepeatableAndGrantsNothing() async throws {
        for attempt in 1...2 {
            let outcome = try await adapter.purchase(productID: WitnessProductCatalog.supportOnceProductID)
            XCTAssertEqual(outcome, .supportThanks, "attempt \(attempt)")
        }
        let snapshot = try await adapter.accessSnapshot(forceRefresh: true)
        XCTAssertFalse(snapshot.ownsFieldSeasonOne)
        XCTAssertFalse(policy.atlasGrantsAccess(snapshot.atlas))
    }

    // MARK: - Pending, failure, restore

    func testAskToBuyReturnsPendingWithoutUnlock() async throws {
        session.askToBuyEnabled = true
        let outcome = try await adapter.purchase(productID: WitnessProductCatalog.fieldSeasonOneProductID)
        XCTAssertEqual(outcome, .pending)
        let snapshot = try await adapter.accessSnapshot(forceRefresh: true)
        XCTAssertFalse(snapshot.ownsFieldSeasonOne, "no unlock before approval")
    }

    func testFailedTransactionReportsFailureWithoutUnlock() async throws {
        session.failTransactionsEnabled = true
        let outcome = try await adapter.purchase(productID: WitnessProductCatalog.fieldSeasonOneProductID)
        guard case .failed = outcome else {
            return XCTFail("Expected failure, got \(outcome)")
        }
        session.failTransactionsEnabled = false
        let snapshot = try await adapter.accessSnapshot(forceRefresh: true)
        XCTAssertFalse(snapshot.ownsFieldSeasonOne)
    }

    func testRestoreOnFreshStateFindsNothing() async throws {
        let outcome = try await adapter.restorePurchases()
        XCTAssertEqual(outcome, .nothingToRestore)
    }

    func testRestoreAfterPurchaseReportsEntitlements() async throws {
        _ = try await adapter.purchase(productID: WitnessProductCatalog.fieldSeasonOneProductID)
        let outcome = try await adapter.restorePurchases()
        guard case .restored(let snapshot) = outcome else {
            return XCTFail("Expected restored, got \(outcome)")
        }
        XCTAssertTrue(snapshot.ownsFieldSeasonOne)
    }

    func testUnknownProductFailsClosed() async throws {
        let outcome = try await adapter.purchase(productID: "com.avp.witness.plus.monthly")
        guard case .failed = outcome else {
            return XCTFail("Expected failure, got \(outcome)")
        }
    }

    // MARK: - Helpers

    /// StoreKitTest state changes propagate to `Transaction.currentEntitlements`
    /// asynchronously; poll briefly instead of trusting one read.
    private func waitForSnapshot(
        timeout: TimeInterval = 5,
        where condition: @escaping (AccessSnapshot) -> Bool
    ) async throws -> AccessSnapshot {
        let deadline = Date().addingTimeInterval(timeout)
        var snapshot = try await adapter.accessSnapshot(forceRefresh: true)
        while !condition(snapshot), Date() < deadline {
            try await Task.sleep(nanoseconds: 200_000_000)
            snapshot = try await adapter.accessSnapshot(forceRefresh: true)
        }
        XCTAssertTrue(condition(snapshot), "Timed out waiting for snapshot condition; last: \(snapshot)")
        return snapshot
    }
}
