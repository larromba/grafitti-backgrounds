import Cocoa

protocol AppMenuControllerDelegate: AnyObject {
    func menuController(_ controller: AppMenuController, selected action: AppMenu.Action)
}

// sourcery: name = AppMenuController
protocol AppMenuControllable: Mockable {
    func setLoadingPercentage(_ percentage: Double)
    func setIsLoading(_ isLoading: Bool)
    func setRefreshAction(_ action: AppMenu.Action.Refresh)
    func setDelegate(_ delegate: AppMenuControllerDelegate)
}

final class AppMenuController: AppMenuControllable {
    private let statusItem: LoadingStatusItemable
    private let reachability: Reachable
    private weak var delegate: AppMenuControllerDelegate?

    init(statusItem: LoadingStatusItemable, reachability: Reachable) {
        self.statusItem = statusItem
        self.reachability = reachability
        self.statusItem.menu = Menu(viewState:
            MenuViewState(title: "", autoenablesItems: false, items: AppMenu.defaultItems(delegate: self))
        )
        reachability.setDelegate(self)
    }

    func setLoadingPercentage(_ percentage: Double) {
        statusItem.viewState = statusItem.viewState.copy(loadingPercentage: percentage)
    }

    func setIsLoading(_ isLoading: Bool) {
        statusItem.viewState = statusItem.viewState.copy(isLoading: isLoading)
    }

    func setRefreshAction(_ action: AppMenu.Action.Refresh) {
        typealias MenuItemType = MenuItem<AppMenu.Action, AppMenuController>
        guard
            let refreshItem: MenuItemType = statusItem.item(at: AppMenu.Order.refreshFolder.rawValue),
            let clearFolderItem: MenuItemType = statusItem.item(at: AppMenu.Order.clearFolder.rawValue) else {
                return
        }
        switch action {
        case .refresh:
            let action = AppMenu.Action.refreshFolder(action: .refresh)
            refreshItem.actionType = action
            refreshItem.viewState = MenuItemViewState(
                title: action.localizedTitle,
                keyEquivalent: action.keyEquivilent,
                isEnabled: true
            )
            clearFolderItem.viewState = clearFolderItem.viewState.copy(isEnabled: true)
        case .cancel:
            let action = AppMenu.Action.refreshFolder(action: .cancel)
            refreshItem.actionType = action
            refreshItem.viewState = MenuItemViewState(
                title: action.localizedTitle,
                keyEquivalent: action.keyEquivilent,
                isEnabled: true
            )
            clearFolderItem.viewState = clearFolderItem.viewState.copy(isEnabled: false)
        }
    }

    func setDelegate(_ delegate: AppMenuControllerDelegate) {
        self.delegate = delegate
    }
}

// MARK: - MenuItemDelegate

extension AppMenuController: MenuItemDelegate {
    typealias ActionType = AppMenu.Action

    func menuItemPressed<T: MenuItemable>(_ menuItem: T) where T.ActionType == ActionType {
        delegate?.menuController(self, selected: menuItem.actionType)
    }
}

// MARK: - ReachabilityDelegate

extension AppMenuController: ReachabilityDelegate {
    func reachabilityDidChange(_ reachability: Reachable, isReachable: Bool) {
        statusItem.viewState = statusItem.viewState.copy(alpha: isReachable ? 1.0 : 0.5)
    }
}
