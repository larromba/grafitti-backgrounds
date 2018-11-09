@testable import Grafitti_Backgrounds
import XCTest

class AboutTests: XCTestCase {
	func testAboutOpensOnMenuClick() {
		// mocks
		let statusItem = MockLoadingStatusItem()
		let menuController = AppMenuController(statusItem: statusItem)
		let app = MockApplication()

		// sut
		_ = AppController.testable(menuController: menuController, app: app)

		// test
		guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.about.rawValue) else {
			XCTFail("expected menu to click")
			return
		}
		XCTAssertTrue(app.invocations.isInvoked(MockApplication.orderFrontStandardAboutPanel1.name))
	}
}
