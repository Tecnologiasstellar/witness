import Foundation
import Testing
@testable import WitnessCore

struct ContentAccessPolicyTests {
    let policy = StandardContentAccessPolicy()

    private func snapshot(
        ownsSeason: Bool = false,
        atlas: AtlasAccessState = .inactive,
        source: AccessSource = .provider
    ) -> AccessSnapshot {
        AccessSnapshot(ownsFieldSeasonOne: ownsSeason, atlas: atlas, source: source, verifiedAt: nil)
    }

    private static let grantingStates: [AtlasAccessState] = [
        .active(expiration: nil, willRenew: true),
        .active(expiration: Date(timeIntervalSince1970: 2_000_000_000), willRenew: false),
        .gracePeriod(expiration: Date(timeIntervalSince1970: 2_000_000_000))
    ]

    private static let denyingStates: [AtlasAccessState] = [
        .inactive,
        .billingRetry(expiration: Date(timeIntervalSince1970: 1_000_000_000)),
        .expired(Date(timeIntervalSince1970: 1_000_000_000)),
        .revoked(Date(timeIntervalSince1970: 1_000_000_000)),
        .unknown
    ]

    @Test func freeIsAlwaysAuthorized() {
        for owns in [false, true] {
            for atlas in Self.grantingStates + Self.denyingStates {
                #expect(policy.canAccess(.free, with: snapshot(ownsSeason: owns, atlas: atlas)))
            }
        }
        #expect(policy.canAccess(.free, with: .defaultFree))
    }

    @Test func fieldSeasonRequiresOwnershipOrActiveAtlas() {
        for atlas in Self.denyingStates {
            #expect(!policy.canAccess(.fieldSeasonOne, with: snapshot(atlas: atlas)))
            #expect(policy.canAccess(.fieldSeasonOne, with: snapshot(ownsSeason: true, atlas: atlas)))
        }
        for atlas in Self.grantingStates {
            #expect(policy.canAccess(.fieldSeasonOne, with: snapshot(atlas: atlas)))
        }
    }

    @Test func atlasContentRequiresActiveAtlas() {
        for atlas in Self.grantingStates {
            #expect(policy.canAccess(.atlas, with: snapshot(atlas: atlas)))
        }
        for atlas in Self.denyingStates {
            #expect(!policy.canAccess(.atlas, with: snapshot(atlas: atlas)))
            // Field Season ownership never unlocks Atlas-wide content.
            #expect(!policy.canAccess(.atlas, with: snapshot(ownsSeason: true, atlas: atlas)))
        }
    }

    @Test func atlasLapsePreservesOwnedSeason() {
        let lapsed = snapshot(ownsSeason: true, atlas: .expired(Date(timeIntervalSince1970: 1_000_000_000)))
        #expect(policy.canAccess(.free, with: lapsed))
        #expect(policy.canAccess(.fieldSeasonOne, with: lapsed))
        #expect(!policy.canAccess(.atlas, with: lapsed))
    }

    @Test func revocationRemovesSeasonAccessButNeverFree() {
        let revoked = snapshot(ownsSeason: false, atlas: .revoked(nil))
        #expect(policy.canAccess(.free, with: revoked))
        #expect(!policy.canAccess(.fieldSeasonOne, with: revoked))
        #expect(!policy.canAccess(.atlas, with: revoked))
    }

    @Test func unknownStateFailsClosedForPaidContentOnly() {
        let unknown = snapshot(atlas: .unknown, source: .unverifiedDefault)
        #expect(policy.canAccess(.free, with: unknown))
        #expect(!policy.canAccess(.fieldSeasonOne, with: unknown))
        #expect(!policy.canAccess(.atlas, with: unknown))
    }

    @Test func defaultFreeSnapshotIsUnverified() {
        #expect(AccessSnapshot.defaultFree.source == .unverifiedDefault)
        #expect(AccessSnapshot.defaultFree.verifiedAt == nil)
        #expect(!AccessSnapshot.defaultFree.ownsFieldSeasonOne)
        #expect(AccessSnapshot.defaultFree.atlas == .inactive)
    }

    @Test func accessSnapshotRoundTripsThroughCodable() throws {
        let original = snapshot(
            ownsSeason: true,
            atlas: .gracePeriod(expiration: Date(timeIntervalSince1970: 1_800_000_000))
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(AccessSnapshot.self, from: data)
        #expect(decoded == original)
    }
}

struct WitnessProductCatalogTests {
    @Test func allowListContainsExactlyFourProducts() {
        #expect(WitnessProductCatalog.allProductIDs.count == 4)
        #expect(Set(WitnessProductCatalog.allProductIDs).count == 4)
    }

    @Test func bothAtlasProductsMapToTheSameKind() {
        for id in WitnessProductCatalog.atlasProductIDs {
            #expect(WitnessProductCatalog.kind(forProductID: id) == .atlasSubscription)
        }
    }

    @Test func kindMappingCoversAllowListAndRejectsUnknown() {
        for id in WitnessProductCatalog.allProductIDs {
            #expect(WitnessProductCatalog.kind(forProductID: id) != nil)
        }
        #expect(WitnessProductCatalog.kind(forProductID: "com.avp.witness.plus.monthly") == nil)
    }
}
