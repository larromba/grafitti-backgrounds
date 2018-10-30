import Foundation

struct MenuItemViewState {
    let title: String
    let keyEquivalent: String
    let isEnabled: Bool
}

extension MenuItemViewState {
    func copyWithIsEnabled(_ isEnabled: Bool) -> MenuItemViewState {
        return MenuItemViewState(
            title: title,
            keyEquivalent: keyEquivalent,
            isEnabled: isEnabled
        )
    }
}
