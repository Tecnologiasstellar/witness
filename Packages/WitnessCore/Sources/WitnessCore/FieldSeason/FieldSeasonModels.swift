import Foundation

/// The Field Season edition as shipped in the bundle: authored, reviewed
/// premium chapters (D-020). Content is data, not code — the reader renders
/// whatever the reviewed JSON carries, so a new chapter is a content drop.
public struct FieldSeasonEdition: Codable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let plannedChapterCount: Int
    public let chapters: [FieldSeasonChapter]

    public init(id: String, title: String, plannedChapterCount: Int, chapters: [FieldSeasonChapter]) {
        self.id = id
        self.title = title
        self.plannedChapterCount = plannedChapterCount
        self.chapters = chapters
    }
}

public struct FieldSeasonChapter: Codable, Equatable, Sendable, Identifiable {
    public let id: String
    public let number: Int
    public let title: String
    public let speciesID: String
    public let heroAssetID: String?
    public let audio: FieldSeasonAudio?
    public let sections: [FieldSeasonSection]

    public init(
        id: String,
        number: Int,
        title: String,
        speciesID: String,
        heroAssetID: String?,
        audio: FieldSeasonAudio?,
        sections: [FieldSeasonSection]
    ) {
        self.id = id
        self.number = number
        self.title = title
        self.speciesID = speciesID
        self.heroAssetID = heroAssetID
        self.audio = audio
        self.sections = sections
    }
}

/// Narration metadata. The voice is synthetic and the reader must say so —
/// `voiceDisclosure` is required, not optional, wherever audio exists.
public struct FieldSeasonAudio: Codable, Equatable, Sendable {
    public let fileName: String
    public let fileExtension: String
    public let durationSeconds: Double
    public let voiceDisclosure: String

    public init(fileName: String, fileExtension: String, durationSeconds: Double, voiceDisclosure: String) {
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.durationSeconds = durationSeconds
        self.voiceDisclosure = voiceDisclosure
    }
}

public struct FieldSeasonSection: Codable, Equatable, Sendable, Identifiable {
    public enum Style: String, Codable, Sendable {
        case prose
        case numbered
        case timeline
        case knownUnknown
        case prompt
        case sources
    }

    public let heading: String
    public let style: Style
    public let entries: [FieldSeasonEntry]

    public var id: String { heading }

    public init(heading: String, style: Style, entries: [FieldSeasonEntry]) {
        self.heading = heading
        self.style = style
        self.entries = entries
    }
}

/// One block of a section. `lead` is the bold lead-in (a timeline year,
/// a numbered lever title, or a Known/Unknown label); `text` is the body.
public struct FieldSeasonEntry: Codable, Equatable, Sendable, Identifiable {
    public let lead: String?
    public let text: String

    public var id: String { (lead ?? "") + "|" + text.prefix(48) }

    public init(lead: String? = nil, text: String) {
        self.lead = lead
        self.text = text
    }
}
