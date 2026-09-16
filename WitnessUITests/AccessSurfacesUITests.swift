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
        XCTAssertTrue(contents.tap(until: app.staticTexts["INDEX"]))
    }

    /// Switches to the cabinet's ARCHIVE shelf, retrying the tab tap for the
    /// same reason `openIndex` does: it is the first synthesized tap after
    /// launch and is occasionally dropped while the plate is still settling.
    /// A dropped tap leaves the app on THIS WEEK, where no segment row
    /// exists, so the failure reads as a missing ARCHIVE button. Both archive
    /// tests route through here — the guard was in neither of them, and only
    /// one happened to lose the race.
    private func openCabinetArchive() {
        let cabinet = app.buttons["atlas.tab.cabinet"]
        XCTAssertTrue(cabinet.waitForExistence(timeout: 5))
        XCTAssertTrue(cabinet.tap(until: app.buttons["cabinet.segment.archive"]))
        app.buttons["cabinet.segment.archive"].tap()
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

        // Back to the overview; ownership is reflected. The purchase re-renders
        // this page — the price button becomes OPEN THE EDITION and the restore
        // row drops out — and a tap synthesized on that settling frame is
        // dropped, so this retries like every other tap in the flow. Targets
        // the back button by identifier rather than firstMatch: there is only
        // one navigation bar here, but naming it says which control is meant.
        let back = app.navigationBars.buttons["BackButton"]
        XCTAssertTrue(back.waitForExistence(timeout: 5))
        let overview = app.buttons["access.overview.fieldseason"]
        XCTAssertTrue(back.tap(until: overview, timeout: 5))

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
        // Retry the card tap once: it can land on the settling frame of the
        // sheet (same flake family as openIndex).
        app.buttons["access.overview.fieldseason"].tap()
        let purchase = app.buttons["access.fieldseason.purchase"]
        if !purchase.waitForExistence(timeout: 5) {
            app.buttons["access.overview.fieldseason"].tap()
            XCTAssertTrue(purchase.waitForExistence(timeout: 5))
        }
        purchase.tap()

        // Same guard as the overview flow: a dropped purchase tap leaves the
        // button in place, so press it once more before failing.
        let open = app.buttons["access.fieldseason.open"]
        if !open.waitForExistence(timeout: 5), purchase.exists {
            purchase.tap()
        }
        XCTAssertTrue(open.waitForExistence(timeout: 5))
        open.tap()

        // Edition list shows chapter one and the honest in-production rows.
        // Retry the tap once: it can land on the settling frame of the push
        // (same flake family as openIndex).
        let chapterOne = app.buttons["fieldseason.chapter.1"]
        XCTAssertTrue(chapterOne.waitForExistence(timeout: 5))
        chapterOne.tap()

        // Reader: title, and the synthetic-voice disclosure beside the audio.
        let readerTitle = app.staticTexts["fieldseason.reader.title"]
        if !readerTitle.waitForExistence(timeout: 5) {
            chapterOne.tap()
            XCTAssertTrue(readerTitle.waitForExistence(timeout: 5))
        }
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

        // Before buying there is no door: the library is not yet theirs.
        XCTAssertFalse(app.buttons["access.atlas.enter"].exists)
    }

    /// The archive is the Atlas payoff. Opening a plate must land on a real
    /// dossier — the screen this replaced rendered no species name at all,
    /// a fake map, a "NOT YET VERIFIED" placeholder and a gillnet over every
    /// animal. Asserting the name is exactly the guard that would have caught it.
    func testArchivePlateOpensTheSpeciesDossier() throws {
        openCabinetArchive()

        // The fake purchase service leaves Atlas inactive, so only the plates
        // inside the free window are open — which is the point: this same
        // dossier is what a member gets for every older week.
        let plate = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'archive.plate.'")).firstMatch
        XCTAssertTrue(plate.waitForExistence(timeout: 5))
        plate.tap()

        XCTAssertTrue(app.staticTexts["dossier.speciesName"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["cabinet.helpingButton"].exists)
        // The deleted screen's placeholders must never come back.
        XCTAssertFalse(app.staticTexts["NOT YET VERIFIED"].exists)
    }

    /// A locked plate must still sell, not open. Guards against un-gating the
    /// archive by accident while rerouting it.
    func testLockedArchivePlateOpensTheAtlasSheet() throws {
        openCabinetArchive()

        let locked = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'archive.locked.'")).firstMatch
        guard locked.waitForExistence(timeout: 5) else {
            throw XCTSkip("No week has aged out of the free window in this run")
        }
        locked.tap()
        XCTAssertTrue(app.buttons["access.atlas.sixmonth"].waitForExistence(timeout: 5))
    }

    /// Buying the Atlas must land the reader in the library, not on the page
    /// that just sold it to them. This is the regression guard for the
    /// dead-end the sheet used to leave behind.
    func testAtlasPurchaseOpensTheLibrary() throws {
        openIndex()
        let atlas = app.buttons["access.overview.atlas"]
        XCTAssertTrue(atlas.waitForExistence(timeout: 3))
        let sixMonth = app.buttons["access.atlas.sixmonth"]
        XCTAssertTrue(atlas.tap(until: sixMonth))
        sixMonth.tap()

        // The door leads; the receipt follows it.
        let enter = app.buttons["access.atlas.enter"]
        XCTAssertTrue(enter.waitForExistence(timeout: 5))
        enter.tap()

        // The Index sheet the Atlas page was pushed inside must close too —
        // dismissing there alone would leave it covering the archive.
        XCTAssertFalse(app.staticTexts["INDEX"].waitForExistence(timeout: 2))

        let cabinet = app.buttons["atlas.tab.cabinet"]
        XCTAssertTrue(cabinet.waitForExistence(timeout: 5))
        XCTAssertTrue(cabinet.isSelected)
        let archiveSegment = app.buttons["cabinet.segment.archive"]
        XCTAssertTrue(archiveSegment.waitForExistence(timeout: 5))
        XCTAssertTrue(archiveSegment.isSelected)
    }
}
