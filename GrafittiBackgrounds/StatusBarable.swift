import AppKit

// sourcery: name = StatusBar
protocol StatusBarable: Mockable {
    func statusItem(withLength length: CGFloat) -> NSStatusItem
    func removeStatusItem(_ item: NSStatusItem)
}
extension NSStatusBar: StatusBarable {}
