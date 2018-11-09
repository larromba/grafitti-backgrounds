import Cocoa

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

        let viewState = LoadingStatusItemViewState(isLoading: false, loadingPercentage: 0, style: .sprayCan)
        let statusItem = LoadingStatusItem(viewState: viewState, statusBar: .system)
        let menuController = AppMenuController(statusItem: statusItem)

        let networkManager = NetworkManager()
        let fileManager = FileManager.default
        let photoAlbumService = PhotoAlbumService(networkManager: networkManager)
        let photoService = PhotoService(
            networkManager: networkManager,
            fileManager: fileManager,
            saveURL: .defaultSaveLocation
        )
        let photoStorageService = PhotoStorageService(dataManager: dataManager, fileManager: fileManager)
        let photoController = PhotoController(
            photoAlbumService: photoAlbumService,
            photoService: photoService,
            photoStorageService: photoStorageService
        )

		let alertController = AlertController(notificationCenter: NSUserNotificationCenter.default)
        let appController = AppController(
            preferencesController: preferencesController,
            workspaceController: workspaceController,
            menuController: menuController,
            photoController: photoController,
            alertController: alertController,
            app: app
        )
        let appDelegate = AppDelegate(appController: appController)
        return appDelegate
    }
}
