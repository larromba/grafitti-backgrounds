//
//  AppDelegate+Configurator.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

extension AppDelegate {
    static func configure(for app: NSApplication) -> AppDelegate {
        let preferencesWindow = NSStoryboard.preferences.instantiateInitialController() as! NSWindowController
        let dataManager = DataManger()
        let preferencesService = PreferencesService(dataManager: dataManager)
        let preferencesCoordinator = PreferencesCoordinator(windowController: preferencesWindow, preferencesService: preferencesService)

        let workspace = NSWorkspace.shared
        let workspaceCoordinator = WorkspaceCoordinator(workspace: workspace)

		let viewModel = LoadingStatusItemViewModel(isLoading: false, loadingPercentage: 0, style: .sprayCan)
		let statusItem = LoadingStatusItem(viewModel: viewModel, statusBar: .system)
        let menuCoordinator = MenuCoordinator(statusItem: statusItem)

        let networkManager = NetworkManager()
        let fileManager = FileManager.default
        let photoAlbumService = PhotoAlbumService(networkManager: networkManager)

		// TODO: url chooser?
		guard let path = NSSearchPathForDirectoriesInDomains(.picturesDirectory, .userDomainMask, true).first else {
			fatalError("shouldn't be nil")
		}
		let saveURL = URL(fileURLWithPath: path).appendingPathComponent("GrafittiBackgrounds")

		let photoService = PhotoService(networkManager: networkManager, fileManager: fileManager, saveURL: saveURL)
        let photoStorageService = PhotoStorageService(dataManager: dataManager, fileManager: fileManager)
        let photoCoordinator = PhotoCoordinator(photoAlbumService: photoAlbumService, photoService: photoService, photoStorageService: photoStorageService)

        let appCoordinator = AppCoordinator(preferencesCoordinator: preferencesCoordinator, workspaceCoordinator: workspaceCoordinator, menuCoordinator: menuCoordinator, photoCoordinator: photoCoordinator, app: app)
        let appDelegate = AppDelegate(appCoordinator: appCoordinator)
        return appDelegate
    }
}
