import Foundation

/// The single typed allow-list of purchasable products and entitlements.
/// Product IDs are immutable in App Store Connect; these are candidates
/// until the founder approves creation (Decision D-013, Section 8).
public enum WitnessProductCatalog {
    public static let fieldSeasonOneProductID = "com.avp.witness.fieldseason1"
    public static let atlasSixMonthProductID = "com.avp.witness.atlas.sixmonth"
    public static let atlasAnnualProductID = "com.avp.witness.atlas.annual"
    public static let supportOnceProductID = "com.avp.witness.support.once"

    public static let fieldSeasonOneEntitlementID = "field_season_1_access"
    public static let atlasEntitlementID = "atlas_access"

    public static let allProductIDs: [String] = [
        fieldSeasonOneProductID,
        atlasSixMonthProductID,
        atlasAnnualProductID,
        supportOnceProductID
    ]

    public static let atlasProductIDs: Set<String> = [
        atlasSixMonthProductID,
        atlasAnnualProductID
    ]

    public static func kind(forProductID id: String) -> CommerceProductKind? {
        switch id {
        case fieldSeasonOneProductID: .permanentEdition
        case atlasSixMonthProductID, atlasAnnualProductID: .atlasSubscription
        case supportOnceProductID: .supportTip
        default: nil
        }
    }
}
