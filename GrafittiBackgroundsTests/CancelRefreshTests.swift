@testable import Grafitti_Backgrounds
import XCTest

final class CancelRefreshTests: XCTestCase {
    private class Environment: TestEnvironment {
        let viewState = LoadingStatusItemViewState(isLoading: false, loadingPercentage: 0, style: .sprayCan, alpha: 1.0)
        lazy var statusItem = LoadingStatusItem(viewState: viewState, statusBar: NSStatusBar.system)
        lazy var menuController: AppMenuController = {
            let controller = AppMenuController(statusItem: statusItem, reachability: MockReachability())
            controller.setRefreshAction(.cancel)
            return controller
        }()
        let photoController: PhotoControllable
        var appController: AppController?

        init(photoController: PhotoControllable = PhotoController.testable()) {
            self.photoController = photoController
        }

        func inject() {
            appController = AppController.testable(menuController: menuController, photoController: photoController)
        }
    }

	func testCancelRefreshOnMenuClickChangesMenuAndIconState() {
        // mocks
        let env = Environment()
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        let menuViewState = env.statusItem.menu?.viewState
        XCTAssertEqual(menuViewState?.items[safe: AppMenu.Order.refreshFolder.rawValue]?.title, "Refresh Folder")
        XCTAssertEqual(menuViewState?.items[safe: AppMenu.Order.clearFolder.rawValue]?.isEnabled, true)
        XCTAssertEqual(env.statusItem.viewState.isLoading, false)
        XCTAssertEqual(env.statusItem.item.button?.alphaValue, 1.0)
        XCTAssertEqual(env.statusItem.item.button?.subviews
            .contains(where: { $0.classForCoder == NSProgressIndicator.self }), false)
        XCTAssertEqual(env.statusItem.item.image, env.statusItem.viewState.style.image)
	}

	func testCancelRefreshOnMenuClickCancelsAllNetworkOperations() {
        // mocks
        let operationQueue = MockOperationQueue()
        let networkManager = NetworkManager(urlSession: MockURLSession(), queue: operationQueue)
        let photoController = PhotoController.testable(
            photoAlbumService: PhotoAlbumService(networkManager: networkManager),
            photoService: PhotoService(networkManager: networkManager, fileManager: MockFileManager()),
            photoStorageService: PhotoStorageService(dataManager: MockDataManger(), fileManager: MockFileManager())
        )
        let env = Environment(photoController: photoController)
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

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
