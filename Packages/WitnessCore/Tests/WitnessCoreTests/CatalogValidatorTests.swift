import Foundation
import Testing
@testable import WitnessCore

@Suite("Catalog validation")
struct CatalogValidatorTests {
    @Test("Bundled prototype record is schema-valid and traceable")
    func bundledCatalogIsValid() throws {
        let records = try BundledSpeciesCatalog.load()

        #expect(records.count == 30)
        #expect(records.first?.id == "vaquita")
        #expect(records.allSatisfy { record in record.story.allSatisfy { !$0.sourceIDs.isEmpty } })
        // Higgsfield's paid-plan commercial terms were confirmed by AV on 2026-08-25 (D-013),
        // and the full 30-card editorial pass cleared the same day.
        #expect(records.allSatisfy { $0.media.verificationStatus == .approved })
        #expect(records.allSatisfy { $0.editorial.state == .approved })
    }

    @Test("Reviewed catalog passes the production gate")
    func productionAcceptsApprovedCatalog() throws {
        let records = try BundledSpeciesCatalog.load()

        #expect(throws: Never.self) {
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
