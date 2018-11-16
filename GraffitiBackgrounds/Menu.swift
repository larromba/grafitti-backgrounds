import Cocoa

// sourcery: name = Menu
protocol Menuable: Mockable {
    var viewState: MenuViewState { get set }

    func item<T: MenuItemable>(at index: Int) -> T?
}

final class Menu: NSMenu, Menuable {
    var viewState: MenuViewState {
        didSet {
            update(viewState: viewState)
        }
    }

    init(viewState: MenuViewState) {
        self.viewState = viewState
        super.init(title: viewState.title)
        update(viewState: viewState)
    }

    @available(*, unavailable)
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func item<T: MenuItemable>(at index: Int) -> T? {
        return items[safe: index] as? T
    }

    // MARK: - private

    private func update(viewState: MenuViewState) {
        title = viewState.title
        autoenablesItems = viewState.autoenablesItems
        setItems(viewState.items)
    }

    private func setItems(_ items: [NSMenuItem]) {
        removeAllItems()
        items.forEach { addItem($0) }
    }
}
