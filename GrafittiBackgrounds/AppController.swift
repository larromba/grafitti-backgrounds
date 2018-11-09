import Cocoa

// sourcery: name = AppController
protocol AppControllable: Mockable {
    func start()
}

final class AppController: AppControllable {
    private let preferencesController: PreferencesControllable
    private let workspaceController: WorkspaceControllable
    private let menuController: AppMenuControllable
    private let photoController: PhotoControllable
    private let alertController: AlertControlling
    private let app: Applicationable

    init(preferencesController: PreferencesControllable,
         workspaceController: WorkspaceControllable,
         menuController: AppMenuControllable,
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
		alertController.showAlert(.reloadingPhotos)
		photoController.reloadPhotos(completion: { [weak self] result in
			switch result {
			case .success:
				self?.alertController.showAlert(.reloadPhotosSuccess)
			case .failure(let error as NetworkError):
				guard !error.isCancelled else { return }
				self?.alertController.showAlert(.error(error))
			case .failure(let error):
				self?.alertController.showAlert(.error(error))
			}
		})
    }

	private func handleNoSuccessResult(_ result: Result<Void>) {
		switch result {
		case .success: break
		case .failure(let error):
			alertController.showAlert(.error(error))
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
            alertController.showAlert(.error(error))
        }
    }

    func preferencesController(_ controller: PreferencesController, errorLoadingPreferences error: Error) {
        alertController.showAlert(.error(error))
    }
}

// MARK: - MenuControllerDelegate

extension AppController: AppMenuControllerDelegate {
    func menuController(_ controller: AppMenuController, selected action: AppMenu.Action) {
        switch action {
        case .refreshFolder(action: .refresh):
            reloadPhotos()
        case .refreshFolder(action: .cancel):
            photoController.cancelReload()
        case .openFolder:
			handleNoSuccessResult(workspaceController.open(photoController.folderURL))
        case .clearFolder:
			switch photoController.clearFolder() {
			case .success:
				alertController.showAlert(.clearFolderSuccess)
			case .failure(let error):
				alertController.showAlert(.error(error))
			}
        case .preferences:
            preferencesController.open()
        case .systemPreferences:
            handleNoSuccessResult(workspaceController.open(SystemPreference.desktopScreenEffects.url))
        case .about:
            app.orderFrontStandardAboutPanel(self)
        case .contact:
            // TODO: add email contact
            break
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
