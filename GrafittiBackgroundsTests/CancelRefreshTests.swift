@testable import Grafitti_Backgrounds
import XCTest

class CancelRefreshTests: XCTestCase {
	func testCancelRefreshOnMenuClickChangesMenuAndIconState() {
        // mocks
        let viewState = LoadingStatusItemViewState(isLoading: false, loadingPercentage: 0, style: .sprayCan, alpha: 1.0)
        let statusItem = LoadingStatusItem(viewState: viewState, statusBar: .system)
        let menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
        menuController.setRefreshAction(.cancel)
        let photoController = PhotoController.testable()

        // sut
        _ = AppController.testable(menuController: menuController, photoController: photoController)

        // test
        guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.refreshFolder.rawValue) else {
            XCTFail("expected menu to click")
            return
        }
        XCTAssertEqual(menu.viewState.items[safe: AppMenu.Order.refreshFolder.rawValue]?.title, "Refresh Folder")
        XCTAssertEqual(menu.viewState.items[safe: AppMenu.Order.clearFolder.rawValue]?.isEnabled, true)
        XCTAssertEqual(statusItem.isLoading, false)
        XCTAssertEqual(statusItem.item.button?.alphaValue, 1.0)
        XCTAssertEqual(statusItem.item.button?.subviews
            .contains(where: { $0.classForCoder == NSProgressIndicator.self }), false)
        XCTAssertEqual(statusItem.item.image, statusItem.viewState.style.image)
	}

	func testCancelRefreshOnMenuClickCancelsAllNetworkOperations() {
        // mocks
        let statusItem = MockLoadingStatusItem()
        let menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
        menuController.setRefreshAction(.cancel)
        let operationQueue = MockOperationQueue()
        let networkManager = NetworkManager(urlSession: MockURLSession(), queue: operationQueue)
        let photoController = PhotoController(
            photoAlbumService: PhotoAlbumService(networkManager: networkManager),
            photoService: PhotoService(networkManager: networkManager, fileManager: MockFileManager(), saveURL: .mock),
            photoStorageService: PhotoStorageService(dataManager: MockDataManger(), fileManager: MockFileManager())
        )

        // sut
        _ = AppController.testable(menuController: menuController, photoController: photoController)

        // test
        guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.refreshFolder.rawValue) else {
            XCTFail("expected menu to click")
            return
        }
        XCTAssertTrue(operationQueue.invocations.isInvoked(MockOperationQueue.cancelAllOperations2.name))
	}
}
