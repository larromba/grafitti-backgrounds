@testable import Grafitti_Backgrounds
import XCTest

final class EmailTests: XCTestCase {
    func testReportBugOnMenuClickOpensEmail() {
        // mocks
        let statusItem = MockLoadingStatusItem()
        let menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
        let sharingService = MockSharingService()
        sharingService.actions.set(returnValue: true, for: MockSharingService.canPerform1.name)
        let emailController = EmailController(sharingService: sharingService)
        _ = AppController.testable(menuController: menuController, emailController: emailController)

        // sut
        statusItem.menu?.click(at: AppMenu.Order.contact.rawValue)

        // test
        XCTAssertTrue(sharingService.invocations.isInvoked(MockSharingService.perform2.name))
    }
}
