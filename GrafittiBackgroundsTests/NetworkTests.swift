@testable import Grafitti_Backgrounds
import XCTest

class NetworkTests: XCTestCase {
    func testNetworkLossAndConnectionChangesIconState() {
        // mocks
        let viewState = LoadingStatusItemViewState(isLoading: false, loadingPercentage: 0, style: .sprayCan, alpha: 1.0)
        let statusItem = LoadingStatusItem(viewState: viewState, statusBar: .system)
        let reachability = MockReachability()
        let menuController = AppMenuController(statusItem: statusItem, reachability: reachability)

        // sut
        _ = AppController.testable(menuController: menuController)

        // test
        menuController.reachabilityDidChange(reachability, isReachable: false)
        XCTAssertEqual(statusItem.item.button?.alphaValue, 0.5)

        menuController.reachabilityDidChange(reachability, isReachable: true)
        XCTAssertEqual(statusItem.item.button?.alphaValue, 1.0)
    }
}
