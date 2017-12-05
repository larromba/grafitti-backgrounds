 //
//  AppCoordinator.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

class AppCoordinator {
    private let preferencesCoordinator = PreferencesCoordinator()
    private let workspaceCoordinator = WorkspaceCoordinator()
    private let menuCoordinator = MenuCoordinator()
    private let photoCoordinator = PhotoCoordinator()
    private let app = NSApp

    init() {
        menuCoordinator.delegate = self
    }

    func start() {
        preferencesCoordinator.delegate = self
        menuCoordinator.delegate = self
        photoCoordinator.delegate = self
        photoCoordinator.preferences = preferencesCoordinator.preferences
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
    func menuCoordinator(_ coordinator: MenuCoordinator, selected action: MenuCoordinator.Action) {
        switch action {
        case .refreshFolder:
            photoCoordinator.reloadPhotos()
        case .cancelRefresh:
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
            app?.orderFrontStandardAboutPanel(self)
        case .quit:
            app?.terminate(self)
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
