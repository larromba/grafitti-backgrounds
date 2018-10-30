import Cocoa
@testable import Grafitti_Backgrounds

extension Menuable {
	func click(at index: Int) -> Bool {
		guard let menuItem = item(at: index) as? NSMenuItem else {
			return false
		}
		return menuItem.click()
	}
}

extension NSMenuItem {
	func click() -> Bool {
		guard let action = action else {
			return false
		}
		return NSApp.sendAction(action, to: target, from: nil)
	}
}

extension MenuItemable {
    func click() -> Bool {
        guard let casted = self as? NSMenuItem else {
            return false
        }
        return casted.click()
    }
}
