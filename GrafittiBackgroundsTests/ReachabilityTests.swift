@testable import Grafitti_Backgrounds
import XCTest

final class ReachabilityTests: XCTestCase {
    private class IconStateNetworkConnectionEnvironment {
        let viewState = LoadingStatusItemViewState(isLoading: false, loadingPercentage: 0, style: .sprayCan, alpha: 1.0)
        lazy var statusItem = LoadingStatusItem(viewState: viewState, statusBar: NSStatusBar.system)
        let reachability = MockReachability()
        lazy var menuController = AppMenuController(statusItem: statusItem, reachability: reachability)
        var delegate: ReachabilityDelegate? {
            return reachability.invocations.find(
                parameter: MockReachability.setDelegate1.params.delegate,
                inFunction: MockReachability.setDelegate1.name
            ) as? ReachabilityDelegate
        }

        init() {
            _ = AppController.testable(menuController: menuController)
        }
    }

    func testNetworkLossChangesIconState() {
        // mocks
        let env = IconStateNetworkConnectionEnvironment()

        // sut
        env.delegate?.reachabilityDidChange(env.reachability, isReachable: false)

        // test
        XCTAssertEqual(env.statusItem.item.button?.alphaValue, 0.5)
    }

    func testNetworkConnectionChangesIconState() {
        // mocks
        let env = IconStateNetworkConnectionEnvironment()

        // sut
        env.delegate?.reachabilityDidChange(env.reachability, isReachable: true)

        // test
        XCTAssertEqual(env.statusItem.item.button?.alphaValue, 1.0)
    }
}
