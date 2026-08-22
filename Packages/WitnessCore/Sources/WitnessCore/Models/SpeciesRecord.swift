import Foundation

public struct SpeciesRecord: Codable, Equatable, Identifiable, Sendable {
    public let id: String
    public let schemaVersion: Int
    public let commonName: String
    public let scientificName: String
    public let conservationStatus: ConservationStatus
    public let generalizedRange: String
    public let hook: String
    public let story: [StorySection]
    public let action: ConservationAction
    public let media: MediaRecord
    public let publishDate: String
    public let sources: [SourceReference]
    public let editorial: EditorialReview

    public init(
        id: String,
        schemaVersion: Int,
        commonName: String,
        scientificName: String,
        conservationStatus: ConservationStatus,
        generalizedRange: String,
        hook: String,
        story: [StorySection],
        action: ConservationAction,
        media: MediaRecord,
        publishDate: String,
        sources: [SourceReference],
        editorial: EditorialReview
    ) {
        self.id = id
        self.schemaVersion = schemaVersion
        self.commonName = commonName
        self.scientificName = scientificName
        self.conservationStatus = conservationStatus
        self.generalizedRange = generalizedRange
        self.hook = hook
        self.story = story
        self.action = action
        self.media = media
        self.publishDate = publishDate
        self.sources = sources
        self.editorial = editorial
    }
}

public struct ConservationStatus: Codable, Equatable, Sendable {
    public let displayName: String
    public let normalizedValue: String

    public init(displayName: String, normalizedValue: String) {
        self.displayName = displayName
        self.normalizedValue = normalizedValue
    }
}

public struct StorySection: Codable, Equatable, Identifiable, Sendable {
    public let id: String
    public let text: String
    public let sourceIDs: [String]

    public init(id: String, text: String, sourceIDs: [String]) {
        self.id = id
        self.text = text
        self.sourceIDs = sourceIDs
    }
}

public struct ConservationAction: Codable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let summary: String
    public let effort: String
    public let destinationURL: String
    public let destinationOrganization: String
    public let geographicApplicability: String
    public let sourceIDs: [String]
    public let lastVerified: String
    public let measurementType: ActionMeasurement

    public init(
        id: String,
        title: String,
        summary: String,
        effort: String,
        destinationURL: String,
        destinationOrganization: String,
        geographicApplicability: String,
        sourceIDs: [String],
        lastVerified: String,
        measurementType: ActionMeasurement
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.effort = effort
        self.destinationURL = destinationURL
        self.destinationOrganization = destinationOrganization
        self.geographicApplicability = geographicApplicability
        self.sourceIDs = sourceIDs
        self.lastVerified = lastVerified
        self.measurementType = measurementType
    }
}

public enum ActionMeasurement: String, Codable, Equatable, Sendable {
    case opened
    case selfReported = "self_reported"
    case verified
}

public struct MediaRecord: Codable, Equatable, Sendable {
    public let assetID: String
    public let depictionType: String
    public let creator: String
    public let source: String
    public let license: String
    public let requiredAttribution: String
    public let commercialUseStatus: String
    public let verificationStatus: ReviewState

    public init(
        assetID: String,
        depictionType: String,
        creator: String,
        source: String,
        license: String,
        requiredAttribution: String,
        commercialUseStatus: String,
        verificationStatus: ReviewState
    ) {
        self.assetID = assetID
        self.depictionType = depictionType
        self.creator = creator
        self.source = source
        self.license = license
        self.requiredAttribution = requiredAttribution
        self.commercialUseStatus = commercialUseStatus
        self.verificationStatus = verificationStatus
    }
}

public struct SourceReference: Codable, Equatable, Identifiable, Sendable {
    public let id: String
    public let title: String
    public let organization: String
    public let url: String
    public let lastAccessed: String

    public init(id: String, title: String, organization: String, url: String, lastAccessed: String) {
        self.id = id
        self.title = title
        self.organization = organization
        self.url = url
        self.lastAccessed = lastAccessed
    }
}

public struct EditorialReview: Codable, Equatable, Sendable {
    public let state: ReviewState
    public let reviewer: String
    public let lastFactChecked: String
    public let sensitiveLocationReview: String
    public let notes: String

    public init(
        state: ReviewState,
        reviewer: String,
        lastFactChecked: String,
        sensitiveLocationReview: String,
        notes: String
    ) {
        self.state = state
        self.reviewer = reviewer
        self.lastFactChecked = lastFactChecked
        self.sensitiveLocationReview = sensitiveLocationReview
        self.notes = notes
    }
}

public enum ReviewState: String, Codable, Equatable, Sendable {
    case prototype
    case pending
    case approved
    case rejected
}
