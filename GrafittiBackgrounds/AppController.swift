import Cocoa

// sourcery: name = AppController
protocol AppControllable: Mockable {
    func start()
}

final class AppController: AppControllable {
    private var preferencesController: PreferencesControllable
    private let workspaceController: WorkspaceControllable
    private var menuController: MenuControllable
    private var photoController: PhotoControllable
    private let alertController: AlertControlling
    private let app: Applicationable

    init(preferencesController: PreferencesControllable,
         workspaceController: WorkspaceControllable,
         menuController: MenuControllable,
         photoController: PhotoControllable,
         alertController: AlertControlling,
         app: Applicationable) {
        self.preferencesController = preferencesController
        self.workspaceController = workspaceController
        self.menuController = menuController
        self.photoController = photoController
        self.alertController = alertController
        self.app = app

        self.preferencesController.setDelegate(self)
        self.menuController.setDelegate(self)
        self.photoController.setDelegate(self)
        self.photoController.setPreferences(preferencesController.preferences)
    }

    func start() {
        reloadPhotos()
    }

    // MARK: - private

    private func reloadPhotos() {
        photoController.reloadPhotos { [weak self] (result: Result<[PhotoControllerReloadResult]>) in
            self?.handleResult(result)
        }
    }

    private func handleResult<T>(_ result: Result<T>) {
        switch result {
        case .success:
            break
        case .failure(let error):
            alertController.showAlert(error)
        }
    }
}

// MARK: - PreferencesControllerDelegate

extension AppController: PreferencesControllerDelegate {
    func preferencesController(_ coordinator: PreferencesController, didUpdatePreferences result: Result<Preferences>) {
        switch result {
        case .success(let preferences):
            photoController.setPreferences(preferences)
        case .failure(let error):
            alertController.showAlert(error)
        }
    }

    func preferencesController(_ controller: PreferencesController, errorLoadingPreferences error: Error) {
        alertController.showAlert(error)
    }
}

// MARK: - MenuControllerDelegate

extension AppController: MenuControllerDelegate {
    func menuController(_ controller: MenuController, selected action: AppMenu.Action) {
        switch action {
        case .refreshFolder(action: .refresh):
            reloadPhotos()
        case .refreshFolder(action: .cancel):
            photoController.cancelReload()
        case .openFolder:
            handleResult(workspaceController.open(photoController.folderURL))
        case .clearFolder:
            handleResult(photoController.clearFolder())
        case .preferences:
            preferencesController.open()
        case .systemPreferences:
            handleResult(workspaceController.open(SystemPreference.desktopScreenEffects.url))
        case .about:
            app.orderFrontStandardAboutPanel(self)
        case .quit:
            app.terminate(self)
        }
    }
}

// MARK: - PhotoControllerDelegate

extension AppController: PhotoControllerDelegate {
    func photoControllerTimerTriggered(_ photoController: PhotoController) {
        reloadPhotos()
    }

    func photoController(_ photoController: PhotoController, updatedDownloadPercentage percentage: Double) {
        menuController.setLoadingPercentage(percentage)
    }

    func photoController(_ photoController: PhotoController, didChangeDownloadState inProgress: Bool) {
        menuController.setRefreshAction(inProgress ? .cancel : .refresh)
        menuController.setIsLoading(inProgress)
    }
}
