import Foundation

public protocol ContentAccessPolicy: Sendable {
    func canAccess(_ requirement: ContentAccessRequirement, with snapshot: AccessSnapshot) -> Bool
}

/// The one content-access rule set:
/// - free is always authorized;
/// - Field Season is authorized by permanent ownership or active Atlas;
/// - Atlas content requires active Atlas.
/// Grace period keeps access (Apple continues service while payment is
/// retried); billing retry after grace, expiry, revocation, and unknown
/// all fail closed for paid content. Unknown never removes the free ritual.
public struct StandardContentAccessPolicy: ContentAccessPolicy {
    public init() {}

    public func canAccess(_ requirement: ContentAccessRequirement, with snapshot: AccessSnapshot) -> Bool {
        switch requirement {
        case .free:
            true
        case .fieldSeasonOne:
            snapshot.ownsFieldSeasonOne || atlasGrantsAccess(snapshot.atlas)
        case .atlas:
            atlasGrantsAccess(snapshot.atlas)
        }
    }

    public func atlasGrantsAccess(_ state: AtlasAccessState) -> Bool {
        switch state {
        case .active, .gracePeriod:
            true
        case .inactive, .billingRetry, .expired, .revoked, .unknown:
            false
        }
    }
}
