import Foundation
import Testing
@testable import WitnessCore

@Suite("Catalog validation")
struct CatalogValidatorTests {
    @Test("Bundled prototype record is schema-valid and traceable")
    func bundledCatalogIsValid() throws {
        let records = try BundledSpeciesCatalog.load()

        #expect(records.count == 1)
        #expect(records.first?.id == "vaquita")
        #expect(records.first?.story.allSatisfy { !$0.sourceIDs.isEmpty } == true)
        // Approved Higgsfield artwork is in place; media rights stay pending
        // until the plan's commercial terms are verified (D-013).
        #expect(records.first?.media.verificationStatus == .pending)
    }

    @Test("Prototype evidence cannot pass the production gate")
    func productionRejectsPrototype() throws {
        let records = try BundledSpeciesCatalog.load()

        #expect(throws: CatalogValidationError.self) {
            try CatalogValidator.validate(records, mode: .production)
        }
    }

    @Test("An undeclared story source fails validation")
    func rejectsMissingStorySource() throws {
        let base = try #require(BundledSpeciesCatalog.load().first)
        let invalid = SpeciesRecord(
            id: base.id,
            schemaVersion: base.schemaVersion,
            commonName: base.commonName,
            scientificName: base.scientificName,
            conservationStatus: base.conservationStatus,
            generalizedRange: base.generalizedRange,
            hook: base.hook,
            story: [StorySection(id: "invalid", text: base.story.map(\.text).joined(separator: " "), sourceIDs: ["missing-source"])],
            action: base.action,
            media: base.media,
            publishDate: base.publishDate,
            sources: base.sources,
            editorial: base.editorial
        )

        #expect(throws: CatalogValidationError.self) {
            try CatalogValidator.validate([invalid])
        }
    }
}
