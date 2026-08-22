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
        witnessButton.tap()
        XCTAssertTrue(app.buttons["today.witnessButton"].waitForExistence(timeout: 3))

        app.terminate()
        app.launch()
        XCTAssertFalse(app.buttons["today.witnessButton"].isEnabled)

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
