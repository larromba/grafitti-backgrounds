import Cocoa
import Foundation

// sourcery: name = MenuItem
// sourcery: associatedtype = ActionType
// sourcery: associatedtype = DelegateType
protocol MenuItemable: Mockable {
    associatedtype ActionType
    associatedtype DelegateType

    var actionType: ActionType { get set }
    var viewState: MenuItemViewStating { get set }

    func setDelegate(_ delegate: DelegateType)
}

protocol MenuItemDelegate: AnyObject {
    associatedtype ActionType
    func menuItemPressed<T: MenuItemable>(_ menuItem: T) where T.ActionType == ActionType
}

// the menu item has been designed to be generic around any action type (e.g. any enum)
final class MenuItem<T, U: MenuItemDelegate>: NSMenuItem, MenuItemable where T == U.ActionType {
    typealias ActionType = T
    typealias DelegateType = U

    private weak var delegate: DelegateType?
    var actionType: ActionType
    var viewState: MenuItemViewStating {
        didSet { bind(viewState) }
    }

    init(viewState: MenuItemViewStating, actionType: ActionType, delegate: U) {
        self.viewState = viewState
        self.delegate = delegate
        self.actionType = actionType
        super.init(title: viewState.title, action: #selector(action(_:)), keyEquivalent: viewState.keyEquivalent)
        bind(viewState)
        self.target = self
    }

    @available(*, unavailable)
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDelegate(_ delegate: DelegateType) {
        self.delegate = delegate
    }

    // MARK: - private

    @objc
    private func action(_ sender: NSMenuItem) {
        delegate?.menuItemPressed(self)
    }

    private func bind(_ viewState: MenuItemViewStating) {
        title = viewState.title
        keyEquivalent = viewState.keyEquivalent
        isEnabled = viewState.isEnabled
    }
}
