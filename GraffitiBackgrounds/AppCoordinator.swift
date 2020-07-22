import AsyncAwait
import Cocoa

// sourcery: name = AppController
protocol AppCoordinating: Mockable {
    func start()
    func setDelegate(_ delegate: AppCoordinatorDelegate)
}

protocol AppCoordinatorDelegate: AnyObject {
    func coordinator(_ coordinator: AppCoordinating, handleAction action: AppAction)
}

final class AppCoordinator: AppCoordinating {
    private let preferencesController: PreferencesControllable
    private let workspaceController: WorkspaceControllable
    private let menuController: AppMenuControllable
    private let photoManager: PhotoManaging
    private let alertController: AlertControlling
    private let emailController: EmailControlling
    private weak var delegate: AppCoordinatorDelegate?

    init(preferencesController: PreferencesControllable,
         workspaceController: WorkspaceControllable,
         menuController: AppMenuControllable,
         photoManager: PhotoManaging,
         alertController: AlertControlling,
         emailController: EmailControlling) {
        self.preferencesController = preferencesController
        self.workspaceController = workspaceController
        self.menuController = menuController
        self.photoManager = photoManager
        self.alertController = alertController
        self.emailController = emailController
        preferencesController.setDelegate(self)
        menuController.setDelegate(self)
        photoManager.setDelegate(self)
        photoManager.setPreferences(preferencesController.preferences)
    }

    func start() {
        reloadPhotos()
    }

    func setDelegate(_ delegate: AppCoordinatorDelegate) {
        self.delegate = delegate
    }

    // MARK: - private

    private func clearFolder() {
        switch photoManager.clearFolder() {
        case .success:
            alertController.showAlert(.clearFolderSuccess)
        case .failure(let error):
            alertController.showAlert(.error(error))
        }
    }

    private func reloadPhotos() {
        alertController.showAlert(.reloadingPhotos)
        async({
            _ = try await(self.photoManager.reloadPhotos())
            onMain { self.alertController.showAlert(.reloadPhotosSuccess) }
        }, onError: { error in
            guard !error.isNetworkErrorCancelled else { return }
            onMain { self.alertController.showAlert(.error(error)) }
        })
    }

    private func handleNoSuccessResult<U: Error>(_ result: Result<Void, U>) {
        guard let error = result.error else { return }
        alertController.showAlert(.error(error))
    }
}

// MARK: - PreferencesControllerDelegate

extension AppCoordinator: PreferencesControllerDelegate {
    func preferencesController(_ coordinator: PreferencesControllable,
                               didUpdatePreferences result: Result<Preferences, PreferencesError>) {
        switch result {
        case .success(let preferences):
            photoManager.setPreferences(preferences)
        case .failure(let error):
            alertController.showAlert(.error(error))
        }
    }

    func preferencesController(_ controller: PreferencesControllable, errorLoadingPreferences error: PreferencesError) {
        alertController.showAlert(.error(error))
    }
}

// MARK: - MenuControllerDelegate

extension AppCoordinator: AppMenuControllerDelegate {
    func menuController(_ controller: AppMenuController, selected action: AppMenu.Action) {
        switch action {
        case .refreshFolder(action: .refresh):
            reloadPhotos()
        case .refreshFolder(action: .cancel):
            photoManager.cancelReload()
            alertController.showAlert(.cancelReloadSuccess)
        case .openFolder:
            handleNoSuccessResult(workspaceController.open(photoManager.photoFolderURL))
        case .clearFolder:
            clearFolder()
        case .preferences:
            preferencesController.open()
            delegate?.coordinator(self, handleAction: .bringToFront)
        case .systemPreferences:
            handleNoSuccessResult(workspaceController.open(SystemPreference.desktopScreenEffects.url))
        case .about:
            delegate?.coordinator(self, handleAction: .openAbout)
            delegate?.coordinator(self, handleAction: .bringToFront)
        case .help:
            handleNoSuccessResult(workspaceController.open(.help))
        case .contact:
            handleNoSuccessResult(emailController.openMail(receipient: L10n.Email.recipient,
                                                           subject: L10n.Email.subject(Bundle.appName),
                                                           body: L10n.Email.message))
        case .quit:
            delegate?.coordinator(self, handleAction: .terminate)
        }
    }
}

// MARK: - PhotoManagerDelegate

extension AppCoordinator: PhotoManagerDelegate {
    func photoManagerTimerTriggered(_ photoManager: PhotoManaging) {
        reloadPhotos()
    }

    func photoManager(_ photoManager: PhotoManaging, updatedDownloadPercentage percentage: Double) {
        menuController.setLoadingPercentage(percentage)
    }

    func photoManager(_ photoManager: PhotoManaging, didChangeDownloadState inProgress: Bool) {
        menuController.setRefreshAction(inProgress ? .cancel : .refresh)
        menuController.setIsLoading(inProgress)
    }
}
