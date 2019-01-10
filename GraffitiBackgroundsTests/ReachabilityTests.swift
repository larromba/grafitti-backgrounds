@testable import Graffiti_Backgrounds
import Reachability
import XCTest

final class ReachabilityTests: XCTestCase {
    private var statusItem: LoadingStatusItem!
    private var reachability: MockReachability!
    private var env: AppTestEnvironment!

    override func setUp() {
        super.setUp()
        statusItem = LoadingStatusItem(viewState: LoadingStatusItemViewState(), statusBar: NSStatusBar.system)
        reachability = MockReachability()
        env = AppTestEnvironment(statusItem: statusItem, reachability: reachability)
        env.inject()
    }

    override func tearDown() {
        statusItem = nil
        reachability = nil
        env = nil
        super.tearDown()
    }

    func testNetworkLossChangesIconState() {
        // sut
        reachability.delegate?.reachabilityDidChange(env.reachability, isReachable: false)

        // test
        XCTAssertEqual(statusItem.item.button?.alphaValue, 0.5)
    }

    func testNetworkConnectionChangesIconState() {
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
