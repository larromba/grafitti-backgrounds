import Foundation

// sourcery: name = UserNotificationCenter
protocol UserNotificationCentering: Mockable {
    func deliver(_ notification: NSUserNotification)
}
extension NSUserNotificationCenter: UserNotificationCentering {}
