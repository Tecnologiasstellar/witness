import XCTest

/// Verifies the honest community-count states against the deterministic
/// fake service: reconciled-after-witness, and fully local when no backend
/// is configured.
final class CommunityCountUITests: XCTestCase {
    func testWitnessReconcilesIntoHonestCount() throws {
        let app = XCUIApplication()
        app.launchEnvironment["WITNESS_TEST_ARCHIVE"] = UUID().uuidString
        app.launchEnvironment["WITNESS_COMMUNITY"] = "fake"
        app.launch()

        let witnessButton = app.buttons["today.witnessButton"]
        XCTAssertTrue(witnessButton.waitForExistence(timeout: 3))
        witnessButton.tap()

        // The witnessed plate shows the reconciled server count, not an
        // optimistic client increment.
        let countLine = app.staticTexts["witnessed.communityCount"]
        XCTAssertTrue(countLine.waitForExistence(timeout: 5))
        XCTAssertEqual(countLine.label, "THE FIRST WITNESS RECORDED THIS WEEK")
    }

    func testLocalOnlyBuildShowsNoCountAndKeepsPrivatePromise() throws {
        let app = XCUIApplication()
        app.launchEnvironment["WITNESS_TEST_ARCHIVE"] = UUID().uuidString
        app.launch()

        let witnessButton = app.buttons["today.witnessButton"]
        XCTAssertTrue(witnessButton.waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["ONE PRIVATE WITNESS · NO PUBLIC COUNT"].exists)
        witnessButton.tap()

        let notesTab = app.buttons["atlas.tab.notes"]
        XCTAssertTrue(notesTab.waitForExistence(timeout: 3))
        notesTab.tap()
        XCTAssertTrue(app.staticTexts["PRIVATE ON-DEVICE RECORD"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["witnessed.communityCount"].exists)
    }
}
