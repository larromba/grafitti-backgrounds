@testable import Graffiti_Backgrounds
import Reachability
import XCTest

final class AboutTests: XCTestCase {
    private var application: MockApplication!
    private var env: AppTestEnvironment!

    override func setUp() {
        super.setUp()
        application = MockApplication()
        env = AppTestEnvironment(application: application)
    }

    override func tearDown() {
        application = nil
        env = nil
        super.tearDown()
    }

    func test_menu_whenAboutClicked_expectOpensAbout() {
        // mocks
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.about.rawValue)

        // test
        XCTAssertTrue(application.invocations.isInvoked(MockApplication.orderFrontStandardAboutPanel2.name))
    }

    func test_menu_whenClicked_expectBroughtToFront() {
        // mocks
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.preferences.rawValue)

        // test
        XCTAssertTrue(application.invocations.isInvoked(MockApplication.activate1.name))
    }
}
