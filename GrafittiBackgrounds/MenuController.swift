import Cocoa

protocol MenuControllerDelegate: AnyObject {
    func menuController(_ controller: MenuController, selected action: AppMenu.Action)
}

// sourcery: name = MenuController
protocol MenuControllable: Mockable {
    func setLoadingPercentage(_ percentage: Double)
    func setIsLoading(_ isLoading: Bool)
    func setRefreshAction(_ action: AppMenu.Action.Refresh)
    func setDelegate(_ delegate: MenuControllerDelegate)
}

final class MenuController: MenuControllable {
    private var statusItem: LoadingStatusItemable
    private weak var delegate: MenuControllerDelegate?

    init(statusItem: LoadingStatusItemable) {
        self.statusItem = statusItem
        self.statusItem.menu = Menu(
            viewState: MenuViewState(title: "", autoenablesItems: false),
            items: AppMenu.items(delegate: self)
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
        let order = AppMenu.Order.self
        guard
            var refreshItem = statusItem.item(at: order.refreshFolder.rawValue),
            var clearFolderItem = statusItem.item(at: order.clearFolder.rawValue) else {
                return
        }
        switch action {
        case .refresh:
            let action = AppMenu.Action.refreshFolder(action: .refresh)
            refreshItem.setMenuAction(action)
            refreshItem.viewState = MenuItemViewState(
                title: action.localizedTitle,
                keyEquivalent: action.keyEquivilent,
                isEnabled: true
            )
            clearFolderItem.viewState = clearFolderItem.viewState.copyWithIsEnabled(true)
        case .cancel:
            let action = AppMenu.Action.refreshFolder(action: .cancel)
            refreshItem.setMenuAction(action)
            refreshItem.viewState = MenuItemViewState(
                title: action.localizedTitle,
                keyEquivalent: action.keyEquivilent,
                isEnabled: true
            )
            clearFolderItem.viewState = clearFolderItem.viewState.copyWithIsEnabled(false)
        }
    }

    func setDelegate(_ delegate: MenuControllerDelegate) {
        self.delegate = delegate
    }
}

// MARK: - MenuItemDelegate

extension MenuController: MenuItemDelegate {
    func menuItemPressed(_ menuItem: MenuItemable) {
		// TODO: better way of doing this?
        guard let action = menuItem.menuAction as? AppMenu.Action else {
            assertionFailure("expected AppMenu.Action")
            return
        }
        delegate?.menuController(self, selected: action)
    }
}
