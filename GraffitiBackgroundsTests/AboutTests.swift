@testable import Graffiti_Backgrounds
import Reachability
import XCTest

final class AboutTests: XCTestCase {
    func testAboutOnMenuClickOpensAbout() {
        // mocks
        let app = MockApplication()
        let env = AppControllerEnvironment(app: app)
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.about.rawValue)

        // test
        XCTAssertTrue(app.invocations.isInvoked(MockApplication.orderFrontStandardAboutPanel2.name))
    }

    func testAboutOnMenuClickIsBoughtToFront() {
        // mocks
        let app = MockApplication()
        let env = AppControllerEnvironment(app: app)
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.preferences.rawValue)

        // test
        XCTAssertTrue(app.invocations.isInvoked(MockApplication.activate1.name))
    }
}
