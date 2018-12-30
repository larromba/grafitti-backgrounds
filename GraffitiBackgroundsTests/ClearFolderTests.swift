@testable import Graffiti_Backgrounds
import Reachability
import XCTest

final class ClearFolderTests: XCTestCase {
    func testClearFolderOnMenuClickDeletesAllPhotos() {
        // mocks
        let env = AppControllerEnvironment(
            userDefaults: UserDefaults.mock,
            fileManager: FileManager.default,
            photoFolderURL: .makePhotoFolderURL()
        )
        env.inject()
        let fileURL = URL(fileURLWithPath: env.photoFolderURL.path.appending("/testphoto.png"))
        XCTAssertNil(env.writePhoto(at: fileURL))

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.clearFolder.rawValue)

        // test
        XCTAssertFalse(FileManager.default.fileExists(atPath: fileURL.path))
    }

    func testClearFolderDisplaysAlert() {
        // mocks
        let notificationCenter = MockUserNotificationCenter()
        let env = AppControllerEnvironment(
            userDefaults: UserDefaults.mock,
            fileManager: FileManager.default,
            photoFolderURL: .makePhotoFolderURL(),
            notificationCenter: notificationCenter
        )
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.clearFolder.rawValue)

        // test
        let invocations = notificationCenter.invocations.find(MockUserNotificationCenter.deliver1.name)
        let notification = invocations.first?
            .parameter(for: MockUserNotificationCenter.deliver1.params.notification) as? NSUserNotification
        XCTAssertEqual(notification?.title, "Success!")
        XCTAssertEqual(notification?.informativeText, "Your photos were cleared")
        XCTAssertEqual(invocations.count, 1)
    }
}
