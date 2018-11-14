@testable import Grafitti_Backgrounds
import XCTest

final class QuitTests: XCTestCase {
    func testQuitOnMenuClickQuitsApp() {
        // mocks
        let statusItem = MockLoadingStatusItem()
        let menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
        let app = MockApplication()
        _ = AppController.testable(menuController: menuController, app: app)

        // sut
        statusItem.menu?.click(at: AppMenu.Order.quit.rawValue)

        // test
        XCTAssertTrue(app.invocations.isInvoked(MockApplication.terminate3.name))
    }
}
