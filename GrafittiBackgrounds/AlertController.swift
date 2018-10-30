import AppKit

// sourcery: name = AlertController
protocol AlertControlling: Mockable {
    func showAlert(_ error: Error)
}

class AlertController: AlertControlling {
	func showAlert(_ error: Error) {
		let alert = NSAlert(error: error)
		_ = alert.runModal()
	}
}
