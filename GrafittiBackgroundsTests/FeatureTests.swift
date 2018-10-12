//
//  GrafittiBackgroundsTests.swift
//  GrafittiBackgroundsTests
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import XCTest
@testable import Grafitti_Backgrounds

class AppCoordintorTests: XCTestCase {
//	func testRefreshFolder() {
//		// mocks
//		class MockLoadingStatusItem: LoadingStatusItem {
//			var loadingPercentages = [Double]()
//			override var loadingPercentage: Double {
//				get { return super.loadingPercentage }
//				set { loadingPercentages.append(loadingPercentage ) }
//			}
//		}
//		class MockPhotoAlbumService: StubPhotoAlbumService {
//			var photoAlbums: [PhotoAlbum]!
//			override func getPhotoAlbums(success: @escaping (([PhotoAlbum]) -> ()), failure: ((Error) -> ())?) {
//				success(photoAlbums)
//			}
//		}
//		class MockNetworkManager: StubNetworkManager {
//			override func send(request: Request, success: @escaping ((Response) -> ()), failure: @escaping ((Error) -> ())) {
//				success(PhotoResponse(imageURL: .stub))
//			}
//			var downloadURL: URL!
//			override func download(_ url: URL, success: @escaping ((URL) -> ()), failure: @escaping ((Error) -> ())) {
//				success(downloadURL)
//			}
//		}
//		class MockFileManager: StubFileManager {
//			var srcURLs = [URL]()
//			var dstURLs = [URL]()
//			override func moveItem(at srcURL: URL, to dstURL: URL) throws {
//				srcURLs.append(srcURL)
//				dstURLs.append(dstURL)
//			}
//		}
//		let statusItem = MockLoadingStatusItem(viewModel: LoadingStatusItemViewModel(isLoading: false, loadingPercentage: 0, style: .sprayCan), statusBar: .system)
//		let menuController = MenuController(statusItem: statusItem)
//		let networkManager = MockNetworkManager()
//		networkManager.downloadURL = URL(fileURLWithPath: "/some/place/file.tmp")
//		let fileManager = MockFileManager()
//		let saveURL = URL(fileURLWithPath: "/some/place")
//		let photoService = PhotoService(networkManager: networkManager, fileManager: fileManager, saveURL: saveURL)
//		let photoAlbumService = MockPhotoAlbumService()
//		photoAlbumService.photoAlbums = [PhotoAlbum(url: .stub, resources: [
//			PhotoResource(url: .stub, fileURL: .stub)
//			])]
//		let preferences = Preferences(isAutoRefreshEnabled: false, autoRefreshTimeIntervalHours: 0, numberOfPhotos: 1)
//		let photoController = PhotoController(photoAlbumService: photoAlbumService, photoService: photoService, photoStorageService: StubPhotoStorageService(), preferences: preferences)
//		let preferencesController = StubPreferencesController()
//		preferencesController.preferences = Preferences(isAutoRefreshEnabled: false, autoRefreshTimeIntervalHours: 0, numberOfPhotos: 1)
//		_ = AppController(preferencesController: preferencesController, workspaceController: StubWorkspaceController(), menuController: menuController, photoController: photoController, app: StubApplication())
//
//		// test
//		guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.refreshFolder.rawValue) else {
//			XCTFail()
//			return
//		}
//		photoAlbumService.photoAlbums?.forEach { _ in
//			XCTAssertTrue(fileManager.srcURLs.contains(networkManager.downloadURL))
//			XCTAssertTrue(fileManager.dstURLs.contains(saveURL.appendingPathComponent("file.png")))
//		}
//	}
//
//	func testDownloadPercentage() {
//		XCTFail()
//	}
//
//	func testDownloadMenuState() {
//		XCTFail()
//	}
//
//	func testOpenFolder() {
//		// mocks
//		class MockPhotoService: StubPhotoService {
//			override var saveURL: URL {
//				get { return URL(fileURLWithPath: "path/to/my/folder") }
//				set {}
//			}
//		}
//		class MockWorkspace: StubWorkspace {
//			var urlOpened: URL?
//			override func open(_ url: URL) -> Bool {
//				urlOpened = url
//				return true
//			}
//		}
//		let statusItem = StubLoadingStatusItem()
//		let menuController = MenuController(statusItem: statusItem)
//		let photoService = MockPhotoService()
//		let photoController = PhotoController(photoAlbumService: StubPhotoAlbumService(), photoService: photoService, photoStorageService: StubPhotoStorageService())
//		let workspace = MockWorkspace()
//		let workspaceController = WorkspaceController(workspace: workspace)
//		_ = AppController(preferencesController: StubPreferencesController(), workspaceController: workspaceController, menuController: menuController, photoController: photoController, app: StubApplication())
//
//		// test
//		guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.openFolder.rawValue) else {
//			XCTFail()
//			return
//		}
//		XCTAssertEqual(workspace.urlOpened, photoService.saveURL)
//	}
//
//	func testClearFolder() {
//		// mocks
//		class MockFileManager: StubFileManager {
//			var urls = [URL]()
//			override func removeItem(at URL: URL) throws {
//				urls.append(URL)
//			}
//		}
//		class MockPhotoStorageService: PhotoStorageService {
//			var resources: [PhotoResource]?
//			override func load() -> [PhotoResource]? {
//				return resources
//			}
//		}
//		let statusItem = StubLoadingStatusItem()
//		let menuController = MenuController(statusItem: statusItem)
//		let fileManager = MockFileManager()
//		let photoStorageService = MockPhotoStorageService(dataManager: StubDataManger(), fileManager: fileManager)
//		photoStorageService.resources = [
//			PhotoResource(url: .stub, fileURL: URL(fileURLWithPath: "/path/to/my/file")),
//			PhotoResource(url: .stub, fileURL: URL(fileURLWithPath: "/path/to/my/file2")),
//			PhotoResource(url: .stub, fileURL: URL(fileURLWithPath: "/path/to/my/file3"))
//		]
//		let photoController = PhotoController(photoAlbumService: StubPhotoAlbumService(), photoService: StubPhotoService(), photoStorageService: photoStorageService)
//		_ = AppController(preferencesController: StubPreferencesController(), workspaceController: StubWorkspaceController(), menuController: menuController, photoController: photoController, app: StubApplication())
//
//		// test
//		guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.clearFolder.rawValue) else {
//			XCTFail()
//			return
//		}
//		photoStorageService.resources?.forEach {
//			guard let url = $0.fileURL else {
//				XCTFail()
//				return
//			}
//			XCTAssertTrue(fileManager.urls.contains(url))
//		}
//	}
//
    func testPreferencesOpens() {
        // mocks
		let statusItem = MockLoadingStatusItem()
		let menuController = MenuController(statusItem: statusItem)
        let windowController = MockWindowController()
		windowController.contentViewController = MockPreferencesViewController()
        let preferencesController = PreferencesController(windowController: windowController, preferencesService: MockPreferencesService())
        _ = AppController.testable(preferencesController: preferencesController, menuController: menuController)

        // test
		guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.preferences.rawValue) else {
			XCTFail()
			return
		}
        XCTAssertTrue(windowController.invocations.isInvoked(MockWindowController.funcs.showWindow1))
    }

	func testChangePreferencesRestartsTimer() {
		XCTFail()
	}

	func testPreferencesSave() {
		XCTFail()
	}

	func testPreferencesLoad() {
		XCTFail()
	}

	func testSystemPreferencesOpens() {
		// mocks
		let statusItem = MockLoadingStatusItem()
		let menuController = MenuController(statusItem: statusItem)
		let workspace = MockWorkspace()
		let workspaceController = WorkspaceController(workspace: workspace)
		_ = AppController.testable(workspaceController: workspaceController, menuController: menuController)

		// test
		guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.systemPreferences.rawValue) else {
			XCTFail()
			return
		}
		XCTAssertEqual(workspace.invocations.findParameter(MockWorkspace.open1Parameters.url, inFunction: MockWorkspace.funcs.open1) as? URL, SystemPreference.desktopScreenEffects.url)
	}

	func testAboutOpens() {
		// mocks
		let statusItem = MockLoadingStatusItem()
		let menuController = MenuController(statusItem: statusItem)
		let app = MockApplication()
		_ = AppController.testable(menuController: menuController, app: app)

		// test
		guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.about.rawValue) else {
			XCTFail()
			return
		}
		XCTAssertTrue(app.invocations.isInvoked(MockApplication.funcs.orderFrontStandardAboutPanel1))
	}

	func testAppQuits() {
		// mocks
		let statusItem = MockLoadingStatusItem()
		let menuController = MenuController(statusItem: statusItem)
		let app = MockApplication()
		_ = AppController.testable(menuController: menuController, app: app)

		// test
		guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.quit.rawValue) else {
			XCTFail()
			return
		}
		XCTAssertTrue(app.invocations.isInvoked(MockApplication.funcs.terminate3))
	}
}

extension AppController {
	static func testable(
		preferencesController: PreferencesControllable = MockPreferencesController(),
		workspaceController: WorkspaceControllable = MockWorkspaceController(),
		menuController: MenuControllable = MockMenuController(),
		photoController: PhotoControllable = MockPhotoController(),
		app: Applicationable = MockApplication()) -> AppController {
			return AppController(
				preferencesController: preferencesController,
				workspaceController: workspaceController,
				menuController: menuController,
				photoController: photoController,
				app: app
		)
	}
}
