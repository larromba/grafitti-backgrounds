import Foundation

protocol UserNotificationCentering {
    func deliver(_ notification: NSUserNotification)
}
extension NSUserNotificationCenter: UserNotificationCentering {}
