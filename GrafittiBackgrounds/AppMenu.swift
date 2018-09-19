//
//  AppMenu.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 08/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Foundation
import Cocoa

enum AppMenu {
	enum Action: MenuAction {
		enum Refresh {
			case cancel
			case refresh
		}
		case refreshFolder(action: Refresh)
        case openFolder
        case clearFolder
        case preferences
        case systemPreferences
        case about
        case quit

		var localizedTitle: String {
			switch self {
			case .refreshFolder(action: .cancel):
				return "Cancel Refresh".localized
			case .refreshFolder(action: .refresh):
				return "Refresh Folder".localized
			case .openFolder:
				return "Open Folder".localized
			case .clearFolder:
				return "Clear Folder".localized
			case .preferences:
				return "Preferences".localized
			case .systemPreferences:
				return "System Preferences".localized
			case .about:
				return "About".localized
			case .quit:
				return "Quit".localized
			}
		}
    }
	enum Order: Int {
		case refreshFolder
		case openFolder
		case clearFolder
		case separator1
		case preferences
		case systemPreferences
		case separator2
		case about
		case quit
	}

	static func items(delegate: MenuItemDelegate) -> [NSMenuItem] {
		var index = 0
		var items = [NSMenuItem]()
		while let order = Order(rawValue: index) {
			let item: NSMenuItem
			switch order {
			case .refreshFolder:
				item = NSMenuItem.item(for: Action.refreshFolder(action: .refresh), delegate: delegate)
			case .openFolder:
				item = NSMenuItem.item(for: Action.openFolder, delegate: delegate)
			case .clearFolder:
				item = NSMenuItem.item(for: Action.clearFolder, delegate: delegate)
			case .separator1, .separator2:
				item = NSMenuItem.separator()
			case .preferences:
				item = NSMenuItem.item(for: Action.preferences, delegate: delegate)
			case .systemPreferences:
				item = NSMenuItem.item(for: Action.systemPreferences, delegate: delegate)
			case .about:
				item = NSMenuItem.item(for: Action.about, delegate: delegate)
			case .quit:
				item = NSMenuItem.item(for: Action.quit, delegate: delegate)
			}
			items += [item]
			index += 1
		}
		return items
	}
}

// MARK: - private

private extension NSMenuItem {
	static func item(for action: AppMenu.Action, delegate: MenuItemDelegate) -> NSMenuItem {
		let viewModel = MenuItemViewModel(
			title:  action.localizedTitle,
			action: action
		)
		return MenuItem(viewModel: viewModel, delegate: delegate)
	}
}
