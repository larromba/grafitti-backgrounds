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
	func testRefreshFolder() {
		// mocks
		class MockLoadingStatusItem: LoadingStatusItem {
			var loadingPercentages = [Double]()
			override var loadingPercentage: Double {
				get { return super.loadingPercentage }
				set { loadingPercentages.append(loadingPercentage ) }
			}
		}
		class MockPhotoAlbumService: StubPhotoAlbumService {
			var photoAlbums: [PhotoAlbum]!
			override func getPhotoAlbums(success: @escaping (([PhotoAlbum]) -> ()), failure: ((Error) -> ())?) {
				success(photoAlbums)
			}
		}
		class MockNetworkManager: StubNetworkManager {
			override func send(request: Request, success: @escaping ((Response) -> ()), failure: @escaping ((Error) -> ())) {
				success(PhotoResponse(imageURL: .stub))
			}
			var downloadURL: URL!
			override func download(_ url: URL, success: @escaping ((URL) -> ()), failure: @escaping ((Error) -> ())) {
				success(downloadURL)
			}
		}
		class MockFileManager: StubFileManager {
			var srcURLs = [URL]()
			var dstURLs = [URL]()
			override func moveItem(at srcURL: URL, to dstURL: URL) throws {
				srcURLs.append(srcURL)
				dstURLs.append(dstURL)
			}
		}
		let statusItem = MockLoadingStatusItem(viewModel: LoadingStatusItemViewModel(isLoading: false, loadingPercentage: 0, style: .sprayCan), statusBar: .system)
		let menuCoordinator = MenuCoordinator(statusItem: statusItem)
		let networkManager = MockNetworkManager()
		networkManager.downloadURL = URL(fileURLWithPath: "/some/place/file.tmp")
		let fileManager = MockFileManager()
		let saveURL = URL(fileURLWithPath: "/some/place")
		let photoService = PhotoService(networkManager: networkManager, fileManager: fileManager, saveURL: saveURL)
		let photoAlbumService = MockPhotoAlbumService()
		photoAlbumService.photoAlbums = [PhotoAlbum(url: .stub, resources: [
			PhotoResource(url: .stub, fileURL: .stub)
			])]
		let preferences = Preferences(isAutoRefreshEnabled: false, autoRefreshTimeIntervalHours: 0, numberOfPhotos: 1)
		let photoCoordinator = PhotoCoordinator(photoAlbumService: photoAlbumService, photoService: photoService, photoStorageService: StubPhotoStorageService(), preferences: preferences)
		let preferencesCoordinator = StubPreferencesCoordinator()
		preferencesCoordinator.preferences = Preferences(isAutoRefreshEnabled: false, autoRefreshTimeIntervalHours: 0, numberOfPhotos: 1)
		_ = AppCoordinator(preferencesCoordinator: preferencesCoordinator, workspaceCoordinator: StubWorkspaceCoordinator(), menuCoordinator: menuCoordinator, photoCoordinator: photoCoordinator, app: StubApplication())

		// test
		guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.refreshFolder.rawValue) else {
			XCTFail()
			return
		}
		photoAlbumService.photoAlbums?.forEach { _ in
			XCTAssertTrue(fileManager.srcURLs.contains(networkManager.downloadURL))
			XCTAssertTrue(fileManager.dstURLs.contains(saveURL.appendingPathComponent("file.png")))
		}
	}

	func testOpenFolder() {
		// mocks
		class MockPhotoService: StubPhotoService {
			override var saveURL: URL {
				get { return URL(fileURLWithPath: "path/to/my/folder") }
				set {}
			}
		}
		class MockWorkspace: NSWorkspaceInterface {
			var urlOpened: URL?
			func open(_ url: URL) -> Bool {
				urlOpened = url
				return true
			}
		}
		let statusItem = StubLoadingStatusItem()
		let menuCoordinator = MenuCoordinator(statusItem: statusItem)
		let photoService = MockPhotoService()
		let photoCoordinator = PhotoCoordinator(photoAlbumService: StubPhotoAlbumService(), photoService: photoService, photoStorageService: StubPhotoStorageService())
		let workspace = MockWorkspace()
		let workspaceCoordinator = WorkspaceCoordinator(workspace: workspace)
		_ = AppCoordinator(preferencesCoordinator: StubPreferencesCoordinator(), workspaceCoordinator: workspaceCoordinator, menuCoordinator: menuCoordinator, photoCoordinator: photoCoordinator, app: StubApplication())

		// test
		guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.openFolder.rawValue) else {
			XCTFail()
			return
		}
		XCTAssertEqual(workspace.urlOpened, photoService.saveURL)
	}

	func testClearFolder() {
		// mocks
		class MockFileManager: StubFileManager {
			var urls = [URL]()
			override func removeItem(at URL: URL) throws {
				urls.append(URL)
			}
		}
		class MockPhotoStorageService: PhotoStorageService {
			var resources: [PhotoResource]?
			override func load() -> [PhotoResource]? {
				return resources
			}
		}
		let statusItem = StubLoadingStatusItem()
		let menuCoordinator = MenuCoordinator(statusItem: statusItem)
		let fileManager = MockFileManager()
		let photoStorageService = MockPhotoStorageService(dataManager: StubDataManger(), fileManager: fileManager)
		photoStorageService.resources = [
			PhotoResource(url: .stub, fileURL: URL(fileURLWithPath: "/path/to/my/file")),
			PhotoResource(url: .stub, fileURL: URL(fileURLWithPath: "/path/to/my/file2")),
			PhotoResource(url: .stub, fileURL: URL(fileURLWithPath: "/path/to/my/file3"))
		]
		let photoCoordinator = PhotoCoordinator(photoAlbumService: StubPhotoAlbumService(), photoService: StubPhotoService(), photoStorageService: photoStorageService)
		_ = AppCoordinator(preferencesCoordinator: StubPreferencesCoordinator(), workspaceCoordinator: StubWorkspaceCoordinator(), menuCoordinator: menuCoordinator, photoCoordinator: photoCoordinator, app: StubApplication())

		// test
		guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.clearFolder.rawValue) else {
			XCTFail()
			return
		}
		photoStorageService.resources?.forEach {
			guard let url = $0.fileURL else {
				XCTFail()
				return
			}
			XCTAssertTrue(fileManager.urls.contains(url))
		}
	}

    func testOpenPreferences() {
        // mocks
        class MockWindowController: StubWindowController {
            var didShowWindow = false
            override func showWindow(_ sender: Any?) {
                didShowWindow = true
            }
        }
        let statusItem = StubLoadingStatusItem()
        let menuCoordinator = MenuCoordinator(statusItem: statusItem)
        let windowController = MockWindowController(viewController: StubPreferencesViewController())
        let preferencesCoordinator = PreferencesCoordinator(windowController: windowController, preferencesService: StubPreferencesService())
        _ = AppCoordinator(preferencesCoordinator: preferencesCoordinator, workspaceCoordinator: StubWorkspaceCoordinator(), menuCoordinator: menuCoordinator, photoCoordinator: StubPhotoCoordinator(), app: StubApplication())

        // test
		guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.preferences.rawValue) else {
			XCTFail()
			return
		}
        XCTAssertTrue(windowController.didShowWindow)
    }

	func testChangePreferences() {
		XCTFail()
	}

    func testOpenSystemPreferences() {
        // mocks
		class MockWorkspace: NSWorkspaceInterface {
			var urlOpened: URL?
			func open(_ url: URL) -> Bool {
				urlOpened = url
				return true
			}
		}
		let statusItem = StubLoadingStatusItem()
		let menuCoordinator = MenuCoordinator(statusItem: statusItem)
		let workspace = MockWorkspace()
        let workspaceCoordinator = WorkspaceCoordinator(workspace: workspace)
        _ = AppCoordinator(preferencesCoordinator: StubPreferencesCoordinator(), workspaceCoordinator: workspaceCoordinator, menuCoordinator: menuCoordinator, photoCoordinator: StubPhotoCoordinator(), app: StubApplication())

        // test
		guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.systemPreferences.rawValue) else {
			XCTFail()
			return
		}
        XCTAssertEqual(workspace.urlOpened, SystemPreference.desktopScreenEffects.url)
    }
    
    func testOpenAbout() {
        // mocks
        class MockApplication: StubApplication {
            var didShowAbout = false
            override func orderFrontStandardAboutPanel(_ sender: Any?) {
                didShowAbout = true
            }
        }
        let statusItem = StubLoadingStatusItem()
        let menuCoordinator = MenuCoordinator(statusItem: statusItem)
        let app = MockApplication()
        _ = AppCoordinator(preferencesCoordinator: StubPreferencesCoordinator(), workspaceCoordinator: StubWorkspaceCoordinator(), menuCoordinator: menuCoordinator, photoCoordinator: StubPhotoCoordinator(), app: app)

        // test
		guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.about.rawValue) else {
			XCTFail()
			return
		}
        XCTAssertTrue(app.didShowAbout)
    }

    func testQuit() {
        // mocks
        class MockApplication: StubApplication {
            var didTerminate = false
            override func terminate(_ sender: Any?) {
                didTerminate = true
            }
        }
        let statusItem = StubLoadingStatusItem()
        let menuCoordinator = MenuCoordinator(statusItem: statusItem)
        let app = MockApplication()
        _ = AppCoordinator(preferencesCoordinator: StubPreferencesCoordinator(), workspaceCoordinator: StubWorkspaceCoordinator(), menuCoordinator: menuCoordinator, photoCoordinator: StubPhotoCoordinator(), app: app)

        // test
		guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.quit.rawValue) else {
			XCTFail()
			return
		}
        XCTAssertTrue(app.didTerminate)
    }
}
