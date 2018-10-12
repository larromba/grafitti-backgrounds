//
//  MenuController.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 05/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

protocol MenuControllerDelegate: class {
    func menuController(_ coordinator: MenuController, selected action: AppMenu.Action)
}

// sourcery: name = MenuController
protocol MenuControllable: Mockable {
    var statusItem: LoadingStatusItemable { get }
    var delegate: MenuControllerDelegate? { get set }

    func setLoadingPercentage(_ percentage: Double)
    func setIsLoading(_ isLoading: Bool)
    func setRefreshAction(_ action: AppMenu.Action.Refresh)
}

final class MenuController: MenuControllable {
    private(set) var statusItem: LoadingStatusItemable
    weak var delegate: MenuControllerDelegate?

    init(statusItem: LoadingStatusItemable) {
        self.statusItem = statusItem
		statusItem.item.menu = Menu(
			viewModel: MenuViewModel(title: "", autoenablesItems: false),
			items: AppMenu.items(delegate: self)
		)
    }

    func setLoadingPercentage(_ percentage: Double) {
		let viewModel = LoadingStatusItemViewModel(isLoading: statusItem.viewModel.isLoading, loadingPercentage: percentage, style: statusItem.viewModel.style)
        statusItem.viewModel = viewModel
    }

    func setIsLoading(_ isLoading: Bool) {
		let viewModel = LoadingStatusItemViewModel(isLoading: isLoading, loadingPercentage: statusItem.viewModel.loadingPercentage, style: statusItem.viewModel.style)
        statusItem.viewModel = viewModel
    }

    func setRefreshAction(_ action: AppMenu.Action.Refresh) {
        guard let refreshItem = statusItem.item.menu?.item(at: 0) as? MenuItem, let clearFolderItem = statusItem.item.menu?.item(at: 2) as? MenuItem else {
            return
        }
        switch action {
        case .refresh:
			let action = AppMenu.Action.refreshFolder(action: .refresh)
			refreshItem.viewModel = MenuItemViewModel(title: action.localizedTitle, action: action)

			let viewModel = MenuItemViewModel(title: clearFolderItem.viewModel.title, keyEquivalent: clearFolderItem.viewModel.keyEquivalent, isEnabled: true, menuAction: clearFolderItem.viewModel.menuAction)
			clearFolderItem.viewModel = viewModel
        case .cancel:
			let action = AppMenu.Action.refreshFolder(action: .cancel)
			refreshItem.viewModel = MenuItemViewModel(title: action.localizedTitle, action: action)

			let viewModel = MenuItemViewModel(title: clearFolderItem.viewModel.title, keyEquivalent: clearFolderItem.viewModel.keyEquivalent, isEnabled: false, menuAction: clearFolderItem.viewModel.menuAction)
            clearFolderItem.viewModel = viewModel
        }
    }
}

// MARK: - MenuItemDelegate

extension MenuController: MenuItemDelegate {
	func menuItemPressed(_ menuItem: MenuItemable) {
		guard let action = menuItem.viewModel.menuAction as? AppMenu.Action else { return }
		delegate?.menuController(self, selected: action)
	}
}
