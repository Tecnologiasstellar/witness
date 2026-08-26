import Foundation

/// What a piece of content requires before it can be opened.
/// Free is the default for the entire public ritual and is always authorized.
public enum ContentAccessRequirement: String, Codable, Equatable, Sendable {
    case free
    case fieldSeasonOne = "field_season_1"
    case atlas
}

/// The only durable access facts the app tracks.
/// Five user-facing engagement choices exist, but authorization is exactly
/// permanent Field Season ownership plus one shared Atlas entitlement state.
public struct AccessSnapshot: Codable, Equatable, Sendable {
    public var ownsFieldSeasonOne: Bool
    public var atlas: AtlasAccessState
    public var source: AccessSource
    public var verifiedAt: Date?

    public init(
        ownsFieldSeasonOne: Bool,
        atlas: AtlasAccessState,
        source: AccessSource,
        verifiedAt: Date?
    ) {
        self.ownsFieldSeasonOne = ownsFieldSeasonOne
        self.atlas = atlas
        self.source = source
        self.verifiedAt = verifiedAt
    }

    /// The state every install starts in: full free ritual, no paid access,
    /// nothing verified. Unknown or missing provider data must degrade to
    /// this, never to a fabricated entitlement.
    public static let defaultFree = AccessSnapshot(
        ownsFieldSeasonOne: false,
        atlas: .inactive,
        source: .unverifiedDefault,
        verifiedAt: nil
    )
}

/// Where an access snapshot came from, so callers can present honest
/// verification state without inventing dates.
public enum AccessSource: String, Codable, Equatable, Sendable {
    case unverifiedDefault
    case localCache
    case provider
}

/// Verified Atlas subscription state mapped from the purchase provider.
/// Both Atlas billing durations resolve to this one state.
public enum AtlasAccessState: Codable, Equatable, Sendable {
    case inactive
    case active(expiration: Date?, willRenew: Bool?)
    case gracePeriod(expiration: Date?)
    case billingRetry(expiration: Date?)
    case expired(Date?)
    case revoked(Date?)
    case unknown
}

/// A provider-neutral purchasable product for presentation.
/// Localized values always come from live store data, never hardcoded prices.
public struct CommerceProduct: Equatable, Sendable {
    public let id: String
    public let kind: CommerceProductKind
    public let localizedTitle: String
    public let localizedDescription: String
    public let localizedPrice: String
    public let duration: BillingDuration?
    /// Decimal store price for value math. Comparisons must use this, never
    /// the localized display string, and only within one currency.
    public let price: Decimal?
    public let currencyCode: String?

    public init(
        id: String,
        kind: CommerceProductKind,
        localizedTitle: String,
        localizedDescription: String,
        localizedPrice: String,
        duration: BillingDuration?,
        price: Decimal? = nil,
        currencyCode: String? = nil
    ) {
        self.id = id
        self.kind = kind
        self.localizedTitle = localizedTitle
        self.localizedDescription = localizedDescription
        self.localizedPrice = localizedPrice
        self.duration = duration
        self.price = price
        self.currencyCode = currencyCode
    }

    /// Equivalent monthly price for a subscription, calculated from the
    /// decimal price and billing duration. Nil for non-subscriptions or
    /// when the store did not supply a decimal price.
    public var pricePerMonth: Decimal? {
        guard let price, let duration else { return nil }
        switch duration {
        case .sixMonths: return price / 6
        case .annual: return price / 12
        }
    }
}

/// True only when both subscriptions share a currency and the candidate is
/// strictly cheaper per month. This is the only condition under which the
/// interface may claim a better value.
public func isBetterMonthlyValue(_ candidate: CommerceProduct, than other: CommerceProduct) -> Bool {
    guard
        let candidateMonthly = candidate.pricePerMonth,
        let otherMonthly = other.pricePerMonth,
        let candidateCurrency = candidate.currencyCode,
        let otherCurrency = other.currencyCode,
        candidateCurrency == otherCurrency
    else {
        return false
    }
    return candidateMonthly < otherMonthly
}

public enum CommerceProductKind: String, Codable, Equatable, Sendable {
    case permanentEdition
    case atlasSubscription
    case supportTip
}

public enum BillingDuration: String, Codable, Equatable, Sendable {
    case sixMonths = "six_months"
    case annual
}

/// Result of a purchase attempt. A support tip success carries no access
/// change; content purchases surface the refreshed snapshot.
public enum PurchaseOutcome: Equatable, Sendable {
    case success(AccessSnapshot)
    case supportThanks
    case pending
    case userCancelled
    case failed(reason: String)
}

public enum RestoreOutcome: Equatable, Sendable {
    case restored(AccessSnapshot)
    case nothingToRestore
    case failed(reason: String)
}
