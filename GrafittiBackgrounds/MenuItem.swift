import Cocoa
import Foundation

// sourcery: name = MenuItem
protocol MenuItemable: Mockable {
    var menuAction: MenuAction { get }
    var viewState: MenuItemViewState { get set }

    func setDelegate(_ delegate: MenuItemDelegate)
    func setMenuAction(_ menuAction: MenuAction)
}

protocol MenuItemDelegate: AnyObject {
    func menuItemPressed(_ menuItem: MenuItemable)
}

final class MenuItem: NSMenuItem, MenuItemable {
    weak var delegate: MenuItemDelegate?
    private(set) var menuAction: MenuAction
    var viewState: MenuItemViewState {
        didSet {
            refresh(viewState: viewState)
        }
    }

    init(viewState: MenuItemViewState, menuAction: MenuAction, delegate: MenuItemDelegate) {
        self.delegate = delegate
        self.menuAction = menuAction
        self.viewState = viewState
        super.init(title: viewState.title, action: #selector(action(_:)), keyEquivalent: viewState.keyEquivalent)
        self.target = self
    }

    @available(*, unavailable)
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setMenuAction(_ menuAction: MenuAction) {
        self.menuAction = menuAction
    }

    func setDelegate(_ delegate: MenuItemDelegate) {
        self.delegate = delegate
    }

    // MARK: - private

    @objc
    private func action(_ sender: NSMenuItem) {
        delegate?.menuItemPressed(self)
    }

    private func refresh(viewState: MenuItemViewState) {
        self.title = viewState.title
        self.keyEquivalent = viewState.keyEquivalent
        self.isEnabled = viewState.isEnabled
    }
}
