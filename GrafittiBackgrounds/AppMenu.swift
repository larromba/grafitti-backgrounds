import Cocoa
import Foundation

enum AppMenu {
    enum Action {
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
        case help
        case contact
        case quit

        //TODO: localize
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
            case .help:
                return "Help".localized
            case .contact:
                return "Report Bug".localized
            case .quit:
                return "Quit".localized
            }
        }

        var keyEquivilent: String {
            return ""
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
        case help
        case contact
        case quit
    }

    // swiftlint:disable cyclomatic_complexity
    static func defaultItems<T: MenuItemDelegate>(delegate: T) -> [NSMenuItem] where T.ActionType == Action {
        var items = [NSMenuItem]()
        while let order = Order(rawValue: items.count) {
            let item: NSMenuItem
            switch order {
            case .refreshFolder:
                item = NSMenuItem.item(for: .refreshFolder(action: .refresh), delegate: delegate)
            case .openFolder:
                item = NSMenuItem.item(for: .openFolder, delegate: delegate)
            case .clearFolder:
                item = NSMenuItem.item(for: .clearFolder, delegate: delegate)
            case .separator1, .separator2:
                item = NSMenuItem.separator()
            case .preferences:
                item = NSMenuItem.item(for: .preferences, delegate: delegate)
            case .systemPreferences:
                item = NSMenuItem.item(for: .systemPreferences, delegate: delegate)
            case .about:
                item = NSMenuItem.item(for: .about, delegate: delegate)
            case .help:
                item = NSMenuItem.item(for: .help, delegate: delegate)
            case .contact:
                item = NSMenuItem.item(for: .contact, delegate: delegate)
            case .quit:
                item = NSMenuItem.item(for: .quit, delegate: delegate)
            }
            items += [item]
        }
        return items
    }
}

// MARK: - NSMenuItem

private extension NSMenuItem {
    static func item<T: MenuItemDelegate>(for action: AppMenu.Action,
                                          delegate: T) -> NSMenuItem where T.ActionType == AppMenu.Action {
        let viewState = MenuItemViewState(title: action.localizedTitle, keyEquivalent: "", isEnabled: true)
        return MenuItem<AppMenu.Action, T>(viewState: viewState, actionType: action, delegate: delegate)
    }
}
