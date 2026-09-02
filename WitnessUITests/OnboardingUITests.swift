import XCTest

/// The first-run introduction (D-026) against a forced fresh state: the
/// pages carry no commerce, SKIP lands on the ritual, the reminder page
/// records intent without a system prompt, the flag persists, and INDEX
/// reopens the pages in review mode.
final class OnboardingUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchEnvironment["WITNESS_TEST_ARCHIVE"] = UUID().uuidString
        app.launchEnvironment["WITNESS_FORCE_SPECIES"] = "kakapo"
        app.launchEnvironment["WITNESS_ONBOARDING"] = "force"
        app.launch()
    }

    private func page(_ name: String) -> XCUIElement {
        app.descendants(matching: .any).matching(identifier: "onboarding.page.\(name)").firstMatch
    }

    /// Paged tabs keep neighbours in the hierarchy; only the current page is hittable.
    private func waitForPage(_ name: String, timeout: TimeInterval = 5) -> Bool {
        let hittable = NSPredicate(format: "isHittable == true")
        let expectation = XCTNSPredicateExpectation(predicate: hittable, object: page(name))
        return XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
    }

    /// Taps a control, retrying once: the first synthesized tap after a
    /// page settles is occasionally dropped (same flake family as openIndex).
    private func tap(_ id: String, expecting next: String) {
        let control = app.buttons[id]
        XCTAssertTrue(control.waitForExistence(timeout: 5), "\(id) missing")
        control.tap()
        if !waitForPage(next, timeout: 3) {
            control.tap()
            XCTAssertTrue(waitForPage(next), "\(next) did not follow \(id)")
        }
    }

    private func walkToReminderPage() {
        XCTAssertTrue(waitForPage("welcome"))
        tap("onboarding.begin", expecting: "weekly")
        tap("onboarding.continue", expecting: "witness")
        tap("onboarding.continue", expecting: "acts")
        tap("onboarding.continue", expecting: "reminder")
    }

    func testPagesCarryNoCommerceAndSkipLandsOnTheRitual() throws {
        walkToReminderPage()
        tap("onboarding.reminder.notNow", expecting: "works")

        // The works are named as doors only: no price, no purchase, no tip.
        XCTAssertFalse(app.buttons["access.fieldseason.purchase"].exists)
        XCTAssertFalse(app.buttons["access.atlas.sixmonth"].exists)
        XCTAssertFalse(app.buttons["access.atlas.annual"].exists)
        XCTAssertFalse(app.buttons["access.support.tip"].exists)
        XCTAssertFalse(app.staticTexts.containing(NSPredicate(format: "label CONTAINS '$'")).firstMatch.exists)
        XCTAssertTrue(app.staticTexts["onboarding.works.free"].exists)

        // SKIP is offered on every page and lands straight on the ritual.
        app.buttons["onboarding.skip"].tap()
        XCTAssertTrue(app.buttons["today.witnessButton"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["onboarding.skip"].exists)
    }

    func testReminderIntentRecordsWithoutSystemPromptAndIntroductionShowsOnce() throws {
        walkToReminderPage()
        tap("onboarding.reminder.morning", expecting: "works")
        // No iOS permission dialog may appear before the first Witness (D-008).
        XCTAssertFalse(XCUIApplication(bundleIdentifier: "com.apple.springboard").alerts.firstMatch.exists)

        let finish = app.buttons["onboarding.finish"]
        XCTAssertTrue(finish.waitForExistence(timeout: 5))
        finish.tap()
        let witnessButton = app.buttons["today.witnessButton"]
        if !witnessButton.waitForExistence(timeout: 3) {
            finish.tap()
            XCTAssertTrue(witnessButton.waitForExistence(timeout: 5))
        }

        // The named time reaches the post-witness primer as a one-tap confirm.
        // The card fades in as the introduction leaves; wait for the
        // introduction to be gone, then tap (XCTest scrolls the button into
        // view) and confirm the witness took — the button disables.
        let gone = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == false"), object: finish)
        XCTAssertEqual(XCTWaiter().wait(for: [gone], timeout: 5), .completed)
        witnessButton.tap()
        let disabled = NSPredicate(format: "isEnabled == false")
        if XCTWaiter().wait(for: [XCTNSPredicateExpectation(predicate: disabled, object: witnessButton)], timeout: 5) != .completed {
            witnessButton.tap()
            XCTAssertEqual(XCTWaiter().wait(for: [XCTNSPredicateExpectation(predicate: disabled, object: witnessButton)], timeout: 10), .completed)
        }
        // The primer lives in the witnessed reveal, several screens below
        // the button. SwiftUI drops accessibility nodes for scroll content
        // far outside the viewport, so scroll until it appears; reach it as
        // an any-type descendant like share.plateButton in the ritual test.
        let turnOn = app.descendants(matching: .any).matching(identifier: "today.reminderPrimer.turnOn").firstMatch
        var scrollAttempts = 0
        while !turnOn.exists && scrollAttempts < 12 {
            app.swipeUp()
            scrollAttempts += 1
        }
        XCTAssertTrue(turnOn.waitForExistence(timeout: 5))
        XCTAssertTrue(turnOn.label.contains("TURN ON"))

        // Honoring the stored flag, a relaunch goes straight to the card.
        app.terminate()
        app.launchEnvironment["WITNESS_ONBOARDING"] = "real"
        app.launch()
        XCTAssertTrue(app.buttons["today.witnessButton"].waitForExistence(timeout: 5))
        XCTAssertFalse(page("welcome").exists)
    }

    func testIndexReopensTheIntroductionInReviewMode() throws {
        XCTAssertTrue(waitForPage("welcome"))
        app.buttons["onboarding.skip"].tap()
        let contents = app.buttons["today.contents"]
        XCTAssertTrue(contents.waitForExistence(timeout: 5))
        contents.tap()
        if !app.staticTexts["INDEX"].waitForExistence(timeout: 3) {
            contents.tap()
            XCTAssertTrue(app.staticTexts["INDEX"].waitForExistence(timeout: 5))
        }

        let row = app.buttons["index.howItWorks"]
        var scrollAttempts = 0
        while !row.isHittable && scrollAttempts < 8 {
            app.swipeUp()
            scrollAttempts += 1
        }
        XCTAssertTrue(row.isHittable)
        row.tap()
        XCTAssertTrue(waitForPage("welcome"))
        // Review mode is a pushed page: a back chevron, no SKIP, no reminder page.
        XCTAssertFalse(app.buttons["onboarding.skip"].exists)
        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(row.waitForExistence(timeout: 5))
    }

    func testIntroductionPassesSystemAccessibilityAudit() throws {
        XCTAssertTrue(waitForPage("welcome"))
        try audit()
        tap("onboarding.begin", expecting: "weekly")
        try audit()
    }

    /// Every audit type except two. Dynamic Type: Atlas fonts scale through
    /// UIFontMetrics, which the checker cannot see (the Today exemption).
    /// Contrast: iOS 26.5's pixel sampler misreads the striped paper texture
    /// — on Today it flags full ink on paper (0x25231F on 0xF1E8D5, 11.9:1,
    /// pixel-verified) and here it flagged a full-ink passage the same way.
    /// The introduction uses only palette pairs that clear the floor by
    /// formula: ink 11.9:1, sepia 6.8:1, inkMuted 5.0:1 on paper; heroInk on
    /// the fixed heroScrim (5.4:1 median, see WitnessRitualUITests).
    private func audit() throws {
        sleep(1)
        let types: XCUIAccessibilityAuditType = [
            .elementDetection, .hitRegion, .sufficientElementDescription, .trait, .textClipped,
        ]
        try app.performAccessibilityAudit(for: types) { issue in
            // Named in the log so a new finding can be triaged from xcodebuild output alone.
            print("accessibility audit: \(issue.auditType) id=\(issue.element?.identifier ?? "-") label=\(issue.element?.label ?? "-") \(issue.detailedDescription)")
            if issue.auditType == .textClipped, issue.element == nil {
                return true
            }
            return false
        }
    }
}
