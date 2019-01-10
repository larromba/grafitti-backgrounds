@testable import Graffiti_Backgrounds
import Networking
import Reachability
import XCTest

final class CancelRefreshTests: XCTestCase {
    private var statusItem: LoadingStatusItem!
    private var env: AppTestEnvironment!

    override func setUp() {
        super.setUp()
        statusItem = LoadingStatusItem(viewState: LoadingStatusItemViewState(), statusBar: NSStatusBar.system)
        env = AppTestEnvironment(statusItem: statusItem)
    }

    override func tearDown() {
        statusItem = nil
        env = nil
        super.tearDown()
    }

    func testCancelRefreshOnMenuClickChangesMenuAndIconState() {
        // mocks
        env.inject()
        setCancelAction()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        let menuViewState = env.statusItem.menu?.viewState
        XCTAssertEqual(menuViewState?.items[safe: AppMenu.Order.refreshFolder.rawValue]?.title, "Refresh Folder")
        XCTAssertEqual(menuViewState?.items[safe: AppMenu.Order.clearFolder.rawValue]?.isEnabled, true)
        XCTAssertEqual(statusItem.viewState.isLoading, false)
        XCTAssertEqual(statusItem.item.button?.alphaValue, 1.0)
        XCTAssertEqual(statusItem.item.button?.subviews
            .contains(where: { $0.classForCoder == NSProgressIndicator.self }), false)
        XCTAssertEqual(statusItem.item.image, env.statusItem.viewState.image)
    }

    func testCancelRefreshOnMenuClickCancelsAllNetworkOperations() {
        // mocks
        let operationQueue = MockOperationQueue()
        env.networkManager = NetworkManager(urlSession: MockURLSession(), fileManager: Networking.MockFileManager(),
                                            queue: operationQueue)
        env.inject()
        setCancelAction()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        XCTAssertTrue(operationQueue.invocations.isInvoked(MockOperationQueue.cancelAllOperations2.name))
    }

    func testCancelRefreshDisplaysNotificationAlert() {
        // mocks
        let notificationCenter = MockUserNotificationCenter()
        env.notificationCenter = notificationCenter
        env.inject()
        setCancelAction()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        let invocations = notificationCenter.invocations.find(MockUserNotificationCenter.deliver1.name)
        let notification = invocations.first?
            .parameter(for: MockUserNotificationCenter.deliver1.params.notification) as? NSUserNotification
        XCTAssertEqual(notification?.title, "")
        XCTAssertEqual(notification?.informativeText, "Your reload was cancelled")
        XCTAssertEqual(invocations.count, 1)
    }

    // MARK: - private

    private func setCancelAction() {
        env.menuController.setRefreshAction(.cancel)
    }
}
