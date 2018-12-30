@testable import Graffiti_Backgrounds
import Reachability
import XCTest

final class ReachabilityTests: XCTestCase {
    private class Environment: TestEnvironment {
        lazy var statusItem = LoadingStatusItem(viewState: LoadingStatusItemViewState(), statusBar: NSStatusBar.system)
        let reachability = MockReachability()
        lazy var menuController = AppMenuController(statusItem: statusItem, reachability: reachability)
        var delegate: ReachabilityDelegate? {
            return reachability.invocations.find(MockReachability.setDelegate1.name).first?
                .parameter(for: MockReachability.setDelegate1.params.delegate) as? ReachabilityDelegate
        }
        var appController: AppController?

        func inject() {
            appController = AppController.testable(menuController: menuController)
        }
    }

    func testNetworkLossChangesIconState() {
        // mocks
        let env = Environment()
        env.inject()

        // sut
        env.delegate?.reachabilityDidChange(env.reachability, isReachable: false)

        // test
        XCTAssertEqual(env.statusItem.item.button?.alphaValue, 0.5)
    }

    func testNetworkConnectionChangesIconState() {
        // mocks
        let env = Environment()
        env.inject()

        // sut
        env.delegate?.reachabilityDidChange(env.reachability, isReachable: true)

        // test
        XCTAssertEqual(env.statusItem.item.button?.alphaValue, 1.0)
    }
}
