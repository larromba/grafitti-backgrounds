@testable import Graffiti_Backgrounds
import XCTest

final class ClearFolderTests: XCTestCase {
    private class Environment: TestEnvironment {
        let statusItem = MockLoadingStatusItem()
        lazy var menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
        let photoFolderURL = URL.makePhotoFolderURL()
        let userDefaults = UserDefaults.mock
        let fileManager = FileManager.default
        lazy var dataManager = DataManger(database: userDefaults)
        lazy var photoStorageService = PhotoStorageService(dataManager: dataManager, fileManager: fileManager)
        lazy var photoController = PhotoController.testable(photoStorageService: photoStorageService,
                                                            photoFolderURL: photoFolderURL)
        let alertController = MockAlertController()
        var appController: AppController?

        func inject() {
            appController = AppController.testable(menuController: menuController, photoController: photoController,
                                                   alertController: alertController)
        }

        func writePhoto(at fileURL: URL) -> Error? {
            do {
                try fileManager.createDirectory(at: photoFolderURL, withIntermediateDirectories: false, attributes: nil)
                try Data().write(to: fileURL)
                let photoResource = PhotoResource(url: .mock, downloadURL: .mock, fileURL: fileURL)
                return photoStorageService.save([photoResource]).error
            } catch {
                return error
            }
        }
    }

    func testClearFolderOnMenuClickDeletesAllPhotos() {
        // mocks
        let env = Environment()
        env.inject()

        let fileURL = URL(fileURLWithPath: env.photoFolderURL.path.appending("/testphoto.png"))
        XCTAssertNil(env.writePhoto(at: fileURL))

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.clearFolder.rawValue)

        // test
        XCTAssertFalse(env.fileManager.fileExists(atPath: fileURL.path))
    }

    func testClearFolderDisplaysAlert() {
        // mocks
        let env = Environment()
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.clearFolder.rawValue)

        // test
        let invocations = env.alertController.invocations.find(MockAlertController.showAlert1.name)
        let alert = invocations.first?.parameter(for: MockAlertController.showAlert1.params.alert) as? Alert
        XCTAssertEqual(alert?.title, "Success!")
        XCTAssertEqual(alert?.text, "Your photos were cleared")
        XCTAssertEqual(invocations.count, 1)
    }
}
