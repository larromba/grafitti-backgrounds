import Cocoa

protocol PreferencesControllerDelegate: AnyObject {
    func preferencesController(_ controller: PreferencesControllable, errorLoadingPreferences error: PreferencesError)
    func preferencesController(_ controller: PreferencesControllable,
                               didUpdatePreferences result: Result<Preferences, PreferencesError>)
}

// sourcery: name = PreferencesController, inherits = NSViewController
protocol PreferencesControllable: Mockable {
    var preferences: Preferences { get }

    func open()
    func setDelegate(_ delegate: PreferencesControllerDelegate)
}

final class PreferencesController: PreferencesControllable {
    private let windowController: WindowControlling
    private let preferencesViewController: PreferencesViewControllable
    private let preferencesService: PreferencesServicing
    private weak var delegate: PreferencesControllerDelegate?

    private(set) var preferences: Preferences

    init(windowController: WindowControlling, preferencesService: PreferencesServicing) {
        self.windowController = windowController
        self.preferencesService = preferencesService
        preferencesViewController = windowController.contentViewController as! PreferencesViewControllable

        switch preferencesService.load() {
        case .success(let preferences):
            self.preferences = preferences
        case .failure(let error):
            preferences = Preferences()
            delegate?.preferencesController(self, errorLoadingPreferences: error)
        }

        preferencesViewController.setDelegate(self)
    }

    func open() {
        windowController.showWindow(self)
        render(preferences)
    }

    func setDelegate(_ delegate: PreferencesControllerDelegate) {
        self.delegate = delegate
    }

    // MARK: - private

    private func save(_ preferences: Preferences) {
        switch preferencesService.save(preferences) {
        case .success:
            delegate?.preferencesController(self, didUpdatePreferences: .success(preferences))
        case .failure(let error):
            delegate?.preferencesController(self, didUpdatePreferences: .failure(error))
        }
    }

    private func render(_ preferences: Preferences) {
        preferencesViewController.viewState = PreferencesViewState(preferences: preferences)
    }
}

// MARK: - PreferencesViewControllerDelegate

extension PreferencesController: PreferencesViewControllerDelegate {
    func preferencesViewController(_ viewController: PreferencesViewController,
                                   didUpdateViewState viewState: PreferencesViewStating) {
        preferences.numberOfPhotos = viewState.numberOfPhotos
        preferences.isAutoRefreshEnabled = viewState.isAutoRefreshEnabled
        preferences.autoRefreshTimeIntervalHours = viewState.autoRefreshTimeIntervalHours
        save(preferences)
    }
}
