import Foundation
@testable import Graffiti_Backgrounds
import Networking
import Reachability

final class AppTestEnvironment {
    var preferencesWindowController: WindowControlling
    var userDefaults: UserDefaultable
    var workspace: Workspacing
    var statusItem: LoadingStatusItemable
    var reachability: Reachable
    var networkManager: NetworkManaging
    var fileManager: Graffiti_Backgrounds.FileManaging
    var photoFolderURL: URL
    var notificationCenter: UserNotificationCentering
    var sharingService: SharingServicing
    var application: Applicationable

    private(set) var dataManager: DataManaging!
    private(set) var preferencesService: PreferencesServicing!
    private(set) var preferencesController: PreferencesControllable!
    private(set) var workspaceController: WorkspaceControllable!
    private(set) var menuController: AppMenuControllable!
    private(set) var photoAlbumService: PhotoAlbumServicing!
    private(set) var photoService: PhotoServicing!
    private(set) var photoStorageService: PhotoStorageServicing!
    private(set) var photoManager: PhotoManaging!
    private(set) var alertController: AlertControlling!
    private(set) var emailController: EmailControlling!
    private(set) var appCoordinator: AppCoordinating!
    private(set) var appRouter: AppRouting!
    private(set) var app: Apping!

    init(preferencesWindowController: WindowControlling = MockWindowController(),
         userDefaults: UserDefaultable = MockUserDefaults(),
         workspace: Workspacing = MockWorkspace(),
         statusItem: LoadingStatusItemable = MockLoadingStatusItem(),
         reachability: Reachable = MockReachability(),
         urlSession: URLSessioning = MockURLSession(),
         networkManager: NetworkManaging = MockNetworkManager(),
         fileManager: Graffiti_Backgrounds.FileManaging = MockFileManager(),
         photoFolderURL: URL = .mock,
         notificationCenter: UserNotificationCentering = MockUserNotificationCenter(),
         sharingService: SharingServicing = MockSharingService(),
         application: Applicationable = MockApplication()) {
        self.preferencesWindowController = preferencesWindowController
        self.userDefaults = userDefaults
        self.workspace = workspace
        self.statusItem = statusItem
        self.reachability = reachability
        self.networkManager = networkManager
        self.fileManager = fileManager
        self.photoFolderURL = photoFolderURL
        self.notificationCenter = notificationCenter
        self.sharingService = sharingService
        self.application = application
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

// MARK: - TestEnvironment

extension AppTestEnvironment: TestEnvironment {
    func inject() {
        if !(preferencesWindowController.contentViewController is PreferencesViewController) {
            preferencesWindowController.contentViewController = MockPreferencesViewController()
        }
        dataManager = DataManger(userDefaults: userDefaults)
        preferencesService = PreferencesService(dataManager: dataManager)
        preferencesController = PreferencesController(windowController: preferencesWindowController,
                                                      preferencesService: preferencesService)
        workspaceController = WorkspaceController(workspace: workspace)
        menuController = AppMenuController(statusItem: statusItem, reachability: reachability)
        photoAlbumService = PhotoAlbumService(networkManager: networkManager)
        photoService = PhotoService(networkManager: networkManager, fileManager: fileManager)
        photoStorageService = PhotoStorageService(dataManager: dataManager, fileManager: fileManager)
        photoManager = PhotoManager(photoAlbumService: photoAlbumService,
                                    photoService: photoService,
                                    photoStorageService: photoStorageService,
                                    photoFolderURL: photoFolderURL)
        alertController = AlertController(notificationCenter: notificationCenter)
        emailController = EmailController(sharingService: sharingService)
        appCoordinator = AppCoordinator(preferencesController: preferencesController,
                                        workspaceController: workspaceController,
                                        menuController: menuController,
                                        photoManager: photoManager,
                                        alertController: alertController,
                                        emailController: emailController)
        appRouter = AppRouter(coordinator: appCoordinator)
        app = App(router: appRouter, application: application)
    }
}
