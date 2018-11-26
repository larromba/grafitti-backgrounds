@testable import Graffiti_Backgrounds
import Reachability
import Result
import TestExtensions
import XCTest

final class PreferencesTests: XCTestCase {
    private class Environment: TestEnvironment {
        let statusItem = MockLoadingStatusItem()
        lazy var menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
        let windowController: WindowControlling
        let preferencesService: PreferencesServicing
        lazy var preferencesController = PreferencesController(
            windowController: windowController,
            preferencesService: preferencesService
        )
        let photoController = PhotoController.testable()
        let app = MockApplication()
        var appController: AppController?

        func inject() {
            appController = AppController.testable(preferencesController: preferencesController,
                                                   menuController: menuController,
                                                   photoController: photoController,
                                                   app: app)
        }

        init(windowController: WindowControlling, preferencesService: PreferencesServicing = MockPreferencesService()) {
            self.windowController = windowController
            self.preferencesService = preferencesService
        }
    }

    func testPreferencesOnMenuClickOpensPreferences() {
        // mocks
        let windowController = MockWindowController()
        windowController.contentViewController = MockPreferencesViewController()
        let env = Environment(windowController: windowController)
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.preferences.rawValue)

        // test
        XCTAssertTrue(windowController.invocations.isInvoked(MockWindowController.showWindow1.name))
    }

    func testPreferencesOnMenuClickIsBoughtToFront() {
        // mocks
        let windowController = MockWindowController()
        windowController.contentViewController = MockPreferencesViewController()
        let env = Environment(windowController: windowController)
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.preferences.rawValue)

        // test
        XCTAssertTrue(env.app.invocations.isInvoked(MockApplication.activate1.name))
    }

    func testPreferencesRenderOnOpening() {
        // mocks
        let preferences = Preferences(isAutoRefreshEnabled: true, autoRefreshTimeIntervalHours: 1, numberOfPhotos: 2)
        let preferencesService = MockPreferencesService()
        preferencesService.actions.set(
            returnValue: Result.success(preferences),
            for: MockPreferencesService.load2.name
        )
        let preferencesUI = makePreferencesUI()
        let env = Environment(windowController: preferencesUI.0, preferencesService: preferencesService)
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.preferences.rawValue)

        // test
        XCTAssertEqual(preferencesUI.1.autoRefreshCheckBox.state, .on)
        XCTAssertEqual(preferencesUI.1.autoRefreshIntervalTextField.stringValue, "1")
        XCTAssertEqual(preferencesUI.1.numberOfPhotosTextField.stringValue, "2")
    }

    func testPreferencesPersistOnEveryChange() {
        // mocks
        let userDefaults = MockUserDefaults()
        let dataManager = DataManger(database: userDefaults)
        let preferencesService = PreferencesService(dataManager: dataManager)
        let preferencesUI = makePreferencesUI()
        let env = Environment(windowController: preferencesUI.0, preferencesService: preferencesService)
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.preferences.rawValue)
        preferencesUI.1.autoRefreshCheckBox.performClick(nil)
        preferencesUI.1.autoRefreshCheckBox.performClick(nil)
        preferencesUI.1.autoRefreshIntervalTextField.stringValue = "10"
        preferencesUI.1.autoRefreshIntervalTextField.fireTextChagedEvent(in: preferencesUI.1)
        preferencesUI.1.numberOfPhotosTextField.stringValue = "5"
        preferencesUI.1.numberOfPhotosTextField.fireTextChagedEvent(in: preferencesUI.1)

        // test
        XCTAssertEqual(userDefaults.preferences(at: 0)?.isAutoRefreshEnabled, false)
        XCTAssertEqual(userDefaults.preferences(at: 1)?.isAutoRefreshEnabled, true)
        XCTAssertEqual(userDefaults.preferences(at: 2)?.autoRefreshTimeIntervalHours, 10)
        XCTAssertEqual(userDefaults.preferences(at: 3)?.numberOfPhotos, 5)
    }

    func testPreferencesRestartDownloadTimerIfChanged() {
        // mocks
        let preferencesUI = makePreferencesUI()
        let env = Environment(windowController: preferencesUI.0)
        env.inject()
        let photoDelegate = MockPhotoControllerDelegate()
        env.photoController.setDelegate(photoDelegate)
        let preferences = Preferences(isAutoRefreshEnabled: true, autoRefreshTimeIntervalHours: 1, numberOfPhotos: 0)
        env.photoController.setPreferences(preferences)

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.preferences.rawValue)
        preferencesUI.1.autoRefreshIntervalTextField.stringValue = "0"
        preferencesUI.1.autoRefreshIntervalTextField.fireTextChagedEvent(in: preferencesUI.1)

        // test
        wait {
            XCTAssertTrue(photoDelegate.invocations.isInvoked(
                MockPhotoControllerDelegate.photoControllerTimerTriggered1.name)
            )
        }
    }

    // MARK: - private

    private func makePreferencesUI() -> (NSWindowController, PreferencesViewController) {
        guard
            let windowController = NSStoryboard.preferences.instantiateInitialController() as? NSWindowController,
            let preferencesViewController = windowController.contentViewController as? PreferencesViewController else {
                fatalError("expected NSWindowController & PreferencesViewController")
        }
        return (windowController, preferencesViewController)
    }
}

// MARK: - MockUserDefaults

private extension MockUserDefaults {
    func preferences(at index: Int) -> Preferences? {
        guard let data = invocations
            .find(MockUserDefaults.set2.name)[safe: index]?
            .parameter(for: MockUserDefaults.set2.params.value) as? Data else {
                return nil
        }
        return try? PropertyListDecoder().decode(Preferences.self, from: data)
    }
}
