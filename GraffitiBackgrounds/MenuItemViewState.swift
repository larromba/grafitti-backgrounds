import Foundation

protocol MenuItemViewStating {
    var title: String { get }
    var keyEquivalent: String { get }
    var isEnabled: Bool { get }

    func copy(isEnabled: Bool) -> MenuItemViewStating
}

struct MenuItemViewState: MenuItemViewStating {
    let title: String
    let keyEquivalent: String
    let isEnabled: Bool
}

extension MenuItemViewState {
    func copy(isEnabled: Bool) -> MenuItemViewStating {
        return MenuItemViewState(
            title: title,
            keyEquivalent: keyEquivalent,
            isEnabled: isEnabled
        )
    }
}
