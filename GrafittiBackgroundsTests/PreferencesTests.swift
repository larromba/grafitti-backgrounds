@testable import Grafitti_Backgrounds
import XCTest

class PreferencesTests: XCTestCase {
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

		// sut
		_ = AppController.testable(preferencesController: preferencesController, menuController: menuController)

		// test
		guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.preferences.rawValue) else {
			XCTFail("expected menu to click")
			return
		}
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

	func testPreferencesPersistEachChangeAfterOpening() {
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

		// sut
		let preferencesController = PreferencesController(
			windowController: windowController,
			preferencesService: preferencesService
		)
        preferencesController.open()

		// test
		preferencesViewController.autoRefreshCheckBox.performClick(nil)
        preferencesViewController.autoRefreshCheckBox.performClick(nil)
        preferencesViewController.autoRefreshIntervalTextField.stringValue = "10"
        preferencesViewController.autoRefreshIntervalTextField.fireTextChagedEvent(in: preferencesViewController)
        preferencesViewController.numberOfPhotosTextField.stringValue = "5"
        preferencesViewController.numberOfPhotosTextField.fireTextChagedEvent(in: preferencesViewController)

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
        let preferencesService = MockPreferencesService()
        let preferences = Preferences(isAutoRefreshEnabled: true, autoRefreshTimeIntervalHours: 1, numberOfPhotos: 0)
        preferencesService.actions.set(returnValue: Result.success(preferences), for: MockPreferencesService.load2.name)
        let preferencesController = PreferencesController(
            windowController: windowController,
            preferencesService: preferencesService
        )
        let photoController = PhotoController.testable()
        let delegate = MockPhotoControllerDelegate()

        // sut
        _ = AppController.testable(preferencesController: preferencesController, photoController: photoController)
        photoController.setDelegate(delegate)

        // test
        preferencesViewController.autoRefreshIntervalTextField.stringValue = "0"
        preferencesViewController.autoRefreshIntervalTextField.fireTextChagedEvent(in: preferencesViewController)

        wait(for: 0.1) {
            XCTAssertTrue(delegate.invocations.isInvoked(
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
