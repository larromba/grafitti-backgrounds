@testable import Graffiti_Backgrounds
import Networking
import Reachability
import TestExtensions
import XCTest

final class RefreshTests: XCTestCase {
    func testRefreshFolderOnMenuClickTriggersLoadingIndicator() {
        // mocks
        let statusItem = MockLoadingStatusItem()
        statusItem.viewState = LoadingStatusItemViewState()
        let env = AppControllerEnvironment(
            userDefaults: UserDefaults.mock,
            statusItem: statusItem,
            networkManager: TestNetworkManager.make1PhotoDownloadSuccess(inFolder: .makeTemporaryFolderURL()),
            fileManager: FileManager.default,
            photoFolderURL: .makePhotoFolderURL()
        )
        env.inject()

        // sut
        statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            let loadingProgress = statusItem._viewStateHistory.map { $0.variable.loadingPercentage }
            XCTAssertNotEqual(loadingProgress.count, Set(loadingProgress).count)
        }
    }

    func testRefreshFolderOnMenuClickWhenFinishedShowsNormalStatusItem() {
        // mocks
        let statusItem = MockLoadingStatusItem()
        statusItem.viewState = LoadingStatusItemViewState()
        let env = AppControllerEnvironment(
            userDefaults: UserDefaults.mock,
            statusItem: statusItem,
            networkManager: TestNetworkManager.make1PhotoDownloadSuccess(inFolder: .makeTemporaryFolderURL()),
            fileManager: FileManager.default,
            photoFolderURL: .makePhotoFolderURL()
        )
        env.inject()
        let preferences = Preferences(isAutoRefreshEnabled: false, autoRefreshTimeIntervalHours: 1, numberOfPhotos: 1)
        env.photoController.setPreferences(preferences)

        // sut
        statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            let viewState = statusItem._viewStateHistory.last?.variable
            XCTAssertEqual(viewState?.isLoading, false)
            XCTAssertEqual(viewState?.loadingPercentage, 0.0)
            XCTAssertEqual(viewState?.alpha, 1.0)
        }
    }

    func testRefreshFolderOnMenuClickWhenStartedShowsAlertNotification() {
        // mocks
        let statusItem = MockLoadingStatusItem()
        statusItem.viewState = LoadingStatusItemViewState()
        let notificationCenter = MockUserNotificationCenter()
        let env = AppControllerEnvironment(
            userDefaults: UserDefaults.mock,
            statusItem: statusItem,
            networkManager: TestNetworkManager.make1PhotoDownloadSuccess(inFolder: .makeTemporaryFolderURL()),
            fileManager: FileManager.default,
            photoFolderURL: .makePhotoFolderURL(),
            notificationCenter: notificationCenter
        )
        env.inject()
        let preferences = Preferences(isAutoRefreshEnabled: false, autoRefreshTimeIntervalHours: 1, numberOfPhotos: 1)
        env.photoController.setPreferences(preferences)

        // sut
        statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            let invocations = notificationCenter.invocations.find(MockUserNotificationCenter.deliver1.name)
            let notification = invocations.first?
                .parameter(for: MockUserNotificationCenter.deliver1.params.notification) as? NSUserNotification
            XCTAssertEqual(notification?.title, "Refreshing...")
            XCTAssertEqual(notification?.informativeText, "Your photos are now refreshing")
            XCTAssertEqual(invocations.count, 2)
        }
    }

    func testRefreshFolderOnMenuClickWhenFinishedShowsAlert() {
        // mocks
        let statusItem = MockLoadingStatusItem()
        statusItem.viewState = LoadingStatusItemViewState()
        let notificationCenter = MockUserNotificationCenter()
        let env = AppControllerEnvironment(
            userDefaults: UserDefaults.mock,
            statusItem: statusItem,
            networkManager: TestNetworkManager.make1PhotoDownloadSuccess(inFolder: .makeTemporaryFolderURL()),
            fileManager: FileManager.default,
            photoFolderURL: .makePhotoFolderURL(),
            notificationCenter: notificationCenter
        )
        env.inject()
        let preferences = Preferences(isAutoRefreshEnabled: false, autoRefreshTimeIntervalHours: 1, numberOfPhotos: 1)
        env.photoController.setPreferences(preferences)

        // sut
        statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            let invocations = notificationCenter.invocations.find(MockUserNotificationCenter.deliver1.name)
            let notification = invocations[safe: 1]?
                .parameter(for: MockUserNotificationCenter.deliver1.params.notification) as? NSUserNotification
            XCTAssertEqual(notification?.title, "Success!")
            XCTAssertEqual(notification?.informativeText, "Your photos were reloaded")
            XCTAssertEqual(invocations.count, 2)
        }
    }

    func testRefreshFolderOnMenuClickClearsPreviousFiles() {
        // mocks
        let statusItem = MockLoadingStatusItem()
        statusItem.viewState = LoadingStatusItemViewState()
        let env = AppControllerEnvironment(
            userDefaults: UserDefaults.mock,
            statusItem: statusItem,
            networkManager: TestNetworkManager.make1PhotoDownloadSuccess(inFolder: .makeTemporaryFolderURL()),
            fileManager: FileManager.default,
            photoFolderURL: .makePhotoFolderURL()
        )
        env.inject()
        let preferences = Preferences(isAutoRefreshEnabled: false, autoRefreshTimeIntervalHours: 1, numberOfPhotos: 1)
        env.photoController.setPreferences(preferences)

        let fileURL = URL(fileURLWithPath: env.photoFolderURL.path.appending("/testphoto.png"))
        XCTAssertNil(env.writePhoto(at: fileURL))

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            XCTAssertFalse(FileManager.default.fileExists(atPath: fileURL.path))
        }
    }

    func testRefreshFolderOnMenuClickSavesToUserDefaults() {
        // mocks
        let statusItem = MockLoadingStatusItem()
        statusItem.viewState = LoadingStatusItemViewState()
        let env = AppControllerEnvironment(
            userDefaults: UserDefaults.mock,
            statusItem: statusItem,
            networkManager: TestNetworkManager.make1PhotoDownloadSuccess(inFolder: .makeTemporaryFolderURL()),
            fileManager: FileManager.default,
            photoFolderURL: .makePhotoFolderURL()
        )
        env.inject()
        let preferences = Preferences(isAutoRefreshEnabled: false, autoRefreshTimeIntervalHours: 1, numberOfPhotos: 1)
        env.photoController.setPreferences(preferences)

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            XCTAssertEqual(env.photoStorageService.load().value?.first?.url.absoluteString,
                           "https://photos.google.com/share/test/photo/test")
        }
    }

    func testRefreshFolderOnMenuClickDownloadsNewFiles() {
        // mocks
        let statusItem = MockLoadingStatusItem()
        statusItem.viewState = LoadingStatusItemViewState()
        let env = AppControllerEnvironment(
            userDefaults: UserDefaults.mock,
            statusItem: statusItem,
            networkManager: TestNetworkManager.make1PhotoDownloadSuccess(inFolder: .makeTemporaryFolderURL()),
            fileManager: FileManager.default,
            photoFolderURL: .makePhotoFolderURL()
        )
        env.inject()
        let preferences = Preferences(isAutoRefreshEnabled: false, autoRefreshTimeIntervalHours: 1, numberOfPhotos: 1)
        env.photoController.setPreferences(preferences)

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            let folderContents = try? FileManager.default.contentsOfDirectory(atPath: env.photoFolderURL.path)
            XCTAssertEqual(folderContents?.count, 1)
        }
    }

    // TODO: maybe test these errors: notEnoughImagesAvailable, notEnoughImagesDownloaded ?
}
