@testable import Grafitti_Backgrounds
import XCTest

final class RefreshTests: XCTestCase {
    private class Environment: TestEnvironment {
        let statusItem: MockLoadingStatusItem = {
            let statusItem = MockLoadingStatusItem()
            statusItem.viewState = LoadingStatusItemViewState(isLoading: false, loadingPercentage: 0, style: .sprayCan,
                                                              alpha: 1.0)
            return statusItem
        }()
        lazy var menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
        let photoFolderURL = URL.mockSaveURL
        let userDefaults = UserDefaults.mock
        let fileManager = FileManager.default
        lazy var networkManager = TestNetworkManager.make1PhotoDownloadSuccess(inFolder: photoFolderURL)
        lazy var photoAlbumService = PhotoAlbumService(networkManager: networkManager)
        lazy var dataManager = DataManger(database: userDefaults)
        lazy var photoStorageService = PhotoStorageService(dataManager: dataManager, fileManager: fileManager)
        lazy var photoService = PhotoService(networkManager: networkManager, fileManager: fileManager)
        lazy var photoController: PhotoController = {
            let photoController = PhotoController(photoAlbumService: photoAlbumService, photoService: photoService,
                                                  photoStorageService: photoStorageService,
                                                  photoFolderURL: photoFolderURL)
            let preferences = Preferences(isAutoRefreshEnabled: false, autoRefreshTimeIntervalHours: 1,
                                          numberOfPhotos: 1)
            photoController.setPreferences(preferences)
            return photoController
        }()
        let alertController = MockAlertController()
        var appController: AppController?

        func inject() {
            appController = AppController.testable(menuController: menuController, photoController: photoController,
                                                   alertController: alertController)
        }
    }

	func testRefreshFolderOnMenuClickTriggersLoadingIndicator() {
        // mocks
        let env = Environment()
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            let loadingProgress = env.statusItem._viewStateHistory.map { $0.variable.loadingPercentage }
            XCTAssertEqual(loadingProgress, [0.0, 0.0, 0.5, 0.5, 0.0])
        }
	}

    func testRefreshFolderOnMenuClickWhenFinishedShowsNormalStatusItem() {
        // mocks
        let env = Environment()
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            let viewState = env.statusItem._viewStateHistory.last?.variable
            XCTAssertEqual(viewState?.isLoading, false)
            XCTAssertEqual(viewState?.loadingPercentage, 0.0)
            XCTAssertEqual(viewState?.alpha, 1.0)
        }
    }

    func testRefreshFolderOnMenuClickWhenStartedShowsAlert() {
        // mocks
        let env = Environment()
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            let invocations = env.alertController.invocations.find(MockAlertController.showAlert1.name)
            let beginAlert = invocations.first?.parameter(for: MockAlertController.showAlert1.params.alert) as? Alert
            XCTAssertEqual(beginAlert?.title, "Refreshing...")
            XCTAssertEqual(beginAlert?.text, "Your photos are now refreshing")
        }
    }

    func testRefreshFolderOnMenuClickWhenFinishedShowsAlert() {
        // mocks
        let env = Environment()
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            let invocations = env.alertController.invocations.find(MockAlertController.showAlert1.name)
            let endAlert = invocations.last?.parameter(for: MockAlertController.showAlert1.params.alert) as? Alert
            XCTAssertEqual(endAlert?.title, "Success!")
            XCTAssertEqual(endAlert?.text, "Your photos were reloaded")
        }
    }

    func testRefreshFolderOnMenuClickClearsPreviousFiles() {
        // mocks
        let env = Environment()
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            XCTFail("todo")
        }
    }

    func testRefreshFolderOnMenuClickSavesToUserDefaults() {
        // mocks
        let env = Environment()
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            let folderContents = try? env.fileManager.contentsOfDirectory(atPath: env.photoFolderURL.path)
            XCTAssertEqual(folderContents?.count, 1)
        }
    }

    func testRefreshFolderOnMenuClickDownloadsNewFiles() {
        // mocks
        let env = Environment()
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            let folderContents = try? env.fileManager.contentsOfDirectory(atPath: env.photoFolderURL.path)
            XCTAssertEqual(folderContents?.count, 1)
        }
    }

    //TODO: this
    //notEnoughImagesAvailable
    //notEnoughImagesDownloaded
}
