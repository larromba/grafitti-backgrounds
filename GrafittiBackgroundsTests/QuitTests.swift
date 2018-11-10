@testable import Grafitti_Backgrounds
import XCTest

class QuitTests: XCTestCase {
    func testQuitOnMenuClickQuitsApp() {
        // mocks
        let statusItem = MockLoadingStatusItem()
        let menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
        let app = MockApplication()

		// sut
        _ = AppController.testable(menuController: menuController, app: app)

        // test
        guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.quit.rawValue) else {
            XCTFail("expected menu to click")
            return
        }
        XCTAssertTrue(app.invocations.isInvoked(MockApplication.terminate3.name))
    }
}
