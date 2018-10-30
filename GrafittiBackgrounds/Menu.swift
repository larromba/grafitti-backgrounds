import Cocoa

// sourcery: name = Menu
protocol Menuable: Mockable {
    var viewState: MenuViewState { get set }

    func item(at index: Int) -> MenuItemable?
}

class Menu: NSMenu, Menuable {
    var viewState: MenuViewState {
        didSet {
            update(viewState: viewState)
        }
    }

    init(viewState: MenuViewState, items: [NSMenuItem]) {
        self.viewState = viewState
        super.init(title: viewState.title)
        items.forEach { addItem($0) }
    }

    @available(*, unavailable)
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func item(at index: Int) -> MenuItemable? {
        guard index >= items.startIndex, index < items.endIndex else {
            return nil
        }
        return items[index] as? MenuItemable
    }

    // MARK: - private

    private func update(viewState: MenuViewState) {
        title = viewState.title
        autoenablesItems = viewState.autoenablesItems
    }
}
