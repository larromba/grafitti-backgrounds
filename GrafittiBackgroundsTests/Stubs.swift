//
//  Stubs.swift
//  GrafittiBackgroundsTests
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa
@testable import Grafitti_Backgrounds

class StubPreferencesCoordinator: PreferencesCoordinatorInterface {
    var windowController: NSWindowControllerInterface = StubWindowController()
    var preferencesViewController: PreferencesViewControllerInterface = PreferencesViewController()
    var preferencesService: PreferencesServiceInterface = StubPreferencesService()
    var preferencesDataSource: PreferencesDataSourceInterface = PreferencesDataSource()
    var preferences = Preferences()
    var delegate: PreferencesCoordinatorDelegate?

    func open() {}
}

class StubPreferencesService: PreferencesServiceInterface {
    var dataManager: DataManagerInterface = StubDataManager()

    func save(_ preferences: Preferences) {}
    func load() -> Preferences? { return nil }
}

class StubDataManager: DataManagerInterface {
    func save(_ data: Data?, key: String) {}
    func load(key: String) -> Data? { return nil }
}

class StubWorkspaceCoordinator: WorkspaceCoordinatorInterface {
    var workspace: NSWorkspaceInterface = StubWorkspace()

    func open(_ preference: SystemPreference) {}
    func open(_ url: URL) {}
}

class StubWorkspace: NSWorkspaceInterface {
    func open(_ url: URL) -> Bool { return false }
}

class StubMenuCoordinator: MenuCoordinatorInterface {
    var statusItem: LoadingStatusItemInterface = StubLoadingStatusItem()
    var delegate: MenuCoordinatorDelegate?

    func setLoadingPercentage(_ percentage: Double) {}
    func setIsLoading(_ isLoading: Bool) {}
    func setRefreshAction(_ action: AppMenu.RefreshAction) {}
}

class StubLoadingStatusItem: LoadingStatusItemInterface {
    var statusBar: NSStatusBar = NSStatusBar()
    var item: NSStatusItem = NSStatusItem()
    var isLoading: Bool = false
    var loadingPercentage: Double = 0
}

class StubPhotoCoordinator: PhotoCoordinatorInterface {
    var photoAlbumService: PhotoAlbumServiceInterface = StubPhotoAlbumService()
    var photoService: PhotoServiceInterface = StubPhotoService()
    var photoStorageService: PhotoStorageServiceInterface = StubPhotoStorageService()
    var isDownloadInProgress: Bool = false
    var preferences: Preferences = Preferences()
    var folderURL: URL = URL.stub
    var delegate: PhotoCoordinatorDelegate?

    func reloadPhotos() {}
    func cancelReload() {}
    func cleanFolder() {}
}

class StubPhotoAlbumService: PhotoAlbumServiceInterface {
    var networkManager: NetworkManagerInterface = StubNetworkManager()

    func getPhotoAlbums(success: @escaping (([PhotoAlbum]) -> ()), failure: ((Error) -> ())?) {}
    func getPhotoResources(_ album: PhotoAlbum, success: @escaping (([PhotoResource]) -> ()), failure: ((Error) -> ())?) {}
    func cancelAll() {}
}

class StubNetworkManager: NetworkManagerInterface {
    func send(request: Request, success: @escaping ((Response) -> ()), failure: @escaping ((Error) -> ())) {}
    func download(_ url: URL, success: @escaping ((URL) -> ()), failure: @escaping ((Error) -> ())) {}
    func cancelAll() {}
}

class StubPhotoService: PhotoServiceInterface {
    var networkManager: NetworkManagerInterface = StubNetworkManager()
    var fileManager: FileManagerInterface = FileManager()
    var saveURL: URL = URL.stub

    func downloadPhoto(_ resource: PhotoResource, success: @escaping ((PhotoResource) -> ()), failure: ((Error) -> ())?) {}
    func cancelAll() {}
}

class StubPhotoStorageService: PhotoStorageServiceInterface {
    var dataManager: DataManagerInterface = StubDataManger()
    var fileManager: FileManagerInterface = FileManager()

    func save(_ resources: [PhotoResource]) {}
    func load() -> [PhotoResource]? { return nil }
    func remove(_ resources: [PhotoResource]) {}
}

class StubDataManger: DataManagerInterface {
    func save(_ data: Data?, key: String) {}
    func load(key: String) -> Data? { return nil }
}

class StubApplication: NSApplicationInterface {
    func orderFrontStandardAboutPanel(_ sender: Any?) {}
    func orderFrontStandardAboutPanel(options optionsDictionary: [NSApplication.AboutPanelOptionKey : Any]) {}
    func terminate(_ sender: Any?) {}
}

class StubWindowController: NSWindowControllerInterface {
    var contentViewController: NSViewController?

    func showWindow(_ sender: Any?) {}
    init(viewController: NSViewController? = NSViewController()) {
        contentViewController = viewController
    }
}

class StubPreferencesViewController: NSViewController, PreferencesViewControllerInterface {
    var autoRefreshCheckBoxTextLabel: NSTextField! = NSTextField()
    var autoRefreshCheckBox: NSButton! = NSButton()
    var autoRefreshIntervalTextLabel: NSTextField! = NSTextField()
    var autoRefreshIntervalTextField: NSTextField! = NSTextField()
    var numberOfPhotosTextLabel: NSTextField! = NSTextField()
    var numberOfPhotosTextField: NSTextField! = NSTextField()
    var delegate: PreferencesViewControllerDelegate? = nil
    var viewModel: PreferencesViewModel? = nil
}

extension URL {
    static var stub = URL(string: "http://www.google.com")!
}
