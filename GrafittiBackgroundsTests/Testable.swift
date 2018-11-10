import Foundation
@testable import Grafitti_Backgrounds

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
}
