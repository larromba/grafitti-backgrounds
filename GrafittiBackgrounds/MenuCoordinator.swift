//
//  MenuCoordinator.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 05/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

protocol MenuCoordinatorDelegate: class {
    func menuCoordinator(_ coordinator: MenuCoordinator, selected action: AppMenu.Action)
}

protocol MenuCoordinatorInterface {
    var statusItem: LoadingStatusItemInterface { get }
    var delegate: MenuCoordinatorDelegate? { get set }

    func setLoadingPercentage(_ percentage: Double)
    func setIsLoading(_ isLoading: Bool)
    func setRefreshAction(_ action: AppMenu.RefreshAction)
}

class MenuCoordinator: MenuCoordinatorInterface {
    var statusItem: LoadingStatusItemInterface
    weak var delegate: MenuCoordinatorDelegate?

    init(statusItem: LoadingStatusItemInterface) {
        self.statusItem = statusItem
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
        statusItem.loadingPercentage = percentage
    }

    func setIsLoading(_ isLoading: Bool) {
        statusItem.isLoading = isLoading
    }

    func setRefreshAction(_ action: AppMenu.RefreshAction) {
        guard let refreshItem = statusItem.item.menu?.item(at: 0) as? MenuItem , let clearFolderItem = statusItem.item.menu?.item(at: 2) else {
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
