import Foundation

public enum WitnessSaveResult: Equatable, Sendable {
    case created(WitnessRecord)
    case existing(WitnessRecord)

    public var record: WitnessRecord {
        switch self {
        case let .created(record), let .existing(record): record
        }
    }
}

public enum WitnessPersistenceError: Error, Equatable, LocalizedError, Sendable {
    case recordNotFound(String)
    case reflectionTooLong(limit: Int)
    case unsupportedSchema(Int)

    public var errorDescription: String? {
        switch self {
        case let .recordNotFound(id):
            "The private Witness record \(id) could not be found."
        case let .reflectionTooLong(limit):
            "Private reflections are limited to \(limit) characters."
        case let .unsupportedSchema(version):
            "The local Witness archive uses unsupported schema version \(version)."
        }
    }
}

public protocol WitnessRepository: Sendable {
    func allRecords() async throws -> [WitnessRecord]
    func recordWitness(speciesID: String, localDay: String, witnessedAt: Date) async throws -> WitnessSaveResult
    func updateReflection(eventID: String, reflection: String?) async throws -> WitnessRecord
}
