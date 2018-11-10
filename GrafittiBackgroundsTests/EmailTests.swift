@testable import Grafitti_Backgrounds
import XCTest

class EmailTests: XCTestCase {
    func testReportBugOnMenuClickOpensEmail() {
        // mocks
        let statusItem = MockLoadingStatusItem()
        let menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
        let sharingService = MockSharingService()
        sharingService.actions.set(returnValue: true, for: MockSharingService.canPerform1.name)
        let emailController = EmailController(sharingService: sharingService)

        // sut
        _ = AppController.testable(menuController: menuController, emailController: emailController)

        // test
        guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.contact.rawValue) else {
            XCTFail("expected menu to click")
            return
        }
        XCTAssertTrue(sharingService.invocations.isInvoked(MockSharingService.perform2.name))
    }
}
