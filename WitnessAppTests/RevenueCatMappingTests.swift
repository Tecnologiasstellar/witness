import XCTest
import RevenueCat
import WitnessCore
@testable import Witness

/// Deterministic tests for the RevenueCat fact mapping and configuration
/// validation. These need no store session, network, or SDK object
/// construction.
final class RevenueCatMappingTests: XCTestCase {
    private let now = Date(timeIntervalSince1970: 1_756_300_000)
    private let policy = StandardContentAccessPolicy()

    private func future(_ seconds: TimeInterval = 86_400) -> Date { now.addingTimeInterval(seconds) }
    private func past(_ seconds: TimeInterval = 86_400) -> Date { now.addingTimeInterval(-seconds) }

    // MARK: - Atlas state mapping

    func testNoEntitlementIsInactive() {
        XCTAssertEqual(RevenueCatSnapshotMapper.atlasState(from: nil, now: now), .inactive)
    }

    func testActiveEntitlementMapsToActiveWithRenewalAndExpiry() {
        let facts = EntitlementFacts(
            isActive: true, willRenew: true, expirationDate: future(),
            billingIssueDetectedAt: nil, unsubscribeDetectedAt: nil
        )
        XCTAssertEqual(
            RevenueCatSnapshotMapper.atlasState(from: facts, now: now),
            .active(expiration: future(), willRenew: true)
        )
    }

    func testCancelledButPaidPeriodRemainsActiveUntilExpiry() {
        let facts = EntitlementFacts(
            isActive: true, willRenew: false, expirationDate: future(),
            billingIssueDetectedAt: nil, unsubscribeDetectedAt: past(3_600)
        )
        let state = RevenueCatSnapshotMapper.atlasState(from: facts, now: now)
        XCTAssertEqual(state, .active(expiration: future(), willRenew: false))
        XCTAssertTrue(policy.atlasGrantsAccess(state), "cancellation alone never cuts paid access")
    }

    func testActiveWithBillingIssueIsGracePeriodAndGrantsAccess() {
        let facts = EntitlementFacts(
            isActive: true, willRenew: true, expirationDate: future(),
            billingIssueDetectedAt: past(3_600), unsubscribeDetectedAt: nil
        )
        let state = RevenueCatSnapshotMapper.atlasState(from: facts, now: now)
        XCTAssertEqual(state, .gracePeriod(expiration: future()))
        XCTAssertTrue(policy.atlasGrantsAccess(state))
    }

    func testInactiveWithBillingIssueIsBillingRetryAndDeniesAccess() {
        let facts = EntitlementFacts(
            isActive: false, willRenew: false, expirationDate: past(),
            billingIssueDetectedAt: past(3_600), unsubscribeDetectedAt: nil
        )
        let state = RevenueCatSnapshotMapper.atlasState(from: facts, now: now)
        XCTAssertEqual(state, .billingRetry(expiration: past()))
        XCTAssertFalse(policy.atlasGrantsAccess(state))
    }

    func testLapsedEntitlementIsExpired() {
        let facts = EntitlementFacts(
            isActive: false, willRenew: false, expirationDate: past(),
            billingIssueDetectedAt: nil, unsubscribeDetectedAt: past(172_800)
        )
        XCTAssertEqual(RevenueCatSnapshotMapper.atlasState(from: facts, now: now), .expired(past()))
    }

    // MARK: - Snapshot composition

    func testSeasonOwnershipAndAtlasComposeIndependently() {
        let season = EntitlementFacts(
            isActive: true, willRenew: nil, expirationDate: nil,
            billingIssueDetectedAt: nil, unsubscribeDetectedAt: nil
        )
        let snapshot = RevenueCatSnapshotMapper.snapshot(fieldSeason: season, atlas: nil, verifiedAt: now)
        XCTAssertTrue(snapshot.ownsFieldSeasonOne)
        XCTAssertEqual(snapshot.atlas, .inactive)
        XCTAssertEqual(snapshot.source, .provider)
        XCTAssertEqual(snapshot.verifiedAt, now)
        XCTAssertTrue(policy.canAccess(.fieldSeasonOne, with: snapshot))
        XCTAssertFalse(policy.canAccess(.atlas, with: snapshot))
    }

    func testRevokedSeasonMapsToNoOwnership() {
        let revoked = EntitlementFacts(
            isActive: false, willRenew: nil, expirationDate: past(),
            billingIssueDetectedAt: nil, unsubscribeDetectedAt: nil
        )
        let snapshot = RevenueCatSnapshotMapper.snapshot(fieldSeason: revoked, atlas: nil, verifiedAt: now)
        XCTAssertFalse(snapshot.ownsFieldSeasonOne)
        XCTAssertFalse(policy.canAccess(.fieldSeasonOne, with: snapshot))
        XCTAssertTrue(policy.canAccess(.free, with: snapshot))
    }

    // MARK: - Configuration validation

    func testProductionKeyIsValidEverywhere() {
        XCTAssertNil(CommerceConfiguration.validate(key: "appl_abc123", isReleaseBuild: false))
        XCTAssertNil(CommerceConfiguration.validate(key: "appl_abc123", isReleaseBuild: true))
    }

    func testTestStoreKeyIsRejectedInRelease() {
        XCTAssertNil(CommerceConfiguration.validate(key: "test_abc123", isReleaseBuild: false))
        XCTAssertEqual(
            CommerceConfiguration.validate(key: "test_abc123", isReleaseBuild: true),
            .testStoreKeyInRelease
        )
    }

    func testSecretAndMalformedKeysAreAlwaysRejected() {
        XCTAssertEqual(CommerceConfiguration.validate(key: "sk_secret", isReleaseBuild: false), .malformedKey)
        XCTAssertEqual(CommerceConfiguration.validate(key: "sk_secret", isReleaseBuild: true), .malformedKey)
        XCTAssertEqual(CommerceConfiguration.validate(key: "goog_wrongstore", isReleaseBuild: false), .malformedKey)
    }

    func testMissingConfigurationDisablesCommerceWithoutError() {
        let configuration = CommerceConfiguration(revenueCatAPIKey: nil)
        XCTAssertNil(configuration.usableKey())
    }

    // MARK: - Purchase error mapping

    /// The whole reason this mapping is hand-rolled: `error as? ErrorCode`
    /// succeeds, but the bound enum has no localized description, so the
    /// reader would be shown an error number instead of the store's message.
    func testFailureKeepsTheStoresOwnMessage() {
        let message = "There was a problem with the App Store."
        let error = NSError(domain: ErrorCode.errorDomain,
                            code: ErrorCode.storeProblemError.rawValue,
                            userInfo: [NSLocalizedDescriptionKey: message])
        XCTAssertEqual(
            RevenueCatPurchaseAdapter.outcome(forPurchaseError: error),
            .failed(reason: message)
        )
        XCTAssertNotEqual(
            (error as? ErrorCode)?.localizedDescription, message,
            "if the enum ever carries the message, this mapping can be simplified"
        )
    }

    func testAskToBuyIsPendingApprovalNotAFailedPurchase() {
        let error = NSError(domain: ErrorCode.errorDomain,
                            code: ErrorCode.paymentPendingError.rawValue)
        XCTAssertEqual(RevenueCatPurchaseAdapter.outcome(forPurchaseError: error), .pending)
    }

    func testCancellationIsSilentNotAFailedPurchase() {
        let error = NSError(domain: ErrorCode.errorDomain,
                            code: ErrorCode.purchaseCancelledError.rawValue)
        XCTAssertEqual(RevenueCatPurchaseAdapter.outcome(forPurchaseError: error), .userCancelled)
    }

    /// A code borrowed from another domain must never be read as a
    /// RevenueCat code — offline is a failure, not a pending approval.
    func testForeignDomainIsNeverReadAsARevenueCatCode() {
        let offline = NSError(domain: NSURLErrorDomain,
                              code: ErrorCode.paymentPendingError.rawValue)
        guard case .failed = RevenueCatPurchaseAdapter.outcome(forPurchaseError: offline) else {
            return XCTFail("a URL error must not be mapped as a RevenueCat outcome")
        }
    }
}
