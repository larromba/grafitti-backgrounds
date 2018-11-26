@testable import Graffiti_Backgrounds
import Networking
import Reachability
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
        let alertController = MockAlertController()
        var appController: AppController?

        init(photoController: PhotoControllable = PhotoController.testable()) {
            self.photoController = photoController
        }

        func inject() {
            appController = AppController.testable(menuController: menuController, photoController: photoController,
                                                   alertController: alertController)
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
        let networkManager = NetworkManager(urlSession: MockURLSession(), fileManager: Networking.MockFileManager(),
                                            queue: operationQueue)
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

    func testCancelRefreshDisplaysAlert() {
        // mocks
        let env = Environment()
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        let invocations = env.alertController.invocations.find(MockAlertController.showAlert1.name)
        let alert = invocations.first?.parameter(for: MockAlertController.showAlert1.params.alert) as? Alert
        XCTAssertEqual(alert?.title, "")
        XCTAssertEqual(alert?.text, "Your reload was cancelled")
        XCTAssertEqual(invocations.count, 1)
    }
}
