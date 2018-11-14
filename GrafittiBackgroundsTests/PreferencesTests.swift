@testable import Grafitti_Backgrounds
import XCTest

// TODO: make env?
final class PreferencesTests: XCTestCase {
	func testPreferencesOnMenuClickOpensPreferences() {
		// mocks
		let statusItem = MockLoadingStatusItem()
		let menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
		let windowController = MockWindowController()
        windowController.contentViewController = MockPreferencesViewController()
		let preferencesController = PreferencesController(
			windowController: windowController,
			preferencesService: MockPreferencesService()
		)
        _ = AppController.testable(preferencesController: preferencesController, menuController: menuController)

        // sut
		statusItem.menu?.click(at: AppMenu.Order.preferences.rawValue)

        // test
		XCTAssertTrue(windowController.invocations.isInvoked(MockWindowController.showWindow1.name))
	}

	func testPreferencesRenderOnOpening() {
        // mocks
        guard
            let windowController = NSStoryboard.preferences.instantiateInitialController() as? NSWindowController,
            let preferencesViewController = windowController.contentViewController as? PreferencesViewController else {
                XCTFail("expected NSWindowController & PreferencesViewController")
                return
        }
        let preferences = Preferences(isAutoRefreshEnabled: true, autoRefreshTimeIntervalHours: 1, numberOfPhotos: 2)
        let preferencesService = MockPreferencesService()
        preferencesService.actions.set(returnValue: Result.success(preferences), for: MockPreferencesService.load2.name)
        let preferencesController = PreferencesController(
            windowController: windowController,
            preferencesService: preferencesService
        )

        // sut
        preferencesController.open()

        // test
        XCTAssertEqual(preferencesViewController.autoRefreshCheckBox.state, .on)
        XCTAssertEqual(preferencesViewController.autoRefreshIntervalTextField.stringValue, "1")
        XCTAssertEqual(preferencesViewController.numberOfPhotosTextField.stringValue, "2")
	}

	func testPreferencesPersistOnEveryChange() {
		// mocks
		guard
			let windowController = NSStoryboard.preferences.instantiateInitialController() as? NSWindowController,
			let preferencesViewController = windowController.contentViewController as? PreferencesViewController else {
				XCTFail("expected NSWindowController & PreferencesViewController")
				return
		}
		let userDefaults = MockUserDefaults()
		let dataManager = DataManger(database: userDefaults)
		let preferencesService = PreferencesService(dataManager: dataManager)
        let preferencesController = PreferencesController(
            windowController: windowController,
            preferencesService: preferencesService
        )

		// sut
        preferencesController.open()
		preferencesViewController.autoRefreshCheckBox.performClick(nil)
        preferencesViewController.autoRefreshCheckBox.performClick(nil)
        preferencesViewController.autoRefreshIntervalTextField.stringValue = "10"
        preferencesViewController.autoRefreshIntervalTextField.fireTextChagedEvent(in: preferencesViewController)
        preferencesViewController.numberOfPhotosTextField.stringValue = "5"
        preferencesViewController.numberOfPhotosTextField.fireTextChagedEvent(in: preferencesViewController)

        // test
        XCTAssertEqual(userDefaults.preferences(at: 0)?.isAutoRefreshEnabled, false)
        XCTAssertEqual(userDefaults.preferences(at: 1)?.isAutoRefreshEnabled, true)
        XCTAssertEqual(userDefaults.preferences(at: 2)?.autoRefreshTimeIntervalHours, 10)
        XCTAssertEqual(userDefaults.preferences(at: 3)?.numberOfPhotos, 5)
	}

	func testPreferencesRestartDownloadTimerIfChanged() {
        // mocks
        guard
            let windowController = NSStoryboard.preferences.instantiateInitialController() as? NSWindowController,
            let preferencesViewController = windowController.contentViewController as? PreferencesViewController else {
                XCTFail("expected NSWindowController & PreferencesViewController")
                return
        }
        let preferences = Preferences(isAutoRefreshEnabled: true, autoRefreshTimeIntervalHours: 1, numberOfPhotos: 0)
        let preferencesController = PreferencesController(
            windowController: windowController,
            preferencesService: MockPreferencesService()
        )
        let photoDelegate = MockPhotoControllerDelegate()
        let photoController = PhotoController.testable()
        _ = AppController.testable(preferencesController: preferencesController, photoController: photoController)
        photoController.setDelegate(photoDelegate)
        photoController.setPreferences(preferences)

        // sut
        preferencesController.open()
        preferencesViewController.autoRefreshIntervalTextField.stringValue = "0"
        preferencesViewController.autoRefreshIntervalTextField.fireTextChagedEvent(in: preferencesViewController)

        // test
        wait {
            XCTAssertTrue(photoDelegate.invocations.isInvoked(
                MockPhotoControllerDelegate.photoControllerTimerTriggered1.name)
            )
        }
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
