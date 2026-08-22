import Foundation

public struct WitnessRecord: Codable, Equatable, Identifiable, Sendable {
    public let id: String
    public let speciesID: String
    public let localDay: String
    public let witnessedAt: Date
    public var reflection: String?

    public init(
        id: String,
        speciesID: String,
        localDay: String,
        witnessedAt: Date,
        reflection: String? = nil
    ) {
        self.id = id
        self.speciesID = speciesID
        self.localDay = localDay
        self.witnessedAt = witnessedAt
        self.reflection = reflection
    }
}

public enum WitnessDayKey {
    public static func make(for date: Date, calendar: Calendar) -> String {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return String(
            format: "%04d-%02d-%02d",
            components.year ?? 0,
            components.month ?? 0,
            components.day ?? 0
        )
    }

    public static func eventID(speciesID: String, localDay: String) -> String {
        "\(localDay)|\(speciesID)"
    }
}

public protocol DateProviding: Sendable {
    func now() -> Date
}

public struct SystemDateProvider: DateProviding {
    public init() {}

    public func now() -> Date { Date() }
}
