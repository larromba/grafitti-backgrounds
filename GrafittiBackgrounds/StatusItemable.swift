import AppKit

// sourcery: name = StatusItemable
protocol StatusItemable: Mockable {
    func statusItem(withLength length: CGFloat) -> NSStatusItem
    func removeStatusItem(_ item: NSStatusItem)
}
extension NSStatusBar: StatusItemable {}
