@testable import Grafitti_Backgrounds
import XCTest

final class QuitTests: XCTestCase {
    private class Environment: TestEnvironment {
        let statusItem = MockLoadingStatusItem()
        lazy var menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
        let app = MockApplication()
        var appController: AppController?

        func inject() {
            appController = AppController.testable(menuController: menuController, app: app)
        }
    }

    func testQuitOnMenuClickQuitsApp() {
        // mocks
        let env = Environment()
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.quit.rawValue)

        // test
        XCTAssertTrue(env.app.invocations.isInvoked(MockApplication.terminate4.name))
    }
}
