import Foundation
@testable import Graffiti_Backgrounds
import Networking
import Reachability

final class AppControllerEnvironment: TestEnvironment {
    let userDefaults: UserDefaultable
    let dataManager: DataManaging
    let preferencesWindowController: WindowControlling
    let preferencesService: PreferencesServicing
    let preferencesController: PreferencesControllable
    let workspace: Workspacing
    let workspaceController: WorkspaceControllable
    let statusItem: LoadingStatusItemable
    let reachability: Reachable
    let menuController: AppMenuControllable
    let fileManager: Graffiti_Backgrounds.FileManaging
    let photoAlbumService: PhotoAlbumServicing
    let photoService: PhotoServicing
    let photoStorageService: PhotoStorageServicing
    let photoFolderURL: URL
    let photoController: PhotoControllable
    let notificationCenter: UserNotificationCentering
    let alertController: AlertControlling
    let sharingService: SharingServicing
    let emailController: EmailControlling
    let app: Applicationable
    var appController: AppController?

    init(preferencesWindowController: WindowControlling = MockWindowController(),
         userDefaults: UserDefaultable = MockUserDefaults(),
         workspace: Workspacing = MockWorkspace(),
         statusItem: LoadingStatusItemable = MockLoadingStatusItem(),
         reachability: Reachable = MockReachability(),
         networkManager: NetworkManaging = MockNetworkManager(),
         fileManager: Graffiti_Backgrounds.FileManaging = MockFileManager(),
         photoFolderURL: URL = .mock,
         notificationCenter: UserNotificationCentering = MockUserNotificationCenter(),
         sharingService: SharingServicing = MockSharingService(),
         app: Applicationable = MockApplication()) {
        self.preferencesWindowController = preferencesWindowController
        if !(preferencesWindowController.contentViewController is PreferencesViewController) {
            preferencesWindowController.contentViewController = MockPreferencesViewController()
        }
        self.userDefaults = userDefaults
        self.dataManager = DataManger(userDefaults: userDefaults)
        self.preferencesService = PreferencesService(dataManager: dataManager)
        self.preferencesController = PreferencesController(windowController: preferencesWindowController,
                                                           preferencesService: preferencesService)
        self.workspace = workspace
        self.workspaceController = WorkspaceController(workspace: workspace)
        self.statusItem = statusItem
        self.reachability = reachability
        self.menuController = AppMenuController(statusItem: statusItem, reachability: reachability)
        self.photoAlbumService = PhotoAlbumService(networkManager: networkManager)
        self.fileManager = fileManager
        self.photoService = PhotoService(networkManager: networkManager, fileManager: fileManager)
        self.photoStorageService = PhotoStorageService(dataManager: dataManager, fileManager: fileManager)
        self.photoFolderURL = photoFolderURL
        self.photoController = PhotoController(photoAlbumService: photoAlbumService, photoService: photoService,
                                               photoStorageService: photoStorageService, photoFolderURL: photoFolderURL)
        self.notificationCenter = notificationCenter
        self.alertController = AlertController(notificationCenter: notificationCenter)
        self.sharingService = sharingService
        self.emailController = EmailController(sharingService: sharingService)
        self.app = app
    }

    func inject() {
        appController = AppController(
            preferencesController: preferencesController,
            workspaceController: workspaceController,
            menuController: menuController,
            photoController: photoController,
            alertController: alertController,
            emailController: emailController,
            app: app
        )
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
