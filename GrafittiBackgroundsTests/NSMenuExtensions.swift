import Cocoa
@testable import Grafitti_Backgrounds

extension Menuable {
	func click(at index: Int) -> Bool {
		guard let menu = self as? NSMenu, let menuItem = menu.item(at: index) else {
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
