@testable import Graffiti_Backgrounds
import Reachability
import XCTest

final class ReachabilityTests: XCTestCase {
    func testNetworkLossChangesIconState() {
        // mocks
        let statusItem = LoadingStatusItem(viewState: LoadingStatusItemViewState(), statusBar: NSStatusBar.system)
        let reachability = MockReachability()
        let env = AppControllerEnvironment(statusItem: statusItem, reachability: reachability)
        env.inject()

        // sut
        reachability.delegate?.reachabilityDidChange(env.reachability, isReachable: false)

        // test
        XCTAssertEqual(statusItem.item.button?.alphaValue, 0.5)
    }

    func testNetworkConnectionChangesIconState() {
        // mocks
        let statusItem = LoadingStatusItem(viewState: LoadingStatusItemViewState(), statusBar: NSStatusBar.system)
        let reachability = MockReachability()
        let env = AppControllerEnvironment(statusItem: statusItem, reachability: reachability)
        env.inject()

        // sut
        reachability.delegate?.reachabilityDidChange(env.reachability, isReachable: true)

        // test
        XCTAssertEqual(statusItem.item.button?.alphaValue, 1.0)
    }
}

// MARK: - MockReachability

private extension MockReachability {
    var delegate: ReachabilityDelegate? {
        return invocations.find(MockReachability.setDelegate1.name).first?
            .parameter(for: MockReachability.setDelegate1.params.delegate) as? ReachabilityDelegate
    }
}
