//
//  AppDelegate+Configurator.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

extension AppDelegate {
    static func configure(for app: NSApplication) -> AppDelegatable {
        let preferencesWindow = NSStoryboard.preferences.instantiateInitialController() as! NSWindowController
        let dataManager = DataManger()
        let preferencesService = PreferencesService(dataManager: dataManager)
        let preferencesController = PreferencesController(windowController: preferencesWindow, preferencesService: preferencesService)

        let workspace = NSWorkspace.shared
        let workspaceController = WorkspaceController(workspace: workspace)

		let viewModel = LoadingStatusItemViewModel(isLoading: false, loadingPercentage: 0, style: .sprayCan)
		let statusItem = LoadingStatusItem(viewModel: viewModel, statusBar: .system)
        let menuController = MenuController(statusItem: statusItem)

        let networkManager = NetworkManager()
        let fileManager = FileManager.default
		let photoAlbumService = PhotoAlbumService(networkManager: networkManager)
		let photoService = PhotoService(networkManager: networkManager, fileManager: fileManager, saveURL: .defaultSaveLocation)
        let photoStorageService = PhotoStorageService(dataManager: dataManager, fileManager: fileManager)
        let photoController = PhotoController(photoAlbumService: photoAlbumService, photoService: photoService, photoStorageService: photoStorageService)

        let appController = AppController(preferencesController: preferencesController, workspaceController: workspaceController, menuController: menuController, photoController: photoController, app: app)
        let appDelegate = AppDelegate(appController: appController)
        return appDelegate
    }
}

// MARK: - URL Helper

private extension URL {
	static var defaultSaveLocation: URL {
		guard let path = NSSearchPathForDirectoriesInDomains(.picturesDirectory, .userDomainMask, true).first else {
			assertionFailure("shouldn't be nil")
			return URL(string: "file://")!
		}
		let url = URL(fileURLWithPath: path).appendingPathComponent("GrafittiBackgrounds")
		return url
	}
}
