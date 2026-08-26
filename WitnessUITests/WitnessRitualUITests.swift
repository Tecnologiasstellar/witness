import XCTest

final class WitnessRitualUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchEnvironment["WITNESS_TEST_ARCHIVE"] = UUID().uuidString
        app.launch()
    }

    func testDurableLocalRitualAndSharePreview() throws {
        let witnessButton = app.buttons["today.witnessButton"]
        XCTAssertTrue(witnessButton.waitForExistence(timeout: 3))
        // The plate animates in after launch; tapping against a stale frame
        // can land on the specimen area instead of the Witness button. Wait
        // for hittability plus a short settle before the first tap.
        _ = witnessButton.isHittable
        Thread.sleep(forTimeInterval: 1.0)
        witnessButton.tap()
        // A completed Witness transitions to the private Notes plate.
        if !app.staticTexts["PRIVATE ON-DEVICE RECORD"].waitForExistence(timeout: 4),
           witnessButton.exists, witnessButton.isEnabled {
            witnessButton.tap()
        }
        XCTAssertTrue(app.staticTexts["PRIVATE ON-DEVICE RECORD"].waitForExistence(timeout: 5))

        app.terminate()
        app.launch()
        // The archive restores asynchronously after launch; wait for the
        // witnessed (disabled) state instead of sampling immediately.
        let restored = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "isEnabled == false"),
            object: app.buttons["today.witnessButton"]
        )
        XCTAssertEqual(XCTWaiter().wait(for: [restored], timeout: 10), .completed)

        app.buttons["atlas.tab.notes"].tap()
        let leaveNote = app.buttons["LEAVE A NOTE"]
        XCTAssertTrue(leaveNote.waitForExistence(timeout: 3))
        leaveNote.tap()

        let reflection = app.textViews["witnessed.reflectionEditor"]
        XCTAssertTrue(reflection.waitForExistence(timeout: 3))
        reflection.tap()
        let reflectionText = "I want to remember the silence between breaths."
        reflection.typeText(reflectionText)
        app.buttons["witnessed.saveReflectionButton"].tap()

        let sharePreview = app.buttons["witnessed.sharePreviewButton"]
        XCTAssertTrue(sharePreview.waitForExistence(timeout: 3))
        sharePreview.tap()
        XCTAssertTrue(app.navigationBars["SHARE PLATE"].waitForExistence(timeout: 5))
        let exportButton = app.buttons["share.exportButton"]
        XCTAssertTrue(exportButton.waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts[reflectionText].exists)
    }

    func testTodayPassesSystemAccessibilityAudit() throws {
        try app.performAccessibilityAudit()
    }
}
