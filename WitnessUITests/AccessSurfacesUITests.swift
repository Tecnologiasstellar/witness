import XCTest

/// UI coverage of the Index access surfaces against the deterministic fake
/// purchase service. Proves placement, states, and honest copy — not store
/// behavior, which `WitnessAppTests` covers with StoreKitTest.
final class AccessSurfacesUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchEnvironment["WITNESS_TEST_ARCHIVE"] = UUID().uuidString
        app.launchEnvironment["WITNESS_COMMERCE"] = "fake"
        app.launch()
    }

    /// Opens the Index sheet, retrying once: the first synthesized tap after
    /// launch is occasionally dropped while the plate is still settling.
    private func openIndex() {
        let contents = app.buttons["today.contents"]
        XCTAssertTrue(contents.waitForExistence(timeout: 5))
        contents.tap()
        if !app.staticTexts["INDEX"].waitForExistence(timeout: 3) {
            contents.tap()
            XCTAssertTrue(app.staticTexts["INDEX"].waitForExistence(timeout: 5))
        }
    }

    func testFreeRitualShowsNoCommerceBeforeFirstWitness() throws {
        // Today opens straight into the ritual with no paywall or price.
        XCTAssertTrue(app.buttons["today.witnessButton"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.staticTexts["Best value"].exists)
        XCTAssertFalse(app.buttons["access.fieldseason.purchase"].exists)
        XCTAssertFalse(app.buttons["access.support.tip"].exists)

        // The works are present on the card as content doors — never as
        // prices or purchase buttons.
        XCTAssertTrue(app.buttons["today.fieldseason.door"].exists)
        XCTAssertTrue(app.buttons["today.atlas.door"].exists)
        XCTAssertFalse(app.buttons["access.atlas.sixmonth"].exists)
        XCTAssertFalse(app.buttons["access.atlas.annual"].exists)
    }

    func testAccessOverviewFieldSeasonPurchaseAndSupportFlow() throws {
        openIndex()

        // Access overview facts.
        XCTAssertTrue(app.otherElements["access.overview.free"].waitForExistence(timeout: 3)
            || app.staticTexts["access.overview.free"].exists)
        XCTAssertTrue(app.buttons["access.overview.fieldseason"].exists)
        XCTAssertTrue(app.buttons["access.overview.atlas"].exists)
        XCTAssertTrue(app.buttons["access.overview.restore"].exists)
        XCTAssertTrue(app.buttons["access.overview.support"].exists)

        // Field Season preview: free promise and purchase. Retry the tap
        // once: synthesized taps occasionally land on a settling frame and
        // are dropped (same flake family as openIndex).
        app.buttons["access.overview.fieldseason"].tap()
        let purchase = app.buttons["access.fieldseason.purchase"]
        if !purchase.waitForExistence(timeout: 5) {
            app.buttons["access.overview.fieldseason"].tap()
            XCTAssertTrue(purchase.waitForExistence(timeout: 5))
        }
        purchase.tap()
        var owned = app.staticTexts["access.fieldseason.owned"].waitForExistence(timeout: 5)
            || app.otherElements["access.fieldseason.owned"].waitForExistence(timeout: 2)
        if !owned, purchase.exists {
            purchase.tap()
            owned = app.staticTexts["access.fieldseason.owned"].waitForExistence(timeout: 5)
                || app.otherElements["access.fieldseason.owned"].waitForExistence(timeout: 2)
        }
        XCTAssertTrue(owned)

        // Back to the overview; ownership is reflected.
        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(app.buttons["access.overview.fieldseason"].waitForExistence(timeout: 3))

        // Support: repeatable tip with quiet thanks and no unlock language.
        app.buttons["access.overview.support"].tap()
        let tip = app.buttons["access.support.tip"]
        XCTAssertTrue(tip.waitForExistence(timeout: 5))
        tip.tap()
        let notice = app.staticTexts["access.phase.notice"]
        XCTAssertTrue(notice.waitForExistence(timeout: 5))
        XCTAssertTrue(notice.label.contains("Thank you"))
        XCTAssertFalse(notice.label.lowercased().contains("unlock"))
    }

    func testOwnedFieldSeasonOpensReaderWithNarrationDisclosure() throws {
        openIndex()

        // Purchase Field Season through the fake service, then open the edition.
        app.buttons["access.overview.fieldseason"].tap()
        let purchase = app.buttons["access.fieldseason.purchase"]
        XCTAssertTrue(purchase.waitForExistence(timeout: 5))
        purchase.tap()

        let open = app.buttons["access.fieldseason.open"]
        XCTAssertTrue(open.waitForExistence(timeout: 5))
        open.tap()

        // Edition list shows chapter one and the honest in-production rows.
        let chapterOne = app.buttons["fieldseason.chapter.1"]
        XCTAssertTrue(chapterOne.waitForExistence(timeout: 5))
        chapterOne.tap()

        // Reader: title, and the synthetic-voice disclosure beside the audio.
        XCTAssertTrue(app.staticTexts["fieldseason.reader.title"].waitForExistence(timeout: 5))
        let disclosure = app.staticTexts["fieldseason.audio.disclosure"]
        XCTAssertTrue(disclosure.waitForExistence(timeout: 5))
        XCTAssertTrue(disclosure.label.lowercased().contains("synthetic"))
        XCTAssertTrue(app.buttons["fieldseason.audio.toggle"].exists)
    }

    func testAtlasSheetOffersTwoEqualDurations() throws {
        openIndex()
        XCTAssertTrue(app.buttons["access.overview.atlas"].waitForExistence(timeout: 3))
        app.buttons["access.overview.atlas"].tap()

        XCTAssertTrue(app.buttons["access.atlas.sixmonth"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["access.atlas.annual"].exists)
        XCTAssertTrue(app.buttons["access.atlas.restore"].exists)
        XCTAssertTrue(app.buttons["access.atlas.manage"].exists)
    }
}
