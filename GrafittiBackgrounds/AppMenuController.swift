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
    private var statusItem: LoadingStatusItemable
    private weak var delegate: AppMenuControllerDelegate?

    init(statusItem: LoadingStatusItemable) {
        self.statusItem = statusItem
        self.statusItem.menu = Menu(viewState:
            MenuViewState(title: "", autoenablesItems: false, items: AppMenu.defaultItems(delegate: self))
        )
    }

    func setLoadingPercentage(_ percentage: Double) {
        let viewState = LoadingStatusItemViewState(
            isLoading: statusItem.viewState.isLoading,
            loadingPercentage: percentage,
            style: statusItem.viewState.style
        )
        statusItem.viewState = viewState
    }

    func setIsLoading(_ isLoading: Bool) {
        let viewState = LoadingStatusItemViewState(
            isLoading: isLoading,
            loadingPercentage: statusItem.viewState.loadingPercentage,
            style: statusItem.viewState.style
        )
        statusItem.viewState = viewState
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
