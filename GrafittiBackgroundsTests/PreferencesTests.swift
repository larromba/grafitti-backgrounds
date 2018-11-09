@testable import Grafitti_Backgrounds
import XCTest

class PreferencesTests: XCTestCase {
	func testPreferencesOpensOnMenuClick() {
		// mocks
		let statusItem = MockLoadingStatusItem()
		let menuController = AppMenuController(statusItem: statusItem)
		let windowController = MockWindowController()
		windowController.contentViewController = MockPreferencesViewController()
		let preferencesService = MockPreferencesService()
		preferencesService.actions.set(
			returnValue: Result<Preferences>.success(Preferences()),
			for: MockPreferencesService.load2.name
		)
		let preferencesController = PreferencesController(
			windowController: windowController,
			preferencesService: preferencesService
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

	func testPreferencesRender() {
		XCTFail("TODO")
	}

	func testPreferencesChange() {
		XCTFail("TODO")
	}

	func testPreferencesPersist() {
		// mocks
		guard
			let windowController = NSStoryboard.preferences.instantiateInitialController() as? NSWindowController,
			let preferencesViewController = windowController.contentViewController as? PreferencesViewController else {
				XCTFail("expected classes")
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
		XCTFail("TODO")
//		// mocks
//		guard
//			let windowController = NSStoryboard.preferences.instantiateInitialController() as? NSWindowController,
//			let preferencesViewController = windowController.contentViewController as? PreferencesViewController else {
//				XCTFail("expected classes")
//				return
//		}
//		let preferencesController = PreferencesController(
//			windowController: windowController,
//			preferencesService: PreferencesService(dataManager: MockDataManger())
//		)
//		let photoCoordinator = PhotoController(photoAlbumService: <#T##PhotoAlbumServicing#>, photoService: <#T##PhotoServicing#>, photoStorageService: <#T##PhotoStorageServicing#>)
//
//		// sut
//		_ = AppController.testable(preferencesController: preferencesController, menuController: menuController)
//
//		// test
//		preferencesController.open()
//		preferencesViewController.autoRefreshCheckBox.performClick(nil)
//		XCTAssertTrue(windowController.invocations.isInvoked(MockWindowController.showWindow1.name))
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
