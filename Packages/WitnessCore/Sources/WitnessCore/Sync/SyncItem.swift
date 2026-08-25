import Foundation

public struct SyncItem: Codable, Equatable, Identifiable, Sendable {
    public enum Kind: String, Codable, Sendable {
        case witness
        case event
    }

    public let id: UUID
    public let kind: Kind
    public let body: Data
    public let createdAt: Date

    public init(id: UUID = UUID(), kind: Kind, body: Data, createdAt: Date) {
        self.id = id
        self.kind = kind
        self.body = body
        self.createdAt = createdAt
    }
}

public protocol SyncTransport: Sendable {
    func send(_ item: SyncItem) async throws
}

public struct SyncDrainResult: Equatable, Sendable {
    public let sent: Int
    public let remaining: Int
    public let lastErrorDescription: String?

    public init(sent: Int, remaining: Int, lastErrorDescription: String?) {
        self.sent = sent
        self.remaining = remaining
        self.lastErrorDescription = lastErrorDescription
    }
}
