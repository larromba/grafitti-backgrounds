import Cocoa
@testable import Graffiti_Backgrounds

extension Menuable {
    @discardableResult
    func click(at index: Int) -> Bool {
        guard let menu = self as? NSMenu, let menuItem = menu.item(at: index) else {
            return false
        }
        return menuItem.click()
    }
}

extension NSMenuItem {
    @discardableResult
    func click() -> Bool {
        guard let action = action else {
            return false
        }
        return NSApp.sendAction(action, to: target, from: nil)
    }
}
