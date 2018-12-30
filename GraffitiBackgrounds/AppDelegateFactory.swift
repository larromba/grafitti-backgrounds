import Cocoa
import Networking
import Reachability

enum AppDelegateFactory {
    static func make(for app: NSApplication) -> AppDelegatable {
        let preferencesWindow = NSStoryboard.preferences.instantiateInitialController() as! NSWindowController
        let dataManager = DataManger(database: UserDefaults.standard)
        let preferencesService = PreferencesService(dataManager: dataManager)
        let preferencesController = PreferencesController(
            windowController: preferencesWindow,
            preferencesService: preferencesService
        )

        let workspace = NSWorkspace.shared
        let workspaceController = WorkspaceController(workspace: workspace)

        let statusItem = LoadingStatusItem(viewState: LoadingStatusItemViewState(), statusBar: NSStatusBar.system)
        let reachability = Reachability()
        let menuController = AppMenuController(statusItem: statusItem, reachability: reachability)

        let urlSession = URLSession(configuration: .default)
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        let fileManager = FileManager.default
        let networkManager = NetworkManager(urlSession: urlSession, fileManager: fileManager, queue: queue)

        let photoAlbumService = PhotoAlbumService(networkManager: networkManager)
        let photoService = PhotoService(
            networkManager: networkManager,
            fileManager: fileManager
        )
        let photoStorageService = PhotoStorageService(dataManager: dataManager, fileManager: fileManager)
        let photoController = PhotoController(
            photoAlbumService: photoAlbumService,
            photoService: photoService,
            photoStorageService: photoStorageService,
            photoFolderURL: .defaultSaveLocation
        )

        let alertController = AlertController(notificationCenter: NSUserNotificationCenter.default)
        let emailController = EmailController(sharingService: NSSharingService(named: .composeEmail))
        let appController = AppController(
            preferencesController: preferencesController,
            workspaceController: workspaceController,
            menuController: menuController,
            photoController: photoController,
            alertController: alertController,
            emailController: emailController,
            app: app
        )

        let appDelegate = AppDelegate(appController: appController)
        return appDelegate
    }
}
