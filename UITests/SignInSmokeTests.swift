import XCTest

final class SignInSmokeTests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    @MainActor
    func testSigningInShowsTheBrandList() {
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

        XCTAssertTrue(app.staticTexts["Northwind Naturals"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Acme Outdoors UK"].exists)
    }
}
