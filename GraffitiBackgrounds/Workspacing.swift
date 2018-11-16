import Cocoa

// sourcery: name = Workspace
protocol Workspacing: Mockable {
    // sourcery: returnValue = true
    func open(_ url: URL) -> Bool
}
extension NSWorkspace: Workspacing {}
