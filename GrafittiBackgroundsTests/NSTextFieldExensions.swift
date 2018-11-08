import Cocoa
@testable import Grafitti_Backgrounds
import XCTest

extension NSTextField {
	func fireTextChagedEvent(in delegate: NSControlTextEditingDelegate) {
		delegate.controlTextDidChange!(
			Notification(
				name: NSNotification.Name(""),
				object: self
			)
		)
	}
}
