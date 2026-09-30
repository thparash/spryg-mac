import XCTest

final class BrandSwitcherSmokeTests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testSwitchingBrandChangesTheWindowTitle() {
        let app = XCUIApplication()
        app.launchArguments = ["-SprygUseFixtures", "YES"]
        app.launch()

        let email = app.textFields["signIn.email"]
        XCTAssertTrue(email.waitForExistence(timeout: 10))
        email.click()
        email.typeText("pat@example.com")
        let password = app.secureTextFields["signIn.password"]
        password.click()
        password.typeText("correct horse")
        app.buttons["signIn.submit"].click()

        let window = app.windows.firstMatch
        XCTAssertTrue(window.wait(for: \.title, toEqual: "Acme Outdoors UK", timeout: 10))

        app.typeKey("k", modifierFlags: .command)
        let search = app.textFields["brandSwitcher.search"]
        XCTAssertTrue(search.waitForExistence(timeout: 5))
        search.typeText("north")
        app.sheets.buttons["Northwind Naturals"].click()

        XCTAssertTrue(window.wait(for: \.title, toEqual: "Northwind Naturals", timeout: 5))
    }
}
