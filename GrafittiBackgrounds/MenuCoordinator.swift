//
//  MenuCoordinator.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 05/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

protocol MenuCoordinatorDelegate: class {
    func menuCoordinator(_ coordinator: MenuCoordinator, selected action: MenuCoordinator.Action)
}

class MenuCoordinator {
    enum Action {
        case refreshFolder
        case cancelRefresh
        case openFolder
        case clearFolder
        case preferences
        case systemPreferences
        case about
        case quit
    }
    enum RefreshAction {
        case cancel
        case refresh
    }

    private let statusItem = StatusItem(config:
        StatusItem.Config(image: #imageLiteral(resourceName: "spray-can"), loadingImage: #imageLiteral(resourceName: "download"), spinnerColor: NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8))
    )

    weak var delegate: MenuCoordinatorDelegate?

    init() {
        statusItem.item.menu = Menu(title: "", items: [
            MenuItem(title: "Refresh Folder".localized, actionBlock: { [unowned self] in
                self.delegate?.menuCoordinator(self, selected: .refreshFolder)
            }),
            MenuItem(title: "Open Folder".localized, actionBlock: { [unowned self] in
                self.delegate?.menuCoordinator(self, selected: .openFolder)
            }),
            MenuItem(title: "Clear Folder".localized, actionBlock: { [unowned self] in
                self.delegate?.menuCoordinator(self, selected: .clearFolder)
            }),
            NSMenuItem.separator(),
            MenuItem(title: "Preferences".localized, actionBlock: { [unowned self] in
                self.delegate?.menuCoordinator(self, selected: .preferences)
            }),
            MenuItem(title: "System Preferences".localized, actionBlock: { [unowned self] in
                self.delegate?.menuCoordinator(self, selected: .systemPreferences)
            }),
            NSMenuItem.separator(),
            MenuItem(title: "About".localized, actionBlock: { [unowned self] in
                self.delegate?.menuCoordinator(self, selected: .about)
            }),
            MenuItem(title: "Quit".localized, actionBlock: { [unowned self] in
                self.delegate?.menuCoordinator(self, selected: .quit)
            })
        ])
    }

    func setLoadingPercentage(_ percentage: Double) {
        self.statusItem.loadingPercentage = percentage
    }

    func setIsLoading(_ isLoading: Bool) {
        self.statusItem.isLoading = isLoading
    }

    func setRefreshAction(_ action: RefreshAction) {
        guard let refreshItem = self.statusItem.item.menu?.item(at: 0) as? MenuItem , let clearFolderItem = self.statusItem.item.menu?.item(at: 2) else {
            return
        }
        switch action {
        case .refresh:
            refreshItem.actionBlock = { [unowned self] in
                self.delegate?.menuCoordinator(self, selected: .refreshFolder)
            }
            refreshItem.title = "Refresh Folder".localized
            clearFolderItem.isEnabled = true
        case .cancel:
            refreshItem.actionBlock = { [unowned self] in
                self.delegate?.menuCoordinator(self, selected: .cancelRefresh)
            }
            refreshItem.title = "Cancel Refresh".localized
            clearFolderItem.isEnabled = false
        }
    }
}
