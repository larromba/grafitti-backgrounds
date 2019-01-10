@testable import Graffiti_Backgrounds
import Reachability
import XCTest

final class EmailTests: XCTestCase {
    func testReportBugOnMenuClickOpensEmail() {
        // mocks
        let sharingService = MockSharingService()
        sharingService.actions.set(returnValue: true, for: MockSharingService.canPerform1.name)
        let env = AppTestEnvironment(sharingService: sharingService)
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.contact.rawValue)

        // test
        XCTAssertTrue(sharingService.invocations.isInvoked(MockSharingService.perform2.name))
    }
}
