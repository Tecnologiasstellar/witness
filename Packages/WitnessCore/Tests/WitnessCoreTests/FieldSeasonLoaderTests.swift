import Foundation
import Testing
@testable import WitnessCore

@Suite("Field Season edition loading")
struct FieldSeasonLoaderTests {
    @Test("Bundled edition loads with the approved chapter one")
    func bundledEditionLoads() throws {
        let edition = try #require(FieldSeasonLoader.loadBundledEdition())
        #expect(edition.id == "field-season-1")
        #expect(edition.plannedChapterCount == 8)

        let chapter = try #require(edition.chapters.first)
        #expect(chapter.id == "fs1-ch01-vaquita")
        #expect(chapter.speciesID == "vaquita")
        #expect(chapter.number == 1)
        #expect(!chapter.sections.isEmpty)

        // The reader depends on these structural sections existing.
        let headings = chapter.sections.map(\.heading)
        #expect(headings.contains("FIELD NOTE"))
        #expect(headings.contains(where: { $0.hasPrefix("THE PAST") }))
        #expect(headings.contains(where: { $0.hasPrefix("THE PRESENT") }))
        #expect(headings.contains(where: { $0.hasPrefix("THE FUTURE") }))
        #expect(headings.contains("TIMELINE OF EVIDENCE"))
        #expect(headings.contains("SOURCES"))
    }

    @Test("Audio always carries the synthetic-voice disclosure")
    func audioDisclosurePresent() throws {
        let edition = try #require(FieldSeasonLoader.loadBundledEdition())
        for chapter in edition.chapters {
            if let audio = chapter.audio {
                #expect(audio.voiceDisclosure.localizedCaseInsensitiveContains("synthetic"))
                #expect(audio.durationSeconds > 0)
            }
        }
    }

    @Test("Timeline entries all carry a dated lead")
    func timelineEntriesDated() throws {
        let edition = try #require(FieldSeasonLoader.loadBundledEdition())
        let chapter = try #require(edition.chapters.first)
        let timeline = try #require(chapter.sections.first(where: { $0.style == .timeline }))
        #expect(timeline.entries.count >= 6)
        for entry in timeline.entries {
            #expect(entry.lead?.isEmpty == false)
        }
    }
}
