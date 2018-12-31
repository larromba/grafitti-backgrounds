@testable import Graffiti_Backgrounds
import Reachability
import XCTest

final class QuitTests: XCTestCase {
    func testQuitOnMenuClickQuitsApp() {
        // mocks
        let app = MockApplication()
        let env = AppControllerEnvironment(app: app)
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.quit.rawValue)

        // test
        XCTAssertTrue(app.invocations.isInvoked(MockApplication.terminate4.name))
    }
}
