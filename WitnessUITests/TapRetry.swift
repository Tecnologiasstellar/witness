import XCTest

extension XCUIElement {
    /// Taps, waits for `expected`, and taps once more if it did not appear.
    ///
    /// The simulator drops a synthesized tap that lands on a frame where
    /// SwiftUI is still settling — after launch, after a tab switch, after a
    /// purchase re-renders the page under the finger. This guard was written
    /// out by hand six times, once per site that happened to lose the race,
    /// which left every site without one a latent flake: three surfaced in two
    /// days, in three different suites. Route every tap an assertion depends
    /// on through here, so a new test cannot forget it.
    ///
    /// Returns whether `expected` appeared, so callers assert on the result.
    @discardableResult
    func tap(
        until expected: XCUIElement,
        timeout: TimeInterval = 3,
        retryTimeout: TimeInterval = 5
    ) -> Bool {
        tap()
        if expected.waitForExistence(timeout: timeout) { return true }
        tap()
        return expected.waitForExistence(timeout: retryTimeout)
    }
}
