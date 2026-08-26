import Foundation

public struct WitnessRecord: Codable, Equatable, Identifiable, Sendable {
    public let id: String
    public let speciesID: String
    /// The ritual period this Witness belongs to. Weekly records use the
    /// `YYYY-Www` week key; records created before the weekly cadence
    /// (D-016) carry their original `YYYY-MM-DD` day key and remain valid
    /// history. The JSON key stays `localDay` so existing archives load
    /// unchanged.
    public let assignedPeriod: String
    public let witnessedAt: Date
    public var reflection: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case speciesID
        case assignedPeriod = "localDay"
        case witnessedAt
        case reflection
    }

    public init(
        id: String,
        speciesID: String,
        assignedPeriod: String,
        witnessedAt: Date,
        reflection: String? = nil
    ) {
        self.id = id
        self.speciesID = speciesID
        self.assignedPeriod = assignedPeriod
        self.witnessedAt = witnessedAt
        self.reflection = reflection
    }
}

/// Canonical ritual period keys. The ritual is weekly (D-016): ISO 8601
/// weeks (Monday start) evaluated in the caller's calendar time zone, so
/// every participant worldwide shares one key format while week boundaries
/// follow local time the same way local days used to.
public enum WitnessPeriodKey {
    public static func make(for date: Date, calendar: Calendar) -> String {
        var iso = Calendar(identifier: .iso8601)
        iso.timeZone = calendar.timeZone
        let components = iso.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return String(format: "%04d-W%02d", components.yearForWeekOfYear ?? 0, components.weekOfYear ?? 0)
    }

    public static func eventID(speciesID: String, period: String) -> String {
        "\(period)|\(speciesID)"
    }
}

public protocol DateProviding: Sendable {
    func now() -> Date
}

public struct SystemDateProvider: DateProviding {
    public init() {}

    public func now() -> Date { Date() }
}
