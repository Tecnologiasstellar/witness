import XCTest
import WitnessCore
@testable import Witness

/// Coverage of the commerce presentation state machine and the §14 funnel
/// events. The store itself is `FakePurchaseService`; what is proven here is
/// the model's own behavior — phase transitions, the events they emit, and
/// recovery from a failed product fetch.
@MainActor
final class CommerceModelTests: XCTestCase {
    /// Records what would have been sent to `WitnessSync`.
    private final class EventRecorder {
        private(set) var events: [(name: String, metadata: [String: String])] = []

        var names: [String] { events.map(\.name) }

        func metadata(for name: String) -> [String: String]? {
            events.first(where: { $0.name == name })?.metadata
        }

        var record: (String, [String: String]) -> Void {
            { [self] name, metadata in events.append((name, metadata)) }
        }
    }

    private var recorder: EventRecorder!
    private var cacheURL: URL!

    override func setUp() async throws {
        recorder = EventRecorder()
        cacheURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("CommerceModelTests-\(UUID().uuidString).json")
    }

    override func tearDown() async throws {
        try? FileManager.default.removeItem(at: cacheURL)
        recorder = nil
        cacheURL = nil
    }

    private func makeModel(
        service: any PurchaseService
    ) -> CommerceModel {
        CommerceModel(
            purchaseService: service,
            accessRepository: FileAccessRepository(fileURL: cacheURL),
            logEvent: recorder.record
        )
    }

    private func makeModel(
        snapshot: AccessSnapshot = .defaultFree,
        behaviors: [String: FakePurchaseService.ScriptedBehavior] = [:],
        restorableSnapshot: AccessSnapshot? = nil
    ) -> CommerceModel {
        makeModel(service: FakePurchaseService(
            snapshot: snapshot,
            behaviors: behaviors,
            restorableSnapshot: restorableSnapshot
        ))
    }

    // MARK: - Purchase phases and their events

    func testSuccessfulPurchaseUnlocksAndLogsTheFunnel() async throws {
        let model = makeModel()
        await model.startIfNeeded()

        await model.purchase(
            productID: WitnessProductCatalog.fieldSeasonOneProductID,
            context: .fieldSeasonPreview
        )

        XCTAssertEqual(model.purchasePhase, .unlocked)
        XCTAssertTrue(model.ownsFieldSeason)
        XCTAssertEqual(recorder.names.filter { $0.hasPrefix("purchase_") },
                       ["purchase_started", "purchase_succeeded"])
        XCTAssertEqual(recorder.metadata(for: "purchase_succeeded"), [
            "context": "fieldseason_preview",
            "product": WitnessProductCatalog.fieldSeasonOneProductID
        ])
    }

    func testCancelledPurchaseReturnsToIdleAndStaysSilent() async throws {
        let model = makeModel(behaviors: [
            WitnessProductCatalog.atlasAnnualProductID: .cancel
        ])
        await model.startIfNeeded()

        await model.purchase(
            productID: WitnessProductCatalog.atlasAnnualProductID,
            context: .atlasSheet
        )

        // Cancellation is not an error: no phase notice, no access change.
        XCTAssertEqual(model.purchasePhase, .idle)
        XCTAssertFalse(model.atlasIsActive)
        XCTAssertTrue(recorder.names.contains("purchase_cancelled"))
    }

    func testFailedPurchaseCarriesItsReason() async throws {
        let model = makeModel(behaviors: [
            WitnessProductCatalog.atlasSixMonthProductID: .fail(reason: "Card declined.")
        ])
        await model.startIfNeeded()

        await model.purchase(
            productID: WitnessProductCatalog.atlasSixMonthProductID,
            context: .atlasSheet
        )

        XCTAssertEqual(model.purchasePhase, .failed("Card declined."))
        XCTAssertEqual(recorder.metadata(for: "purchase_failed")?["reason"], "Card declined.")
        XCTAssertFalse(model.atlasIsActive)
    }

    func testPendingPurchaseGrantsNothingYet() async throws {
        let model = makeModel(behaviors: [
            WitnessProductCatalog.fieldSeasonOneProductID: .pend
        ])
        await model.startIfNeeded()

        await model.purchase(
            productID: WitnessProductCatalog.fieldSeasonOneProductID,
            context: .fieldSeasonPreview
        )

        XCTAssertEqual(model.purchasePhase, .pendingApproval)
        XCTAssertFalse(model.ownsFieldSeason)
        XCTAssertTrue(recorder.names.contains("purchase_pending"))
    }

    func testSupportTipThanksAndGrantsNoEntitlement() async throws {
        let model = makeModel()
        await model.startIfNeeded()

        await model.purchase(
            productID: WitnessProductCatalog.supportOnceProductID,
            context: .support
        )

        XCTAssertEqual(model.purchasePhase, .supportThanked)
        XCTAssertFalse(model.ownsFieldSeason)
        XCTAssertFalse(model.atlasIsActive)
        XCTAssertEqual(recorder.metadata(for: "purchase_succeeded"), [
            "context": "support",
            "product": WitnessProductCatalog.supportOnceProductID
        ])
    }

    // MARK: - Paywall views

    func testPaywallViewMarksWhetherTheWorkIsAlreadyHeld() async throws {
        let model = makeModel()
        await model.startIfNeeded()

        model.paywallViewed(.atlasSheet)
        XCTAssertEqual(recorder.metadata(for: "paywall_viewed")?["state"], "unheld")

        // A member reopening the page to get back in is not a paywall view,
        // and must not sink the conversion rate.
        await model.purchase(
            productID: WitnessProductCatalog.atlasAnnualProductID,
            context: .atlasSheet
        )
        model.paywallViewed(.atlasSheet)
        XCTAssertEqual(recorder.events.filter { $0.name == "paywall_viewed" }.last?.metadata["state"],
                       "held")
    }

    // MARK: - Restore

    func testRestoreWithChangesReportsRestored() async throws {
        var restored = AccessSnapshot.defaultFree
        restored.ownsFieldSeasonOne = true
        let model = makeModel(restorableSnapshot: restored)
        await model.startIfNeeded()

        await model.restore(context: .fieldSeasonPreview)

        XCTAssertEqual(model.restorePhase, .restored)
        XCTAssertTrue(model.ownsFieldSeason)
        XCTAssertEqual(recorder.metadata(for: "restore_finished")?["outcome"], "restored")
    }

    /// AV hit this on build 5: restore once, then restore again, and the app
    /// said "No previous purchases were found for this Apple account" to a
    /// reader who owned both products. Purchases were found; they simply did
    /// not change anything.
    func testSecondRestoreDoesNotClaimNothingWasFound() async throws {
        var restored = AccessSnapshot.defaultFree
        restored.ownsFieldSeasonOne = true
        let model = makeModel(restorableSnapshot: restored)

        await model.restore(context: .index)
        XCTAssertEqual(model.restorePhase, .restored)

        await model.restore(context: .index)
        XCTAssertEqual(model.restorePhase, .restored, "already-owned must never read as nothing found")
        XCTAssertTrue(model.snapshot.ownsFieldSeasonOne)
    }

    func testRestoreWithNothingToFindSaysSo() async throws {
        let model = makeModel()
        await model.startIfNeeded()

        await model.restore(context: .index)

        XCTAssertEqual(model.restorePhase, .nothingFound)
        XCTAssertEqual(recorder.metadata(for: "restore_finished"), [
            "context": "index",
            "outcome": "nothing"
        ])
    }

    // MARK: - Recovery from a failed product fetch

    /// Fails `products()` once, then behaves. Everything else defers to a
    /// real fake so only the fetch is under test.
    private actor FlakyStore: PurchaseService {
        private let inner = FakePurchaseService()
        private var attempts = 0

        struct Offline: Error {}

        func products() async throws -> [CommerceProduct] {
            attempts += 1
            if attempts == 1 { throw Offline() }
            return try await inner.products()
        }

        func accessSnapshot(forceRefresh: Bool) async throws -> AccessSnapshot {
            try await inner.accessSnapshot(forceRefresh: forceRefresh)
        }

        func purchase(productID: String) async throws -> PurchaseOutcome {
            try await inner.purchase(productID: productID)
        }

        func restorePurchases() async throws -> RestoreOutcome {
            try await inner.restorePurchases()
        }
    }

    func testAFailedStoreFetchRetriesOnTheNextSurface() async throws {
        let model = makeModel(service: FlakyStore())

        // First surface: offline. The reader sees the honest unavailable state.
        await model.startIfNeeded()
        guard case .unavailable = model.productsState else {
            return XCTFail("Expected the first fetch to fail, got \(model.productsState)")
        }

        // Second surface appearing must try again rather than show the stale
        // failure — the `didStart` latch used to swallow this forever.
        await model.startIfNeeded()
        guard case .ready(let products) = model.productsState else {
            return XCTFail("Expected recovery, got \(model.productsState)")
        }
        XCTAssertFalse(products.isEmpty)
    }

    func testForegroundRefreshRecoversAFailedStore() async throws {
        let model = makeModel(service: FlakyStore())
        await model.startIfNeeded()

        await model.refreshOnForeground()

        guard case .ready = model.productsState else {
            return XCTFail("Expected recovery on foreground, got \(model.productsState)")
        }
    }
}
