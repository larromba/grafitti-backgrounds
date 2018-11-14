@testable import Grafitti_Backgrounds
import XCTest

// TODO: env?
final class CancelRefreshTests: XCTestCase {
	func testCancelRefreshOnMenuClickChangesMenuAndIconState() {
        // mocks
        let viewState = LoadingStatusItemViewState(isLoading: false, loadingPercentage: 0, style: .sprayCan, alpha: 1.0)
        let statusItem = LoadingStatusItem(viewState: viewState, statusBar: NSStatusBar.system)
        let menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
        menuController.setRefreshAction(.cancel)
        let photoController = PhotoController.testable()
        _ = AppController.testable(menuController: menuController, photoController: photoController)

        // sut
        statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        XCTAssertEqual(statusItem.menu?.viewState.items[safe: AppMenu.Order.refreshFolder.rawValue]?.title, "Refresh Folder")
        XCTAssertEqual(statusItem.menu?.viewState.items[safe: AppMenu.Order.clearFolder.rawValue]?.isEnabled, true)
        XCTAssertEqual(statusItem.viewState.isLoading, false)
        XCTAssertEqual(statusItem.item.button?.alphaValue, 1.0)
        XCTAssertEqual(statusItem.item.button?.subviews
            .contains(where: { $0.classForCoder == NSProgressIndicator.self }), false)
        XCTAssertEqual(statusItem.item.image, statusItem.viewState.style.image)
	}

	func testCancelRefreshOnMenuClickCancelsAllNetworkOperations() {
        // mocks
        let viewState = LoadingStatusItemViewState(isLoading: false, loadingPercentage: 0, style: .sprayCan, alpha: 1.0)
        let statusItem = LoadingStatusItem(viewState: viewState, statusBar: NSStatusBar.system)
        let menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
        menuController.setRefreshAction(.cancel)
        let operationQueue = MockOperationQueue()
        let networkManager = NetworkManager(urlSession: MockURLSession(), queue: operationQueue)
        let photoController = PhotoController.testable(
            photoAlbumService: PhotoAlbumService(networkManager: networkManager),
            photoService: PhotoService(networkManager: networkManager, fileManager: MockFileManager()),
            photoStorageService: PhotoStorageService(dataManager: MockDataManger(), fileManager: MockFileManager())
        )
        _ = AppController.testable(menuController: menuController, photoController: photoController)

        // sut
        statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        XCTAssertTrue(operationQueue.invocations.isInvoked(MockOperationQueue.cancelAllOperations2.name))
	}

    func testCancelRefreshDoesNotDisplayErrorAlert() {
        XCTFail("todo")
    }

    func testCancelRefreshDisplaysAlert() {
        XCTFail("todo")
    }
}
