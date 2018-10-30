import Cocoa

// sourcery: name = WindowController
protocol WindowControlling: Mockable {
    var contentViewController: NSViewController? { get set }

    func showWindow(_ sender: Any?)
}
extension NSWindowController: WindowControlling {}
