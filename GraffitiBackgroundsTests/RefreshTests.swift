@testable import Graffiti_Backgrounds
import Networking
import Reachability
import TestExtensions
import XCTest

final class RefreshTests: XCTestCase {
    private var statusItem: MockLoadingStatusItem!
    private var env: AppControllerEnvironment!

    override func setUp() {
        super.setUp()
        statusItem = MockLoadingStatusItem()
        statusItem.viewState = LoadingStatusItemViewState()
        env = AppControllerEnvironment(
            userDefaults: UserDefaults.mock, statusItem: statusItem,
            networkManager: TestNetworkManager.make1PhotoDownloadSuccess(inFolder: .makeTemporaryFolderURL()),
            fileManager: FileManager.default, photoFolderURL: .makePhotoFolderURL()
        )
    }

    override func tearDown() {
        statusItem = nil
        env = nil
        super.tearDown()
    }

    func testRefreshFolderOnMenuClickTriggersLoadingIndicator() {
        // mocks
        env.inject()

        // sut
        statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            let loadingProgress = self.statusItem._viewStateHistory.map { $0.variable.loadingPercentage }
            XCTAssertNotEqual(loadingProgress.count, Set(loadingProgress).count)
        }
    }

    func testRefreshFolderOnMenuClickWhenFinishedShowsNormalStatusItem() {
        // mocks
        env.inject()
        setPreferences()

        // sut
        statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            let viewState = self.statusItem._viewStateHistory.last?.variable
            XCTAssertEqual(viewState?.isLoading, false)
            XCTAssertEqual(viewState?.loadingPercentage, 0.0)
            XCTAssertEqual(viewState?.alpha, 1.0)
        }
    }

    func testRefreshFolderOnMenuClickWhenStartedShowsAlertNotification() {
        // mocks
        let notificationCenter = MockUserNotificationCenter()
        env.notificationCenter = notificationCenter
        env.inject()
        setPreferences()

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
        let notificationCenter = MockUserNotificationCenter()
        env.notificationCenter = notificationCenter
        env.inject()
        setPreferences()

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
        env.inject()
        setPreferences()

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
        env.inject()
        setPreferences()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            XCTAssertEqual(self.env.photoStorageService.load().value?.first?.url.absoluteString,
                           "https://photos.google.com/share/test/photo/test")
        }
    }

    func testRefreshFolderOnMenuClickDownloadsNewFiles() {
        // mocks
        env.inject()
        setPreferences()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.refreshFolder.rawValue)

        // test
        wait {
            let folderContents = try? FileManager.default.contentsOfDirectory(atPath: self.env.photoFolderURL.path)
            XCTAssertEqual(folderContents?.count, 1)
        }
    }

    // TODO: maybe test these errors: notEnoughImagesAvailable, notEnoughImagesDownloaded ?

    // MARK: - private

    private func setPreferences() {
        let preferences = Preferences(isAutoRefreshEnabled: false, autoRefreshTimeIntervalHours: 1, numberOfPhotos: 1)
        env.photoController.setPreferences(preferences)
    }
}
