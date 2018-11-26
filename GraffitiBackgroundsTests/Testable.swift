import Foundation
@testable import Graffiti_Backgrounds
import Networking

extension AppController {
    static func testable(
        preferencesController: PreferencesControllable = MockPreferencesController(),
        workspaceController: WorkspaceControllable = MockWorkspaceController(),
        menuController: AppMenuControllable = MockAppMenuController(),
        photoController: PhotoControllable = MockPhotoController(),
        alertController: AlertControlling = MockAlertController(),
        emailController: EmailControlling = MockEmailController(),
        app: Applicationable = MockApplication()) -> AppController {
        return AppController(
            preferencesController: preferencesController,
            workspaceController: workspaceController,
            menuController: menuController,
            photoController: photoController,
            alertController: alertController,
            emailController: emailController,
            app: app
        )
    }
}

extension TestNetworkManager {
    static func make1PhotoDownloadSuccess(inFolder url: URL) -> TestNetworkManager {
        let fetchStubs = [
            FetchStub(url: API.photoAlbums.url, resource: TestResource.photoAlbumResponse1Album.rawValue),
            FetchStub(url: URL(string: "https://photos.app.goo.gl/test")!,
                      resource: TestResource.photoResourceResponse1Photo.rawValue),
            FetchStub(url: URL(string: "https://photos.google.com/share/test/photo/test")!,
                      resource: TestResource.photoResponse1Photo.rawValue)
        ]
        let downloadStubs = [
            DownloadStub(url: URL(string: "https://lh3.googleusercontent.com/test=w2148-h1610-no")!,
                         writeURL: url.appendingPathComponent("test.png"),
                         data: Data())
        ]
        return TestNetworkManager(fetchStubs: fetchStubs, downloadStubs: downloadStubs)
    }
}

extension PhotoController {
    static func testable(
        photoAlbumService: PhotoAlbumServicing = MockPhotoAlbumService(),
        photoService: PhotoServicing = MockPhotoService(),
        photoStorageService: PhotoStorageServicing = MockPhotoStorageService(),
        photoFolderURL: URL = .mock) -> PhotoController {
        return PhotoController(
            photoAlbumService: photoAlbumService,
            photoService: photoService,
            photoStorageService: photoStorageService,
            photoFolderURL: photoFolderURL
        )
    }
}

extension URL {
    static var mock = URL(string: "http://www.google.com")!

    static func makePhotoFolderURL() -> URL {
        return URL(fileURLWithPath: "\(NSTemporaryDirectory())\(UUID().uuidString)")
    }

    static func makeTemporaryFolderURL() -> URL {
        let url = URL(fileURLWithPath: "\(NSTemporaryDirectory())\(UUID().uuidString)")
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
        } catch {
            assertionFailure(error.localizedDescription)
        }
        return url
    }
}

extension UserDefaults {
    static var mock: UserDefaults {
        let userDefaults = UserDefaults(suiteName: "test")!
        userDefaults.dictionaryRepresentation().keys.forEach(userDefaults.removeObject(forKey:))
        return userDefaults
    }
}
