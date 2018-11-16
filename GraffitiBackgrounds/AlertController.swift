import AppKit

// sourcery: name = AlertController
protocol AlertControlling: Mockable {
    func showAlert(_ alert: Alert)
}

class AlertController: AlertControlling {
	private let notificationCenter: UserNotificationCentering

	init(notificationCenter: UserNotificationCentering) {
		self.notificationCenter = notificationCenter
	}

    func showAlert(_ alert: Alert) {
        log("showing alert: \(alert.text)")

		let notification = NSUserNotification()
		notification.identifier = UUID().uuidString
		notification.title = alert.title
		notification.informativeText = alert.text
		//notification.soundName = NSUserNotificationDefaultSoundName
		notificationCenter.deliver(notification)
    }
}
