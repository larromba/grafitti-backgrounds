 //
//  AppController.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

// sourcery: name = AppController
protocol AppControllable: Mockable {
    var preferencesController: PreferencesControllable { get }
    var workspaceController: WorkspaceControllable { get }
    var menuController: MenuControllable { get }
    var photoController: PhotoControllable { get }
    var app: Applicationable { get }

    func start()
}

final class AppController: AppControllable {
    private(set) var preferencesController: PreferencesControllable
    let workspaceController: WorkspaceControllable
    private(set) var menuController: MenuControllable
    private(set) var photoController: PhotoControllable
    let app: Applicationable

    init(preferencesController: PreferencesControllable, workspaceController: WorkspaceControllable, menuController: MenuControllable, photoController: PhotoControllable, app: Applicationable) {
        self.preferencesController = preferencesController
        self.workspaceController = workspaceController
        self.menuController = menuController
        self.photoController = photoController
        self.app = app

        self.preferencesController.delegate = self
        self.menuController.delegate = self
        self.photoController.delegate = self
        self.photoController.preferences = preferencesController.preferences
    }

    func start() {
        photoController.reloadPhotos()
    }
}

// MARK: - PreferencesControllerDelegate

extension AppController: PreferencesControllerDelegate {
    func preferencesController(_ coordinator: PreferencesController, didUpdatePreferences preferences: Preferences) {
        photoController.preferences = preferences
    }
}

// MARK: - MenuControllerDelegate

extension AppController: MenuControllerDelegate {
    func menuController(_ coordinator: MenuController, selected action: AppMenu.Action) {
        switch action {
        case .refreshFolder(action: .refresh):
            photoController.reloadPhotos()
		case .refreshFolder(action: .cancel):
            photoController.cancelReload()
        case .openFolder:
            workspaceController.open(photoController.folderURL)
        case .clearFolder:
            photoController.cleanFolder()
        case .preferences:
            preferencesController.open()
        case .systemPreferences:
            workspaceController.open(.desktopScreenEffects)
        case .about:
            app.orderFrontStandardAboutPanel(self)
        case .quit:
            app.terminate(self)
        }
    }
}

 // MARK: - PhotoControllerDelegate

extension AppController: PhotoControllerDelegate {
    func photoController(_ photoController: PhotoController, updatedDownloadPercentage percentage: Double) {
        menuController.setLoadingPercentage(percentage)
    }

    func photoController(_ photoController: PhotoController, didChangeDownloadState inProgress: Bool) {
        menuController.setRefreshAction(inProgress ? .cancel : .refresh)
        menuController.setIsLoading(inProgress)
    }
 }
