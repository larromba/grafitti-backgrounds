@testable import Grafitti_Backgrounds
import XCTest

final class AboutTests: XCTestCase {
    private class Environment: TestEnvironment {
        let statusItem = MockLoadingStatusItem()
        lazy var menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
        let app = MockApplication()
        var appController: AppController?

        func inject() {
            appController = AppController.testable(menuController: menuController, app: app)
        }
    }

	func testAboutOnMenuClickOpensAbout() {
		// mocks
        let env = Environment()
        env.inject()

        // sut
		env.statusItem.menu?.click(at: AppMenu.Order.about.rawValue)

        // test
		XCTAssertTrue(env.app.invocations.isInvoked(MockApplication.orderFrontStandardAboutPanel1.name))
	}
}
