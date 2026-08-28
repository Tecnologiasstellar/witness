import PDFKit
import XCTest
import WitnessCore
@testable import Witness

/// Smoke test for the field album export: the real bundled edition must
/// render into a well-formed PDF with a cover, one page per piece, and the
/// doors index — with the doors carrying live link annotations.
final class FieldAlbumComposerTests: XCTestCase {
    @MainActor
    func testAlbumRendersCoverPiecesAndDoors() throws {
        let edition = try XCTUnwrap(FieldSeasonLoader.loadBundledEdition())
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("album-test-\(UUID().uuidString).pdf")
        defer { try? FileManager.default.removeItem(at: url) }

        try FieldAlbumComposer.render(edition: edition, to: url)

        let document = try XCTUnwrap(PDFDocument(url: url))
        // Cover + one page per piece + a doors index of one or more pages.
        XCTAssertGreaterThanOrEqual(document.pageCount, edition.chapters.count + 2)

        // The doors index (all pages after the pieces) must carry one link
        // annotation per unique door, every one of them https.
        let uniqueDoors = Set(edition.chapters.flatMap { piece in
            piece.sections.filter { $0.style == .action }.flatMap(\.entries).compactMap(\.url)
        })
        XCTAssertGreaterThanOrEqual(uniqueDoors.count, 10)
        let indexPages = (edition.chapters.count + 1) ..< document.pageCount
        let links = indexPages.flatMap { document.page(at: $0)?.annotations.compactMap(\.url) ?? [] }
        XCTAssertGreaterThanOrEqual(links.count, uniqueDoors.count)
        for link in links {
            XCTAssertEqual(link.scheme, "https")
        }

        // No door row may draw past the printable page: every link
        // annotation sits inside the page bounds with room for its text.
        for pageIndex in indexPages {
            let page = try XCTUnwrap(document.page(at: pageIndex))
            let bounds = page.bounds(for: .mediaBox)
            for annotation in page.annotations {
                XCTAssertLessThanOrEqual(annotation.bounds.maxY, bounds.maxY)
                XCTAssertGreaterThanOrEqual(annotation.bounds.minY, 30)
            }
        }

        // The synthesis piece page carries its title; the closing note lands.
        let synthesis = try XCTUnwrap(document.page(at: edition.chapters.count)?.string)
        XCTAssertTrue(synthesis.contains("What the Counted Teach"))
        let lastPage = try XCTUnwrap(document.page(at: document.pageCount - 1)?.string)
        XCTAssertTrue(lastPage.contains("remember what is still here"))
    }
}
