@testable import Grafitti_Backgrounds
import XCTest

final class EmailTests: XCTestCase {
    private class Environment: TestEnvironment {
        let statusItem = MockLoadingStatusItem()
        lazy var menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
        let sharingService = MockSharingService()
        lazy var emailController = EmailController(sharingService: sharingService)
        var appController: AppController?

        func inject() {
            appController = AppController.testable(menuController: menuController, emailController: emailController)
        }
    }

    func testReportBugOnMenuClickOpensEmail() {
        // mocks
        let env = Environment()
        env.sharingService.actions.set(returnValue: true, for: MockSharingService.canPerform1.name)
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.contact.rawValue)

        // test
        XCTAssertTrue(env.sharingService.invocations.isInvoked(MockSharingService.perform2.name))
    }
}
