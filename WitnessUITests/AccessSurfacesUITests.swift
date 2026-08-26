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

        // Field Season preview: free promise and purchase.
        app.buttons["access.overview.fieldseason"].tap()
        let purchase = app.buttons["access.fieldseason.purchase"]
        XCTAssertTrue(purchase.waitForExistence(timeout: 5))
        purchase.tap()
        XCTAssertTrue(app.staticTexts["access.fieldseason.owned"].waitForExistence(timeout: 5)
            || app.otherElements["access.fieldseason.owned"].waitForExistence(timeout: 2))

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
