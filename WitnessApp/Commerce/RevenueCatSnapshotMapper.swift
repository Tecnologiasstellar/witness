import Foundation
import WitnessCore

/// Provider-neutral facts extracted from a RevenueCat entitlement at the
/// adapter boundary. Keeping this a plain value type lets the mapping be
/// deterministic and fully unit-tested even though the SDK's
/// `EntitlementInfo` cannot be constructed in tests.
struct EntitlementFacts: Equatable {
    var isActive: Bool
    var willRenew: Bool?
    var expirationDate: Date?
    var billingIssueDetectedAt: Date?
    var unsubscribeDetectedAt: Date?
}

/// Maps RevenueCat entitlement facts into the domain `AccessSnapshot`.
enum RevenueCatSnapshotMapper {
    static func snapshot(
        fieldSeason: EntitlementFacts?,
        atlas: EntitlementFacts?,
        verifiedAt: Date
    ) -> AccessSnapshot {
        AccessSnapshot(
            ownsFieldSeasonOne: fieldSeason?.isActive == true,
            atlas: atlasState(from: atlas, now: verifiedAt),
            source: .provider,
            verifiedAt: verifiedAt
        )
    }

    /// RevenueCat surfaces Apple's grace period as an active entitlement
    /// with a detected billing issue; billing retry after grace appears as
    /// an inactive entitlement with a billing issue and a past expiration.
    static func atlasState(from facts: EntitlementFacts?, now: Date) -> AtlasAccessState {
        guard let facts else { return .inactive }
        if facts.isActive {
            if facts.billingIssueDetectedAt != nil {
                return .gracePeriod(expiration: facts.expirationDate)
            }
            return .active(expiration: facts.expirationDate, willRenew: facts.willRenew)
        }
        if facts.billingIssueDetectedAt != nil {
            return .billingRetry(expiration: facts.expirationDate)
        }
        if let expiration = facts.expirationDate, expiration <= now {
            return .expired(expiration)
        }
        return .inactive
    }
}
