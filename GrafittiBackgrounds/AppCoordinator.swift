 //
//  AppCoordinator.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

protocol AppCoordinatorInterface {
    var preferencesCoordinator: PreferencesCoordinatorInterface { get }
    var workspaceCoordinator: WorkspaceCoordinatorInterface { get }
    var menuCoordinator: MenuCoordinatorInterface { get }
    var photoCoordinator: PhotoCoordinatorInterface { get }
    var app: NSApplicationInterface { get }

    func start()
}

class AppCoordinator: AppCoordinatorInterface {
    var preferencesCoordinator: PreferencesCoordinatorInterface
    let workspaceCoordinator: WorkspaceCoordinatorInterface
    var menuCoordinator: MenuCoordinatorInterface
    var photoCoordinator: PhotoCoordinatorInterface
    let app: NSApplicationInterface

    init(preferencesCoordinator: PreferencesCoordinatorInterface, workspaceCoordinator: WorkspaceCoordinatorInterface, menuCoordinator: MenuCoordinatorInterface, photoCoordinator: PhotoCoordinatorInterface, app: NSApplicationInterface) {
        self.preferencesCoordinator = preferencesCoordinator
        self.workspaceCoordinator = workspaceCoordinator
        self.menuCoordinator = menuCoordinator
        self.photoCoordinator = photoCoordinator
        self.app = app

        self.preferencesCoordinator.delegate = self
        self.menuCoordinator.delegate = self
        self.photoCoordinator.delegate = self
        self.photoCoordinator.preferences = preferencesCoordinator.preferences
    }

    func start() {
        photoCoordinator.reloadPhotos()
    }
}

// MARK: - PreferencesCoordinatorDelegate

extension AppCoordinator: PreferencesCoordinatorDelegate {
    func preferencesCoordinator(_ coordinator: PreferencesCoordinator, didUpdatePreferences preferences: Preferences) {
        photoCoordinator.preferences = preferences
    }
}

// MARK: - MenuCoordinatorDelegate

extension AppCoordinator: MenuCoordinatorDelegate {
    func menuCoordinator(_ coordinator: MenuCoordinator, selected action: AppMenu.Action) {
        switch action {
        case .refreshFolder(action: .refresh):
            photoCoordinator.reloadPhotos()
		case .refreshFolder(action: .cancel):
            photoCoordinator.cancelReload()
        case .openFolder:
            workspaceCoordinator.open(photoCoordinator.folderURL)
        case .clearFolder:
            photoCoordinator.cleanFolder()
        case .preferences:
            preferencesCoordinator.open()
        case .systemPreferences:
            workspaceCoordinator.open(.desktopScreenEffects)
        case .about:
            app.orderFrontStandardAboutPanel(self)
        case .quit:
            app.terminate(self)
        }
    }
}

 // MARK: - PhotoCoordinatorDelegate

extension AppCoordinator: PhotoCoordinatorDelegate {
    func photoCoordinator(_ photoCoordinator: PhotoCoordinator, updatedDownloadPercentage percentage: Double) {
        menuCoordinator.setLoadingPercentage(percentage)
    }

    func photoCoordinator(_ photoCoordinator: PhotoCoordinator, didChangeDownloadState inProgress: Bool) {
        menuCoordinator.setRefreshAction(inProgress ? .cancel : .refresh)
        menuCoordinator.setIsLoading(inProgress)
    }
 }
