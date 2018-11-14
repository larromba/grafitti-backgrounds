@testable import Grafitti_Backgrounds
import XCTest

final class AboutTests: XCTestCase {
	func testAboutOnMenuClickOpensAbout() {
		// mocks
		let statusItem = MockLoadingStatusItem()
		let menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
		let app = MockApplication()
		_ = AppController.testable(menuController: menuController, app: app)

        // sut
		statusItem.menu?.click(at: AppMenu.Order.about.rawValue)

        // test
		XCTAssertTrue(app.invocations.isInvoked(MockApplication.orderFrontStandardAboutPanel1.name))
	}
}
