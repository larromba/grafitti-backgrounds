@testable import Graffiti_Backgrounds
import Reachability
import XCTest

final class AboutTests: XCTestCase {
    private var app: MockApplication!
    private var env: AppTestEnvironment!

    override func setUp() {
        super.setUp()
        app = MockApplication()
        env = AppTestEnvironment(app: app)
    }

    override func tearDown() {
        app = nil
        env = nil
        super.tearDown()
    }

    func testAboutOnMenuClickOpensAbout() {
        // mocks
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.about.rawValue)

        // test
        XCTAssertTrue(app.invocations.isInvoked(MockApplication.orderFrontStandardAboutPanel2.name))
    }

    func testAboutOnMenuClickIsBoughtToFront() {
        // mocks
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.preferences.rawValue)

        // test
        XCTAssertTrue(app.invocations.isInvoked(MockApplication.activate1.name))
    }
}
