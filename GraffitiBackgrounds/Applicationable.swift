import Cocoa

// sourcery: name = Application
protocol Applicationable: Mockable {
    func activate(ignoringOtherApps flag: Bool)
    func orderFrontStandardAboutPanel(_ sender: Any?)
    func orderFrontStandardAboutPanel(options optionsDictionary: [NSApplication.AboutPanelOptionKey: Any])
    func terminate(_ sender: Any?)
}
extension NSApplication: Applicationable {}
