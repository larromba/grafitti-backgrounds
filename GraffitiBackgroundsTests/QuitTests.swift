@testable import Graffiti_Backgrounds
import Reachability
import XCTest

final class QuitTests: XCTestCase {
    func test_menu_whenQuitClicked_expectAppTerminates() {
        // mocks
        let application = MockApplication()
        let env = AppTestEnvironment(application: application)
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.quit.rawValue)

        // test
        XCTAssertTrue(application.invocations.isInvoked(MockApplication.terminate4.name))
    }
}
